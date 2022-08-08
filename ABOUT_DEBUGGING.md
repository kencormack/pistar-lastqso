# PISTAR-LASTQSO's BUILT-IN DEBUGGING MECHANISM
## Facilitating a debug log, using a file descriptor, traps, and other bash built-ins

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/scr-debug.jpg)

# About

This file will attempt to explain the method I chose to use, to
implement a debugging log feature, in the pistar-lastqso script.

# THE DEBUGGING LOG...

This feature is intended for use during testing & development.

USING THIS CAN HAVE A HUGE PERFORMANCE IMPACT ON A PI ZERO!

It's use by the user will yield no ill effects (other than the
performance impact noted), and the output contained in the
resulting debugging log may be of limited (if any) value to
the user.  But for those thinking of their own scripts, or
who would modify pistar-lastqso for their own needs, the
debug log feature demonstrated here could be of some help.

## How it is used

Creating a debug log is done by redirecting file descriptor
3 to a logfile of your choosing, when launching pistar-lastqso
from the commandline.  Basic output redirection should be
nothing new to anyone who has spent a reasonable amount of
time using any UNIX or Linux shell, so I won't go into detail
regarding the basics of output redirection.
```
$ pistar-lastqso [any options and parameters] 3> /tmp/debug.log
```

Why "3"?  Because linux normally has three built-in file
descriptors already spoken for, by default.  They are:

- File Descriptor 0: stdin  (keyboard, "< filename", etc.)
- File Descriptor 1: stdout (standard output)
- File Descriptor 2: stderr (standard error)

This script adds, for the duration of it's execution, file
descriptor 3, as an I/O channel we can send debugging data to.
You can think of it as:

- File descriptor 3: debug

Normal screen output will be unaffected.  But behind the scenes
it is also writing debugging information.  This always-generated
information either goes to the bit-bucket (/dev/null) when NO
redirection of fd3 is specified on the commandline, OR is sent
TO the user-specified logfile.  There is no cross contamination
between screen and debug output.

## How it is implemented
## Step 1 - Inheritance

Set up the inheritance needed to gather what we need, within
functions.

Ensure that ERR traps are inherited by functions, command
substitutions, and subshell environments.
```
set -o errtrace
```

Ensure that DEBUG and RETURN traps are inherited by functions,
command substitutions, and subshell environments.  (The -E
causes errors within functions to bubble up.)
```
set -E -o functrace
```

## Step 2 - Create the file descriptor

If it doesn't already exist, create the file descriptor.
```
[ -e /proc/self/fd/3 ] || exec 3> /dev/null
```

## Step 3 - The DEBUG, ERR, and RETURN traps

Next, we define the traps that leverage the file descriptor.
The "errtrace" and "functrace" options we enabled above, allow
these traps to operate as intended within functions, as well.

The DEBUG trap...

This trap writes each line to be executed, just before it is
executed, to the debug log.
```
trap 'echo -e "line#: ${LINENO}...\t${BASH_COMMAND}" >&3' DEBUG
```

The ERR trap...

This trap will log all non-0 return codes.  To prevent some
commands from tripping an ERR trap by returning a non-0 return
code, I'm imediately following those commands with "|| :"
("or true").  An example would be a grep that doesn't find it's
search string (return code 1).  In other words, not all non-0
return codes are "errors" per se, but the trap will spot and
report them.  These can then be investigated to determine if
an actual error has occurred.
```
trap 'echo -e "NON-0: LINE ${LINENO}: RETURN CODE: ${?}\t${BASH_COMMAND}" >&3' ERR
```

The RETURN trap...

This trap logs the completion of each function, upon return.
```
trap 'echo -e "leave: ${FUNCNAME} -> back to ${FUNCNAME[1]}\n" >&3' RETURN
```

## Step 4 - Logging entry into a function

Because the RETURN trap, above, logs only the return FROM a
function, and not the entry INTO a function, I have added the
following to every function of the script.  It logs the full
chain of nested functions that have taken me to that function.
```
echo -e "\nenter: ${FUNCNAME[*]}" >&3
```

## Step 5 - Closing the file descriptor

Closing the file descriptor with the following, is performed
in functions fnCHECK_MODES_ENABLED, fnABORT, and near the
bottom of the script, just before the script re-launches
itself.
```
exec 3>&- 2> /dev/null
```

## Step 6 - Trapping an unexpected abort

A trap is used, to call a function named "fnABORT", in case the
script terminates prematurely due to any of the signals listed.
One of the commands it includes is to close the file descriptor.
In the event the script fails to reach it's end normally, the
fnABORT function will ensure the file descriptor gets closed.
```
trap fnABORT SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM
```

## Step 7 - Detecting redirection

The following detects whether file descriptor 3 has been
redirected to a file.  This is performed after the "exec" that
sets up the file descriptor.
```
DEBUG_LOG="$(readlink /proc/self/fd/3 2>/dev/null)"
```

If no redirection has been applied by the user, "${DEBUG_LOG}"
will be "/dev/null".  But if the user has redirected fd 3 to a
file, then "${DEBUG_LOG}" will contain the name (with full
path), to the file.
```
if [ "${DEBUG_LOG}" != "/dev/null" ]
then
  ...
fi
```

# How I use these during testing

When working on the pistar-lastqso script, I generally call upon the
debugging feature, to ensure that I have all the diagnostics I need,
to troubleshoot any problems.
```
$ pistar-lastqso [any options and parameters] 3> /tmp/debug.log
```

# In closing

This document may be a little rough at the moment, but it
includes all of the information needed to explain how the
debug log feature was implemented.  The bash documentation
will give more information on every aspect of what's being
used here.

