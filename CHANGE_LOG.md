```
CHANGES: V2.08
 !. The depth of the history displayed as part of the "-t|--top"
    now supports a runtime option to change the number of lines
    of history displayed.

    By default, the use of "-t|--top" provides a history of the
    last five QSOs observed.  However, by specifying an integer
    parameter, the number of QSOs displayed in the history can be
    changed.  A value of 0 (zero) disables the history (but retains
    all the other information in the "-t|--top" section of the
    screen.  Other values determine the number of lines of history
    that will be displayed.

    Examples:
      -t       defaults to 5 lines of history
      -t 0     disables the history
      -t 7     displays a history 7 lines deep
      -t 23    displays a history 23 lines deep

    CAUTION: Specifying too many lines for your actual screen-size
    will yield unpredictable (and certainly unsatisfactory) results.
    I do NOT limit-check this parameter, because SSH sessions in
    dynamically resizable windows could have a different number of
    lines each time the screen is re-sized, rendering useless any
    limit-check performed at startup.

    As a point of reference, "--t 10 -nobig" will maximize the size
    of the history, while still allowing full details for the QSO
    in progress (without large fonts), on a typical 80x24 display.
    Larger screens will support other combinations.  Feel free to
    experiment - YMMV.

CHANGES: V2.07
 1. Fixed warning tallies (was writing error #'s,
    not warnings, to the warning-tally file.)

CHANGES: V2.06
 1. Added display and tally of log WARNINGS, in
    the same fashion as errors.  Like the errors,
    warning tallies are reset when the script is
    exited with ^C, but are carried forward when
    the script restarts itself when the log rolls
    at midnight UTC, or when pistar-update cycles
    the services.  However, unlike errors, WARNINGS
    are NOT supressed with the -e|--errors option.
 2. Updated the help screen to describe the above.
 3. Made all tally-tracking tmpfiles unique to each
    instance of the script, in the event multiple
    instances are running concurrently.  An example
    would be if an instance were left running on
    the console in your radio room, and you then
    checked in via SSH from your laptop in the
    kitchen.  Each will have their own tally counts,
    independent of the other running session.
 4. Strip "-d|--dat" from any cmdline options
    before auto-relaunching, so that the script
    doesn't re-download the cty.dat file each time
    the log rotates, or when pistar-update runs.
    (Same behavior as with the "-c|--csv" option.)
 5. Improved the handling of Wires-X related RF and
    NET response, in the QSO details and "-t|--top"
    history.

CHANGES: V2.05
 1. Show DMR server descriptive name, rather than
    FQDN, in "-t|--top" section of the display.
 2. Expand the "To" and "From" fields to 10 chars
    each, in the "-t|--top" section of the screen,
    for longer YSF identities. (Ex: "AMERICALNK").
 3. Added percentage of QSOs that were Kerchunks,
    to the exit screen.
 4. Corrections to help & usage regarding behavior
    when invalid -f|--font # is given on cmdline.
 5. Add the additional perl script "dscc.pl" by
    Fabian Kurz, DJ1YFK.  http://fkurz.net/ham/dxcc/
    to support lookup of Country based on callsign,
    since YSF lacks the equivalent of DMR's user.csv
    file.  Updated the install to include dxcc.pl.
 6. Add new cmdline option "-d|--dat" to force the
    update of the "cty.dat" file used by dxcc.pl.
    If the option is NOT used, the file is updated
    automatically when the presently installed copy
    has aged 30 days.
 7. Updated the install script to accomodate dxcc.pl

CHANGES: V2.04
 1. Added option "-l|--logo" to disable the logo
    screen at startup.  This option is now invoked
    when the script restarts (at service bounce or
    when the log is rotated) regardless of whether
    it was originally passed on the cmdline.
 2. Fixed a bug that was downloading the user.csv
    file twice at startup, when "-c|--csv" was used.

CHANGES: V2.03
 1. Fixed a DMR bug which under some circumstances
    would overwrite Duration, BER, and Loss values
    with the solid-line separator.
 2. Clear the screen upon auto-restart.
 3. Tweaked the "-t" section to do a better job
    of clearing any artifacts created when an SSH
    window is re-sized.
 4. Added some instructions to the top of the
    help, explaining how to navigate the help.
 5. Rearranged a few settings in initialization.

CHANGES: V2.02
 1. Added new "-e|--errors" commandline option, to
    suppress the reporting of error messages found
    in the MMDVM log as they occur.  THIS DOES NOT
    FIX ANY ISSUES.  IT MERELY STOPS THIS SCRIPT
    FROM TELLING YOU ABOUT THEM.  Any error msgs
    are still tallied for the session, and that
    number is still reported on the exit screen.
    You simply wont see them as they occur.

    NOTE: Ocassional or sporadic low numbers are
    to be expected from time to time.  Errors,
    such as RF queue overflows, can and do happen.
    But significant numbers of such errors are
    YOU'RE RESPONSIBILITY to investigate.  Also,
    any logged errors are coming from pi-star, not
    from pistar-lastqso.  I cannot resolve them.
    They are a matter for the pi-star forums to
    address.

 2. Finally fixed traps on SIGWINCH, to catch the
    resizing of SSH windows.  Hadn't occurred to
    me that traps for that signal aren't inherited.
    As a result, incoming traffic no longer corrupts
    the "-t" display area, when an SSH windows is
    resized.

 3. Small changes to the order of some of the
    initializations steps, and other misc. cleanups.

CHANGES: V2.01
 1. Added a new "-m|--mono" commandline option, to
    supress all color control codes when using a
    monochrome display or terminal.
 2. Added "Mode" and "Src" fields to the YSF QSOs.
 3. Tweaks to the "-t" display area.
 4. YSF callsigns would sometimes skew log parsing
    when the callsign was in the form "KE8DPF KEN",
    where people would add space-separated text
    (such as their first name) to their radio's
    transmitted callsign.  Such extra data is now
    filtered out.
 5. Increased decimal precision from 3 to 4 places,
    in the display of TX and RX frequencies, in the
    "-t" display area.
 6. Addd "DMR" and "YSF" to the title screen.

CHANGES: V2.00
 1. The script has been renamed, to PISTAR-LASTQSO,
    as it is no longer DMR only.
 2. The script now supports the following modes:
    DMR, YSF, DMR2YSF, and YSF2DMR.  In addition
    to new routines, several existing ones were
    modified to accomodate the additional modes.
 3. Removed the "Type" and "ESS" fields from the
    top section of the screen (shown with "-t"),
    to report the YSF master server in that space.
 4. Tweaks to commandline parsing, to fix display
    of usage examples if invalid option passed on
    commandline.  (Broke, when adding the forcing
    of a font for figlet, on the commandline.)
 5. A few minor cleanups suggested by shellcheck.

** PISTAR-LASTDMR ENDS - PISTAR-LASTQSO BEGINS **


CHANGES: V1.39
 1. Tighten up the leading with figlet's "big" and
    "ansi_shadow" fonts.  These two fonts have an
    extra blank line under them that can be wasteful
    of limited screen space.  This change recovers
    the extra blank line that follows these fonts.
 2. Added count of errors appearing in the MMDVM log.
    Like the other counts, the count is reset each
    time the user launches the script from the
    commandline, but the running total continues
    any time the script automatically restarts
    itself due to log rotation or nightly
    pistar-update.
 3. Set umask to tighten permissions on the QSO,
    kerchunk, and new error-count tracking files.
 4. Set pi-star as owner/group of the user.csv
 5. A few other minor tweaks.

CHANGES: V1.38
 1. Added block count to history at top of screen,
    when transmission is a data transfer.
 2. Version 1.37's "improved filtering" of log
    entries inadvertantly supressed Talker Alias
    reporting.  This has been fixed.  Thanks to
    Neil Neil for reporting this issue.

CHANGES: V1.37
 1. Improved filtering of log entries to process.
 2. Automatic responses such as "not linked",
    received in reply to a 4000-disconnect (for
    example) are no longer counted as kerchunks.

CHANGES: V1.36
 1. Calls < 2.0 seconds are marked "[[kerchunk]]".
    Though a running count is not displayed like
    the QSO numbers, a total kerchunk count is
    tracked, and shown at program exit.
 2. Streamlined some redundant calls to some
    functions, in the main loop.
 3. Added some "future use" infrastructure
 4. Made both the install and pistar-lastdmr scripts
    executable in the repository, so that when
    "git clone" or "git pull" is performed, the
    downloaded files will already be executable,
    saving the user from having to chmod anything.

CHANGES: V1.35
 1. Fixed a bug in a tput capability test, when run
    on the console.
 2. Cleanups to help screens and comments.

CHANGES: V1.34
 1. Added a count of the number of QSOs directly
    observed by pistar-lastdmr.  Each QSO shows
    the running count, and upon exit with Ctrl-C,
    the exit screen shows the total number of QSOs
    the program watched.  The count is reset each
    time the user launches the script from the
    commandline, but the running total continues
    any time the script automatically restarts
    itself due to log rotation or nightly
    pistar-update.
 2. Fixed a bug with date conversion from UTC,
    where the displayed date-stamp of the QSO,
    localized from the log entry's UTC date stamp,
    showed the wrong date after UTC-midnight.
    Thank you, to Cal Kutemeier, for spotting the
    bug (which had gone unnoticed since day-one!)

CHANGES: V1.33
 1. Updated the README.md file
 2. Fixed bug that refused to accept the new
    [-f|--font <1-4>] if it was the only option
    specified on the commandline, and improved
    the test for valid numeric parameter values.

CHANGES: V1.32
 1. Added an "install" script.
    See the Installation section of the README.md,
    on the github page.

 2. In the past, pistar-lastdmr has automatically
    selected between two installed fonts, when
    figlet is installed, based on the width (in
    characters) of the user's screen.  This auto-
    selection has been reworked to include a
    third "big" font, in addition to the previous
    "small" and "standard" figlet fonts.  All 3
    of these fonts are part of the base figlet
    package available with "apt install figlet".

    Thresholds for auto-selection are based on
    the screen-width (in characters) as follows:

       <= 80 chars... "small" font
      81-120 chars... "standard" font
       > 120 chars... "big" font

    One additional supplemental font has been added
    to this update of pistar-lastdmr.  The font is
    called "ansi_shadow" - the same font as is used
    in the logo screen of this script.

    However...

    Unlike the other three fonts listed above, the
    ansi_shadow font is NOT auto-selected, but is
    available only via a new commandline option.

    So, keep reading...

 3. The script now supports a new commandline
    option to override auto-selection, and force a
    given font regardless of screen-width.

    The new "[-f|--font <number>]" commandline
    option requires a numeric parameter to select
    between the fonts:

    To force one of the base fonts...
      "-f 1" force figlet's "small" font
      "-f 2" force figlet's "standard" font
      "-f 3" force figlet's "big" font

    To force the supplemental font...
      "-f 4" force the "ansi_shadow" font

    If the -f option is omitted, or is passed an
    invalid value, the script will auto-select an
    appropriately sized base font.  It will never
    auto-select the supplemental font.

    *** IMPORTANT *** IMPORTANT ** IMPORTANT ***

    Note that for any given font you force, figlet
    may decide it needs to line-wrap the output.
    This can waste a lot of screen space if you
    use a too-large font on a too-small screen.
    If that happens, try a lower-number parameter
    for the "-f" option, to select a smaller font.

CHANGES: V1.31
 1. Work around console "TERM=linux" lack of support
    for tput's alternate screen buffer.  On the
    console, the screen is now just cleared.
    Added detection of the alternate screen buffer
    only for term types that support it (such as
    TERM=xterm, and others often used with SSH).
 2. Data Transmissions were not being listed in
    the history at the top of the screen (when the
    [-t | --top] option is passed on the command
    line.)  This has been corrected.  Log entries
    corresponding to the end of a data transmission
    do NOT record a duration, or BER, thus Data
    Transmissions displayed in the history show
    only "-----" in those columns.  Likewise, as no
    Loss or RSSI is logged, the last column merely
    states "Data Transmission".
 3. Lose outdated "seq" calls in box drawing loops.
 4. Minor cosmetics.

CHANGES: V1.30
 1. Files "DMRIds.dat" and "TGList_BM.txt" are no
    longer hard-coded assumptions, but are now
    parsed from pistar's mmdvmhost config file
    and HostFilesUpdate.sh script.  The MMDVM log
    location and filename is likewise no longer
    assumed, but parsed from the mmdvmhost file.
 2. The pi-star file /usr/local/etc/DMR_Hosts.txt
    is now checked to determine if your DMR network
    master is a BrandMeister server.  When the DMR
    network is NOT BrandMeister, the script no
    longer attempts a BM API query to fetch your
    list of static talkgroups.  For non-BM DMR
    networks, line #4 at top of screen now states
    "Network is not BrandMeister - No API available
    to retrieve any Static TGs"
 3. Additional UTF-8 unicode chars added to function
    fnDEFINE_BOXCHARS, and drop-shadow capability
    added to function fnDRAW_BOX.
 4. Added a check to ensure DMR mode is actually
    enabled in /etc/mmdvmhost, and added an abort
    screen if DMR not enabled.
 5. Renamed a few functions. 

CHANGES: V1.29
 1. Use alternate display buffer for QSOs.  Recycle
    the startup screen as an exit screen.
 2. Added a box-drawing function to facilitate the
    startup/exit screen.
 3. Small update to the help screen text.
 4. Changed help screen pager from "more" to "less",
    for more versatile scrolling on small screens
    having fewer rows.

The screen manipulation features used by this tool
require that the user's display & configuration
support the following features:
 A. a UTF-8 character set
 B. the $TERM type in use supports tput's cursor
    control, color, scrolling, and alternate display
    buffer commands

For HDMI console use, pi-star's default configurations
should prove sufficient.

For SSH users, some of these features will depend on
your SSH client's configuration, the specific $TERM
and emulation you are using, and their ability to
render color, line-drawing characters, etc. 

CHANGES: V1.28
 1. The contact's DMR ID is now shown regardless of
    whether the contact is the "from" or the "to".
 2. If the Callsign maps to more than one ID#, the
    ID# will be followed by (*) to indicate that
    multiple IDs are registered to the Callsign.
    Remember, the ID# displayed is only a guess, in
    cases where multiple ID#s are mapped to the same
    Callsign.  They are, however, certain, when the
    Callsign maps to only one ID#.  (See comments
    regarding V1.27, Change #1, for more info.)
 3. Improved support for line/box-drawing characters
    in UTF-8 character sets.  Updated the start-up
    title screen with more info, and a little color.

CHANGES: V1.27
 1. Added display of the DMR ID#
 2. Updated the README.md file

DISCUSSION about Change #1, above:
The MMDVMHost daemon internally knows the actual DMR
ID# of the user, and does ID number to Callsign look-
ups from DMRIds.dat.  However, in the logfile, you
end up with the Callsign, but lose the ID number.
Disabling this lookup gains you the ID numbers in the
logfile, but loses the Callsigns.  I can quite easily
perform an ID to Callsign lookup within the script,
but the pi-star web interface would suffer the loss
of the Callsign, were the lookups disabled for the
MMDVMHost process.  Pi-star web-based Dashboard users
wouldn't appreciate that *at all*.  So, I work back-
wards, taking the Callsign that MMDVMHost writes to
the logs, and looking up the ID in the DMRIds.dat file.

But there's a small problem with that approach...

In the early days of DMR, some users were registering
for multiple IDs (one for each radio, one for each
hotspot, etc.)  The prefered method of identifying
hotspots today is by adding a two-digit suffix to the
user's normal 7-digit ID, for example.  However,
those earlier cases of multiple ID numbers mapped to
the same Callsign still exist in the file.  Each DMR
ID links to only one Callsign, but not every Callsign
links to just one ID.  (I saw one callsign that has
EIGHT consecutive DMR ID numbers associated with it.)
With no guarantee that I'm picking the correct ID
linked to a given Callsign, I just pick the first
number, on the assumption that that's the one that
represents the user, not one of their hotspots, etc.
I wish MMDVMHost would log both Callsign and ID#.
But it's one or the other, not both.  So, the choice
was between pissing off the GUI dashboard users, or
living with a miniscule chance that the wrong ID
number (for callsigns that have multiple IDs only)
would be displayed.  For the vast (VAST!) majority of
cases, my "lesser of two evils" approach will serve
well enough.

CHANGES: V1.26
 1. When a hotspot's static TGs are fetched, they
    are stored in a tmp file.  The file is now more
    secure, and only created with -t (or --top).
 2. fuser logfile checks are now more frequent, to
    react faster to log rotation and service
    shutdowns.
 3. Figlet output is now stored in a variable.

CHANGES: V1.25
 1. Use "fuser", rather than "pidof", to determine
    the specific PID of the "tail" command that
    drives the main loop.  This, to avoid killing
    any other "tail" that might be running on the
    system.
 2. Timestamp of the history entry was not matching
    the start time of the QSO.  This has been fixed.

CHANGES: V1.24
 1. Update the call history with the most recent
    call, as soon as the call ends, rather than
    waiting until the next call begins.
 2. Reduced the number of calls to re-draw the no-
    scroll region, from once per log line, to once
    per QSO.  Current QSO is now more responsive.
    The cost is that if an SSH window is re-sized,
    refresh of the no-scroll region won't occur
    until the current QSO completes.
 3. Added column boundaries to blank entries in the
    the history section at top, at startup.
 4. Floating-point comparisons using expr were
    unreliable, when colorizing BER and LOSS.
    Values would end up the wrong color.  Re-worked
    floating-point compares to use awk, instead.

CHANGES: V1.23
 1. Colorized the history fields.

CHANGES: V1.22
 1. Show total # of static talkgroups.
 2. Fixed a typo in a variable name.
 3. Updated help screen description of -t|--top.
 4. When multiple commandline options are passed to
    the script, those that should then exit (-h and
    -v) now take priority, regardless of the order
    in which they appear on the commandline.
    Example:  When both -c (update user.csv)
    and -h (help) are passed, and -c is given first,
    the -h now overrides the -c, displays the help
    screen, and then exits, rendering the -c option
    inoperative for that invocation of the script.
 5. Fixed colorizing of LOSS to red, when BER >= 3.0.
 6. Added additional syncs before remount as ro, after
    downloading user.csv file.
 7. Minor improvement to trigger response, when log
    activity stops.
 8. Miscellanious minor tweaks.

CHANGES: V1.21
 1. Unwittingly introduced a dependency in v1.20's
    change #1, that was not intended.  Retrieval of
    static TGs has been reworked, and the dependency
    has been removed.
 2. In cases where users have large numbers of TGs
    statically mapped, this script will list only
    the first 5 (max) statically linked TGs, due to
    available screen space.

CHANGES: V1.20
 1. Added Node Type (Public or Private), ESSID, the
    user's chosen DMR Master Servername, and a list
    of the user's static BM TGs (and their TS) to
    the top of the screen.
 2. Added a history of the last 5 QSOs.
 3. Modified WINCH trap.
 4. Minor mods to other display elements
 5. Suppress errors when checking date of user.csv
    before the file is downloaded for the first time.

CHANGES: V1.19
 1. Fixed a bug introduced with change #2 in V1.18

CHANGES: V1.18
 1. Minor changes to the help screen and some comments.
 2. Moved the grooming of commandline options, which avoids
    repeated downloading of user.csv with every auto-restart,
    to the function fnPARSE_CMDLINE().
 3. Added TG/PC name lookups for the "From" field, in the same
    fashion they are performed for the "To" field, using the
    MY_LIST.txt file.
 4. Minor cosmetic changes to the non-scrolling region.

CHANGES: V1.17
 1. Small tweaks to the no-scroll region.  Added pi-star version.
 2. Clear the screen during start/restart.
 3. Added SIGTERM to the trap to shut down the script.

CHANGES: V1.16
 1. Use perl for the floating-point math.

CHANGES: V1.15
 1. Occassionally, pistar.uk is unable to obtain an updated list
    of talkgroups from BrandMeister, due to an API failure.
    When this happens, the pi-star nightly update overwrites the
    TGList_BM.txt file with nothing but an error message, and
    pistar-lastdmr can't display the names of talkgroups.  To
    explain the absence of talkgroup names, pistar-lastdmr now
    notes the corruption of the TGList_BM.txt file, in the non-
    scrolling section of the screen.
 2. Get the TX and RX Frequencies from the MMDVM* log file, instead
    of from the /etc/mmdvmhost file, for the -t|--top section
    of the screen.

CHANGES: V1.14
 1. Added TCXO value to the non-scrolling information area.
 2. Ensure cursor goes to the bottom of the screen, on exit.
 3. In normal operation, this script restarts itself any time the
    MMDVMHost service is interupted (eg: during pi-star's nightly
    update), or when the service rotates to a new day's log file.
    When it re-launches itself, it passes the same parameters to the
    new instance that were given to the initial instance (eg: "-t").
    To prevent the script from repeatedly downloading the user.csv
    file each time it restarts, I now remove "-c" (if present) from
    the list of parameters given to the initial instance, so that
    it does not pass "-c" to subsequent restarts.

CHANGES: V1.13
 1. Added a non-scrolling zone to the top of the screen.  This
    zone shows the version number of this script, the date of
    the user.csv file, name of the active log file, TX/RX freqs,
    and hotspot firmware version.
 2. "Usage" message and help screens updated.
 3. Added cursor controls.
 4. Moved screensize detection setup to the initialization part
    of the script, so that it can be called from anywhere we
    might need it.  Added detection of screen lines.
 5. Updates to comments, and other trivial tweaks.
 6. Improved start and stop of the background process.
 7. Reduced threshold for selecting the larger of two figlet
    fonts, from 100 to 80 columns wide.
 8. Reduced the number of calls to external commands.
 9. Added some bash "set -o" controls.

CHANGES: V1.12
 1. The screen-width is now dynamically sensed, should the user
    expand or change the window size of an SSH session such as
    PuTTY.  This allows the script to adjust the font used by
    figlet, based on the width (in columns) of the screen.

CHANGES: V1.11
 1. Removed reference to a figlet font that is not supplied by
    default, with the package.  If you get an error stating
    "unable to open font file", on screens wider than 100 chars.,
    this was the reason.

CHANGES: V1.10
 1. Added "-n 1" to the "tail -f" that drives the main loop, to
    ensure the loop begins parsing only from the last line, at
    startup or re-start (instead of parsing from about 10 or so
    lines from the end of the log, which was sometimes catching
    an already processed "trigger", placed in the log when the
    MMDVMHost service was bounced.)
 2. Reworked the trigger that exits the main loop whenever the
    MMDVMHost service releases the log file.  (In truth, it
    never worked.)  Changes #1 & 2 make behavior at MMDVMHost
    service bounce reliable and consistent.

CHANGES: V1.09
 1. Improved parsing of commandline options, with support for
    -c|--csv, -h|--help, -v|--version, and -n|--nobig options.
    Added a "Usage:" message to trap invalid options. 
 2. Minor cleanups and re-orgs to a few functions.
 3. Updates to some comments.
 4. Licensed under GPL 3.0

CHANGES: V1.08
 1. Minor cosmetic changes
 2. Minor cleanup to the trap that kills the bg job. 
 3. A title screen has been added to the start of the script.
 4. Minor style cleanups (quoting, missing curly braces, etc.)

CHANGES: V1.07
 1. Added a missing "exit" from the trap.  :/

CHANGES: V1.06
 1. Added a trap to clean up stop old background job if main script
    is stopped by the user, or dies.

CHANGES: V1.05
 1. Small change to the notification that log activity has stopped.
 2. Explicitly terminate the current background job before restarting.
 3. Fix a circumstance preventing background job from restarting.
 4. Increased sleep time before restart, from 30 to 45 seconds, to
    allow MMDVMHost service more time to settle, when the nightly
    pi-star update bounces the services.

CHANGES: V1.04
 1. Detection of log rotation (as changed for v1.01) wasn't working.  A
    child process is spawned to see when the MMDVMHost process has let
    go of the old log, signaling the parent, which triggers the script
    to re-launch it's self.
 2. Small cosmetic tweaks to the display of Date, Time, and other fields.
 3. Added "-t" to figlet to avoid unnecessary line-wrap on wide displays,
    and added a second (larger/brighter) font to use, on displays wider
    than 100 columns.
 4. Filter out TAs containing nothing but spaces.
 5. Added current working logfile name to the display, between QSOs.
 6. Added a check for end of RF-based data transmissions (I had previously
    only been watching for network-based data ends.)

CHANGES: V1.03
 1. Simplified conversion of log entry date/timestamps to "human readable"
    local timezone equivalents.  Removed "date +%z" UTC offset parsing,
    and forced the output to a consistent format, regardless of a timezone's
    localized defaults.
 2. Colorized "Listening..." and "...In Progress" status messages.

CHANGES: V1.02
 1. Removed unneeded readlinks from log filename checks.
 2. Ignore "late entry", "overflow", irrelevant TA lines from log.
 3. Improved change #2 made in V1.01 by making a second pass through the user.csv
    file, looking for the DMR ID rather than the callsign.

CHANGES: V1.01
 1. Fixed a problem that could miss a log rotation during Talker Alias handling.
 2. Update to handle someone using a country code DMR ID rather than a personal ID,
    that results in no callsign as the "from", and a bogus user.csv lookup.
 3. Don't display empty TA data.

V1.00 - Initial release with all planned features
```
