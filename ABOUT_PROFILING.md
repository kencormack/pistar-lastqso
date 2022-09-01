# PISTAR-LASTQSO's BUILT-IN PROFILING MECHANISM
## Facilitating a performance profiling log, using file descriptors, traps, and other bash built-ins

# About

This file will attempt to explain the method I chose to use, to
implement a performance profiling log feature, in pistar-lastqso.

# THE PROFILING LOG...

In a manner similar to the debug log mechanism (but requiring
less setup), the script also includes a means to profile how
long it takes for sections of the script to execute.

Using simple timestamped log entries, a rough idea of how long
any lines of code between "set -x" and "set +x" take to run can
be had.  Since I do not require subsecond precision, a simple
timestamp in the form of current "hh:mm:ss" is used on each line
of the profiling log.  The timestamp of a log entry being examined
is the time the command began executing.  Comparison to the
timestamp of the next subsequent line in the log will indicate
how long the line in question took, to complete.  The method used
for the timestamps is built into bash, and thus does not incur
any significant cost (as would forking an external "date" command).

The profiling log is created using file descriptor #4, and the
bash shell's "PS4" and "BASH_XTRACEFD" environment variables.
$PS4 is the shell prompt used to display any lines of code
executed when "set -x" is in effect.  $BASH_XTRACEFD tells bash
which file descriptor to send trace data to.

## How it is used

Creating a profile log is done by redirecting file descriptor 4
to a logfile of your choosing, when launching pistar-lastqso.
```
$ pistar-lastqso 4> profile.log
```

This adds, for the duration of it's execution, file descriptor 4,
as an I/O channel we can send profiling data to.  You can think
of it as:

- File descriptor 4: profiling

Normal screen output will be unaffected, and the script will
still generate it's normal output.  But behind the scenes it
is also writing profiling data.  This information either goes
to the bitbucket (/dev/null) when NO redirection of fd4 is
specified on the commandline, OR is sent TO the user-specified
logfile.  Again, this info is entirely seperate from the other
data streams.

## How it is implemented

The following block of code sets up the filedescriptor, tells
bash which fd to use, sets PS4 to show a timestamp and the line
number of each line logged, and makes the profiling data available
to file descriptor 4.
```
#---------------
# For a rough profiling of this script
[ -e /proc/self/fd/4 ] || exec 4> /dev/null
echo "SYSTEM_INFO v${MY_VERSION} - PROFILING LOG" >&4
echo -e "==================================\n" >&4
BASH_XTRACEFD="4"
# Using PS4, "\011" is a tab, and "\t" is a current hh:mm:ss timestamp
# (I don't need subsecond accuracy here.)
PS4='+\011\t ${LINENO}\011'
# Enclose any section of code we want to profile with "set -x"... "set +x".
# Profiling data will be sent to the fd whenever "set -x" is in effect.
# For now, I'll turn it on here, and basically profile the whole script.
set -x
```
The following detects whether file descriptor 4 has been redirected to
a file. This is performed after the "exec" that sets up the file descriptor.

```
PROFILING_LOG="$(readlink /proc/self/fd/4 2>/dev/null)"
```

If no redirection has been applied by the user, "${PROFILING_LOG}" will be
"/dev/null".  But if the user has redirected fd 4 to a file, then
"${PROFILING_LOG}" will contain the name (with full path), to the file.

```
if [ "${PROFILING_LOG}" != "/dev/null" ]
then
  ...
fi
```

The following lines are present at both the end of the script, and
in the fnABORT function, to ensure that trace data is no longer
sent to the file descriptor, and that the file descriptor is closed.
```
set +x 2>/dev/null
exec 4>&- 2>/dev/null
```

# How I use these during testing

When working on the pistar-lastqso script, I generally call upon both the
debugging and profiling features, to ensure that between the report's
usual output, and these additional logs, I have all the diagnostics I
need, to troubleshoot any problems.

```
pistar-lastqso 3> debug.log 4> profile.log

```

# In closing

This document may be a little rough at the moment, but it
includes all of the information needed to explain how the
profiling log feature was implemented.  The bash documentation
will give more information on every aspect of what's being
used here.

