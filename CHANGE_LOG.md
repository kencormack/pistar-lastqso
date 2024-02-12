```
CHANGES: V3.21
 1. Add support for M17's "text Data" messages

CACHE STATUS:  Updated - February 2024
 The license and grid caches contain more than
 100,000 US callsigns, based on US FCC data.
 The dxcc cache contains more than 1500 non-US
 callsigns observed during development/testing.

CHANGES: V3.20
 1. Begin adding support for M17.  Support for
    hotspot <--> internet traffic has been added.
    Support for radio <--> hotspot will require
    sample log entries from volunteers with an
    M17-capable radio, and appropriate pi-star
    and MMDVM firmware versions, as I don't have
    an M17 radio at this time.

 2. The format for DMR Talker Alias log entries
    changed, somewhere around pi-star 3.1.8.
    TA data used to be logged in chunks, and
    I'd have to make sure I had it all, before
    displaying it.  Now, the log entries only
    appear when the data is complete.  The
    script now handles both cases.

 3. Ignore "slow data text" log entries.

CHANGES: V3.19
 1. Added support for another vt100-type font.
    The double-wide (but this time, single-high)
    character set is available as -f|--font 6.
    Like font #5, #6 is also term-type and
    emulator dependent.

CHANGES: V3.18
 1. Some radios (such as the TYT MD-UV390/GPS)
    can transmit GPS data.  If GPS data is
    received, it will be displayed like this:
    GPS : Lat 41.071675° N, Long 81.492544° W

 2. Callsign filtering in DXCC cache handling
    is now same as used for grid and license
    caches, as modified for v3.17.

 3. The "-c" commandline option now also
    updates NXDN.csv, in addition to just the
    DMR user.csv file.

 4. When searching for QTH info, don't bother
    checking the NXDN.csv file when traffic is
    DMR (we'll find them in user.csv), and
    don't bother checking the user.csv file
    when traffic is NXDN (we'll find them in
    NXDN.csv).  All other modes will still
    check both files in case a callsign used
    in a different mode is also registered as
    either/both DMR and/or NXDN.

 5. Fixed bug, parsing log records containing
    square brackets "[" and "]".

CHANGES: V3.17
 1. Added a test to make sure a remote query
    for a Maidenhead gridsquare returns an
    actual gridsquare, not a null, error, or
    other unwanted result.

 2. Added a test to make sure a remote query
    for a U.S. license type returns a valid
    type, not a null, error, or other unwanted
    result.

 3. Ignore D-Star "invalid slow data header"
    log entries.

 4. Eliminated calls to the external 'date'
    command from elapsed time indicators.

 5. The install script preloads the dxcc,
    grid, and license caches with US-based
    callsigns, using FCC data from over 94000
    callsigns (as of May 2023).  The dxcc
    cache is also preloaded with several
    hundred non-US callsigns observed/logged
    during script testing and development.

 6. Add awareness of CLUB calls, for US-based
    callsigns.

 7. Improved filtering of callsign, to strip
    non-alphanumeric characters some people
    use when appending their name to their
    callsigns (KE8DPF/KEN, KE8DPF-KEN, and
    so on), often seen with YSF users.

CHANGES: V3.16
 1. Added new cmdline option "-F|--FCC" to
    display the amateur radio license class
    for US-based callsigns.

CHANGES: V3.15
 1. Fixed problem parsing RF transmissions
    for P25 (Thanks, Jerry, for the sample
    log entries!)
 2. Modified read syntax in BM TG queries,
    double-quoted some variables, & tweaked
    the curl command.
 3. Color changes in the -t|--top section:
    Reflector names/Startup hosts are now
    the same colors as both the large font
    displays, and the From/To history data,
    for a given mode.  Eg: Yellow is used
    for the YSF startup host, the large font
    display, and the history From/To, for all
    YSF traffic.  Since cyan is used for NXDN,
    all the field labels in the -t|--top
    section are now shown in gray.  Users of
    monochrome displays (-m|--mono) shouldn't
    notice much of a difference.
 4. Small mod to the test for possible corrupt
    download of user.csv.
 5. For test/dev - save unparsed records, to
    later determine if script should act on
    or ignore.
 6. Set LC_ALL=C for all "sort" operations.
 7. Improve fd3 debug log entry when entering
    a function.

CHANGES: V3.14
 1. Consolidated the separate tmpfiles for
    DMR, YSF, NXDN, DSTAR, P25, QSO, ERROR,
    WARNING, and KERCHUNK counts, into a
    single tmpfile.
 2. fnCOPY_CACHE now only acts when the current
    active caches differ from the saved caches.
    Also updated to avoid competition for file-
    system rw/ro status possibly disrupting
    whatever job is cycling the log.
 3. Tweaked the determination of PIDs, for
    the -i|--info display and other needs.
 4. Shellcheck pass.

CHANGES: V3.13
 1. Removed two unneeded search strings from
    the main loop tail/cat filter.
 2. Add overlooked "-r" to BM jq queries.
 3. Handle YSF "invalid access attempt from"
    log entries.

CHANGES: V3.12
 1. Found and fixed bug in BM TG jq queries.
 2. Reworked Grid Square lookup as json query.
 3. Handle DMR "network user has timed out"
    log entries.
 4. Updated the README to demonstrate polling
    of Brandmeister, to track Talkgroups in the
    non-scrolling "-t|--top" portion of the
    screen, via the "-p|--poll" cmdline option.

CHANGES: V3.11
 1. A more specific json query, and a variable
    expansion, removes two-each 'grep','cut',
    and 'sed' commands every time BM TGs are
    queried.  Eliminated a third call to 'jq'
    and 'grep' to determine number of TGs.
 2. Improved determination of linked reflectors
    for NXDN and P25.

CHANGES: V3.10
 1. For DMR users, BM Talkgroups shown in the
    "-t|--top" section now include dynamic, as
    well as static TGs.  Dynamic TGs are marked
    with an asterisk(*).
 2. In addition to the above, a new "-p|--poll"
    commandline option has been added.  This
    causes the script to poll the Brandmeister
    servers frequently, to keep the displayed
    list of linked TGs current, as a user links
    to, and disconnects from, dynamic TGs.  This
    can be a great help to folks who like to hop
    around between TGs.  See the help screen for
    details.
 3. Cache snapshots are saved any time logging
    stops and restarts.
 4. Fixed P25 network Loss% bug.
 5. shellcheck and beauty passes.

CHANGES: V3.09
 1. Switched to the BM API V2 style of query, to
    determine any BM static talkgroups, for DMR.
    (Insurance for the day the v1 API goes away.)
 2. To make parsing the BM API's JSON output safer
    and more reliable, the package "jq" is used.
    Pistar-lastqso's "install" script now installs
    the tool "jq" from the standard repos.
 3. Save any dxcc or grid caches upon exit, to
    preserve populated caches across reboots.
    Also preload caches from saved copies at launch.
 4. Updated "-i|--info" to display record counts
    of both the DXCC and Grid Square caches, and
    shorten the other counter lables to K, E, W,
    and R, for Kerchunks, Errors, Warnings, and
    Restarts.
 5. Changed the "-i|--info" block to retain the
    counts on the 7th line, when in replay mode,
    since the 1st line shows the replay option on
    the commandline.  Only the color change to
    yellow is preserved, as a quick reminder that
    replay mode is active.
 6. More history cleanups.
 7. Updated filter on the main read loop, to spot
    errors that were slipping through.
 8. Found a bug when looking up name/QTH data for
    YSF callsigns with a hyphenated suffix such
    as "-JIM" added to the callsign.
 9. Fixed similar bug with DXCC lookups.
10. Modified a few BER and LOSS array-parsed cuts
    with a less complex means.
11. Modified date inspection of user.csv and
    cty.dat files.

CHANGES: V3.08
 1. Reworked history initialization, moving the
    logic of fnLOAD_HISTORY_FILE into the outer
    "while true" loop, and fixed injection of the
    restart entry into the history.  Fixes the
    problems with history occasionally coming up
    cleared after restart, and all the previous
    restart indicators redisplaying in the history
    upon restart.
 2. Added expired watchdog parsing, for DMR.
 3. For testing/development, the entire log record
    is written to /tmp/unparsed_* now, rather than
    just what follows the timestamp.

CHANGES: V3.07
 1. Added NXDN support for RF voice transmissions.
 2. Add overlooked RF "late" entries, for DMR.
 3. Filter a few more strings the script doesn't
    need to waste time parsing, in fnMAIN_LOOP.
 4. Misc. minor tweaks.

CHANGES: V3.06
 1. Added P25 support for RF voice transmissions.
 2. Added a "catch all" to report unparsed log
    entries to DMR and YSF, similar to those for
    the other modes, in case I missed possible
    types of messages that should be parsed.
 3. Added parsing of "late" entries to DMR, found
    by change #2, above.
 4. Ignore CSBK/VSBK entries to DMR, found by
    change #2, above.
 5. Added a variant of network end of transmission
    to P25, found by change #2, above.
 6. Added a handler for P25 watchdog expired.
 7. Ignore a couple strings in P25 handling.
 8. Don't store null results in the dxcc cache.
 9. Tighten up spacing on errors and warnings.

CHANGES: V3.05
 1. Added a 2 sec. timeout, to the remote server
    queries for Grid Squares.
 2. Added a check for failed queries, to the new
    grid square lookups.  Negative responses
    ("Unknown") are no longer cached.

CHANGES: V3.04
 1. Added a new "-g|--grid" commandline option.
    This option enables the display of Maidenhead
    Grid Squares for US Callsigns only, based on
    the FCC address of record, for the Callsign.
    Learned Grid Squares are cached until reboot,
    to prevent repeated queries each time the same
    callsign appears.  The cache persists accross
    program stops and restarts, but is deleted at
    hotspot reboot.  If I can find a way to get
    grid squares for other callsigns (that is fast
    and will work within this shell script), I'll
    investigate that as well.  Grid Square lookups
    are disabled by default.
 2. Fixed a small DMR bug with user.csv lookups,
    when the callsign is associated with multiple
    DMR ID#s, and removed a couple of redundant
    calls to the cut command.
 3. Small fixes to cleanups at exit points.

CHANGES: V3.03
 1. Small cleanups to NXDN and P25 network traffic.
 2. Minor change to the check to see if an updated
    version of the script has been made available.
 3. Fixed D-Star network traffic not rolling up to
    history when "network watchdog has expired".
 4. Removed an unneeded search string from the main
    loop, along with two case conditions that would
    never apply.
 5. Turn off keyboard character echo during program
    run, and re-enable upon exit.

CHANGES: V3.02
 1. Fixed a bug with QTH lookups, for callsigns
    from YSF users who use "/" or "-" to combine
    their name with their actual callsign.  The
    change isolates the callsign, for lookup.
 2. Sometimes when queried via the API, BM lists
    the same static TG twice.  The script now
    removes the redundant reference to the TG.
 3. Minor stylistic cleanups, and updates to the
    README.

CHANGES: V3.01
 1. Added support for DSTAR RF log entries.
    Thanks to Gaute Alstad (LB6YD) for supplying
    me with appropriate sample log entries!

CHANGES: V3.00
 1. Restructured DMR processing a bit, to clean
    up parsing.  Folded a few of the small DMR
    functions back into fnDMR_MAIN.
 2. Fixed display of DMR MASTER in the -t|--top
    section, when YSF2DMR is used.
 3. Fixed display of YSF MASTER in the -t|--top
    section, when DMR2YSF is used.
 4. Added preliminary supprt for NXDN, D-Star,
    and P25 modes... Only network-based traffic
    can be parsed at this time.  As I do not own
    radios supporting these modes, I can't create
    for examination, the corresponding log entries
    for RF-based traffic.

CHANGES: V2.37
Since v2.30, approximately 100 calls to external
commands have been removed from the script,
replaced with built-in bash string manipulation
facilities.  This has vastly reduced the load on
Raspberry Pi Zero-based hotspots, particularly.

Coupled with the DXCC results caching (added back
in v2.33), I have yet to see my own Pi Zero fall
behind, during even the busiest flurries of YSF
kerchunkers.  I'm pleased with all of the recent
performance-centric improvements.

 1. Replaced almost two dozen more calls to awk,
    and grep, with bash variable expansions.
 2. RadioId.net had a problem resulting in the
    script downloading a 0-byte user.csv file,
    on Sunday, 25 Sept 2022.  Added a check to
    ensure we aren't updating with such a file.
    Thank you to Neil Redditch (M1CFK) for
    reporting the problem.
 3. Added same sanity test for the cty.dat file.
 4. THE SCRIPT NOW DEFAULTS TO 24-HR TIMESTAMPS.
    Added a new "-12|--12hr" command line option,
    to restore the previous 12-Hr am/pm format.
    Without this option, timestamps are 24-Hr.
    This brings the script more inline with the
    pi-star dashboard.
 5. Added "a" or "p" to the history timestamps,
    to differentiate am/pm, in 12hr mode.

CHANGES: V2.36
 1. Fix inadvertent clearing of history at log
    restart (bug introduced with v2.35 change
    number 8, below.)

CHANGES: V2.35
 1. Reorganized fnMAIN_LOOP, moving the DMR and
    YSF stuff to new fnDMR_MAIN and fnYSF_MAIN
    functions, called by fnMAIN_LOOP, and like-
    wise created stub functions as placeholders
    for other modes.
 2. Changes to the animated title screen, in
    hopes that one day I can add support for
    additional modes in the future.
 3. Added a new commandline option "-r|--replay".
    This option allows replaying a log for test
    and development purposes.  See the help text
    for details.
 4. Changed install location of pistar-lastqso
    from /usr/local/sbin to the more appropriate
    /usr/local/bin.  The install script takes
    care of this automatically.
 5. Fixed detection of the cross-modes, for the
    -i|--info section.
 6. Fixed glitch in reporting load averages.
 7. Additional small cleanups to clear stray
    artifacts from window size changes, in the
    -t|--top non-scrolling region.
 8. When logging stops/restarts, rescan data for
    the -t|--top zone, as the interruption may
    have been due to user config changes made in
    pi-star's GUI Configuration page.

CHANGES: V2.34
 1. BUGFIX - Your own YSF transmissions, to the
    hotspot, were not rolling up to the history.
    This has been fixed.  The bug was introduced
    when replacing a "cut", and forgetting to
    quote the field delimiter for BER.
 2. TX and RX Frequencies are now fetched from
    /etc/mmdvmhost, rather than from the working
    MMDVM logfile.
 3. Elapsed Time and Average Load now appear in
    the non-scrolling "-t|--top" block.
 4. Small changes to the -i|--info section.
 5. Active modes (DMR, YSF, etc.) are now checked
    each time the log is bounced or cycled.  This
    allows the -i|--info area to remain accurate
    after service bounce, when a bounce is due to
    modes being enabled/disabled in the pi-star
    GUI's "Configuration" page.
 6. Staged a few underlying elements that may
    be used as hooks to explore D-Star, NXDN,
    and P25.  THIS DOES NOT MEAN YOU SHOULD
    EXPECT THESE MODES SOON (UNLESS SOMEONE WANTS
    TO GIFT ME APPROPRIATE RADIOS FOR CHRISTMAS.)
    ::wink wink:: ::nudge nudge::

CHANGES: V2.33
Another big performance boost.  In YSF mode, if
"dxcc.pl" is called upon to resolve a callsign's
country of issuance based on it's prefix, the
results of that query are now cached.  Upon
subsequent lookup of the same callsign, the
data is retrieved from cache.  As the original
query can take between 3 and 5 seconds, and
retrieval from the cache occurs in a fraction of
a second, resolving the QTH Country of the call-
sign is MUCH quicker.

Examples of the benefit include a prolonged back-
and-forth between two YSF callsigns.  Seeing the
same callsign repeatedly, and performing a lookup
via dxcc.pl with each appearance, is wasteful and
slow.  The second and subsequent appearances will
no longer have to incur that overhead.

Note: The cache is only cleared upon hotspot reboot.
If you stop the script and log out, then log back
in later (with no reboot having occurred between
logging out and back in), the cache from the
previous session will still be available.  A
reboot, however, deletes the previous cache, and
the script will build a new cache with next run.

 1. In YSF traffic, show the time required for
    dxcc.pl to resolve the country that issued
    a callsign, based on it's prefix,, even when
    that resolution fails.  (Such failures occur
    when, for example, a remote operator's setup
    makes them appear as "AMERIC", as in
    "americalink", instead of a proper callsign,
    in the MMDVM log.)
 2. Cache the results of a dxcc.pl lookup.  The
    first time dxcc.pl is called to resolve a
    callsign's country, the response is cached.
    Subsequent lookups will be found in the
    cache, saving 3-5 seconds each time dxcc.pl
    would otherwise have been called to resolve
    that callsign.  If the user exits the script,
    the cache file will remain in place, should
    the user again launch the script.  A reboot,
    however, clears the cache.
 3. Eliminated a couple calls to "awk".
 4. Other minor tweaks.

CHANGES: V2.32
 1. More changes to the -i|--info area.  It now
    shows which of the following modes are enabled
    in pi-star: YSF, DMR, YSF2DMR, DMR2YSF
 2. When logging is interrupted, the program now
    tells you if it was due to daily log rotation
    that occurs at 00:00 UTC, or if it was due
    to a service restart (nightly pi-star update,
    user-initiated config changes, or other stop/
    start of the services that might occur.  This
    is reflected both at the bottom of the screen
    when the interruption occurs, and in the marker
    shown in the history.
 3. Removed a couple more unnecessary greps.
 4. Moved all occurances of closure of FDs 3 and 4
    (debug and profile log file descriptors) to
    their own function.
 5. For YSF traffic, when dxcc.pl is needed to
    resolve a callsign's prefix to the country that
    issued the callsign, the time required for
    dxcc.pl to resolve is now also displayed.

CHANGES: V2.31
This round of updates focused on performance
improvements.  Dozens of calls to external tools
have been replaced with bash builtin features,
eliminating a great deal of overhead.  The
Raspberry Pi Zero, which I wager makes up the
bulk of PI-STAR based hotspots, will see the
greatest benefit.

 1. Replaced over 60 calls to cut, sed, and grep,
    with bash built-in variable expansions.
    Each call to these external commands was a
    subprocess that required a lot of overhead,
    and slowed processing.  Parsing log entries
    is now signigicantly faster.  This helps a
    Raspberry Pi Zero to keep up/catch up, to an
    active log.

 2. Cleanup/re-org to the handling of counters
    (QSOs, Errors & Warnings, Log Restarts).
    Added two new counters (DMR and YSF traffic
    types) to the -i|--info display, and goodbye
    box.

 3. The PID of the script itself, and the PID of
    the background task that monitors log activity,
    are added to the -i|--info data....  Help
    screen and README updated accordingly.

 4. Fixed a bug, displaying horizontal lines when
    hyphens (-) are used instead of UTF-8's
    horizontal line-drawing character (─).
    ("printf" was interpreting the hyphen to mean
    that a printf option was to follow.)

 5. Removed the "(0)" Timeslot indicators, and
    the "5 Max" limit, on static TGs listed in
    the non-scrolling region at top of screen
    (when "-t|--top" is used).  The script now
    shows as many TGs as it can, until it runs
    flush with the width of the rest of the non-
    scrolling region.  Currently, this allows for
    about 61 chars worth of digits and spaces,
    in the line beginning with "STATIC TGs(nn):".
    (This change will require updates to some of
    the screenshots, and the animation that
    appear on the github page - I'll get to those
    eventually.)

CHANGES: V2.30
 1. Added "Elapsed Time" to the goodbye screen
    showing days, hours, minutes, and seconds
    that the script ran since last launched.
    Given the increased stability of the script,
    without screen redraw snafus/corruption, it
    is now possible to leave the script running
    for days at a time.

 2. Added count of log restarts observed during
    session, to goodbye screen.  If the script
    is left running for several days, one can
    expect at least two log pauses each day;
    One when the log rolls to a new date at
    UTC midnight, and another when the nightly
    update bounces the pi-star services.

 3. Raised error and warning counters to %05d

 4. Improved the test for UTF-8 char support.

 5. A new "-i|--info" cmdline option has been
    added.  THREE THINGS MUST BE TRUE for this
    to be of any use to anyone...

    A.) You MUST specify the "-i|--info" option.
    B.) Your display MUST be at least 120 chars
        wide.
    C.) You MUST also activate the non-scrolling
        information region at the top of the
        screen using the "-t|--top" option (the
        number of lines of history, if any, is
        irrelevant.)

    If either B or C above is false, then A is
    useless.  If all three conditions are met,
    a small block of information, largely only
    helpful to those looking to modify the
    script, is shown in the top-right corner of
    the screen.  An example looks like this:

    Options & Parameters: -t 10 -f 4 -i -l
    Elapsed: 0 Days 07 Hrs 19 Mins 55 Secs
                 Debugging (3>): /dev/null
                 Profiling (4>): /dev/null
                     Screen Size: 49 x 160
                           Log Restarts: 1

    The first line shows the options and
    parameters that were passed to the script
    when launched.

    The second line (and frankly the only line
    potentially of any value to a user not
    looking to modify the script in any way),
    shows a rough elapsed time since the script
    was launched.

    The third and fourth lines give any
    target logfiles specified for the debugging
    and profiling log features described
    in the ABOUT_DEBUGGING and ABOUT_PROFILING
    files.

    The fifth line shows the size of the
    screen/window in rows and columns (useful
    to those who want to modify the script, as
    there is so much cursor management stuff
    going on).

    The sixth line simply shows how many times
    log activity has paused/resumed since launch.
    Expect typically two events per day... log
    rotation to a new day's logfile at midnight
    UTC, and when pi-star bounces it's services
    when performing it's nightly updates.

 6. Added URL of my QRZ page, to comments at
    top of script.

CHANGES: V2.29
 1. Removed a remnant of code meant to pass
    FD redirections to the old exec'd restarts.
 2. Removed several redundant re-paints of the
    information zone at the top of the screen
    when -t|--top is used.
 3. Added a simple check to prevent launching
    as root (just use the normal "pi-star"
    login id.  Execution as root is not needed.)
 4. Use read to place commandline options and
    arguments into the array.
 5. Minor cleanups suggested by shellcheck.

 Minor updates to README.md to reflect the
 changes at log rotation and pi-star nightly
 updates, addition of new "-D|-DXCC" option,
 and example screenshot of "-f|--font 5" for
 terminals/emulators that support it.

CHANGES: V2.28
 1. Added -D|--DXCC cmdline option to disable
    use of dxcc.pl to determine a callsign's
    country, when attempting to resolve QTH
    for YSF contacts.  See the -h|--help text
    for details.  (Note: I spotted this while
    reviewing output of the profiling feature
    added in v2.22)

CHANGES: V2.27
 1. Corrected logfile name shown at bottom of
    the screen when log activity resumes after
    log rotation or pistar's daily update.  Just
    a couple related minor cosmetic changes.
 2. Removed the exec from the check that ensures
    pi-star's MMDVMHost demon is up and running.
 3. Monitoring resumes almost instantly following
    log rotation.  When pistar updates itself
    each night, slow Pi Zeros can take up to a
    minute to resume logging (hence the original
    60 second sleep), but faster Pi models could
    complete sooner, thus monitoring resumes
    sooner.

CHANGES: V2.26
 1. Numerous small changes to cleanup fallout
    from the restructuring of restarts sans exec.
    Testing was far more structured and complete
    (and far less rushed) with this version.
    It's amazing, what a day-off allows.

 2. Removed all the superfluous calls to python
    that were used when trying to figure out why
    the screen geometry stuff was breaking.  Only
    the two calls that are actually needed remain.

    Appologies for the recent flurry of changes
    (and all the bugs they created.)  The script
    is finally performing (and behaving) as I had
    originally envisioned.  Humble Pie is what I'll
    be eating tonight.

CHANGES: V2.25
 1. With V2.24 I thought I was eating chicken.  It
    turns out I was eating crow.  Just hours after
    I thought I'd crushed corruption of the --top
    section of the screen, a script re-launch showed
    I wasn't even close.  It turned out that the
    "exec" that re-launched the script was parting
    the script from it's terminal enough that once
    restarted, the script could not determine screen
    rows and columns.  The exec has been done away
    with, replaced with a simple loop that runs the
    main logic.  All is now right with the world.
    (Well, at least the script is better.)

CHANGES: V2.24
 1. Ever since the script was first set up to track
    a dynamically resizeable SSH window, getting and
    tracking screen dimensions (rows and colums) has
    been a real ass-kicker.  But, I think I have
    finally conquered the gremlins.  Screen redraws
    now appear correct, with less corruption of the
    non-scrolling "top" section (-t|--top) and/or
    history.  Reminds me of my days admining corporate
    sendmail servers.  Yes, there are legitimate,
    technical reasons why it requires sacrificing a
    live chicken!  (Chickens, beware - I'm hungry.)
 2. Clean up errors from new ANSI ESCape codes.

CHANGES: V2.23
 1. Fixed dev version indicator.
 2. Removed unused fnCENTER function.
 3. Padded more fields in no-scroll zone to clear some 
    artifacts left when the zone gets corrupted.
 4. Set umask symbollically (for some reason, octal
    wasn't inherited by debugging and profiling logs).
 5. Minor cosmetic and other tweaks.
 6. Corrected (I hope) intermittent scrolling within
    the -t|--top non-scrolling region.
 7. If not forced with -f|--font at launch, the figlet
    font now dynamically adjusts to the screen size,
    for GUI-based SSH clients like PuTTY, that can be
    re-sized on the fly.  To prevent dynamic font
    changes, specify a font with -f|--font.
 8. Consolidated a pair of figlet-related functions,
    renamed to fnBANNER.
 9. A new font: "-f 5"... This is NOT a figlet font!
    If your SSH client and TERM type support both the
    "${ESC}#3" and "${ESC}#4" ANSI control codes, you
    can try specifying font #5 ("-f 5" or "--font 5"),
    when launching pistar-lastqso.  THE PI HDMI CONSOLE
    DOES NOT SUPPORT THIS ALTERNATE CHARACTER SET.  It
    works mainly with SSH clients that do GOOD "xterm"
    emulation.  Other term-types and emulators *may*
    work, but YMMV.  If you try it, and instead of
    seeing one line printed "double-high & double-wide"
    you see two lines printed normally, then this font
    is not for you.  (And it's nothing this script can
    fix... it's a limitation of your terminal emulator
    and TERM type.)

CHANGES: V2.22
 1. More frequent -t|--top no-scroll region redraws.
 2. Minor cleanup when passing debug option at restart.
 3. Added a mechanism for a performance profiling log,
    via redirection of file descriptor 4.

CHANGES: V2.21
 1. More cleanup of tmpfile (stale files were still
    present after script self-restart.)
 2. Ensure debug option (if used at initial launch)
    is passed when the script re-launches itself.

CHANGES: V2.20
 1. Updated copyright.
 2. Added visual cue for dev or production version.
 3. Added mechanism for creating a debugging log, via
    redirection of file descriptor 3.
 4. Fixed cleanup of files in the /tmp dir.
 5. Rename fnEXIT() to fnABORT().

CHANGES: V2.19
 1. When "-t|--top" is specified, show script's version
    number in RED, when an update is available on github.
    Otherwise, the version number is shown in white.
 2. A few cleanups suggested by shellcheck 0.8.0

CHANGES: V2.18
 1. Output of the BM static TG query has changed.  Fixed
    parsing to show slot # with each static TG shown in
    the -t|--top section of the screen.

CHANGES: V2.17
 1. Added a check to see if an updated version of the
    program has been posted to github.

CHANGES: V2.16
 1. Replaced a ps|grep pipeline w/ pgrep -f.
 2. Set PATH to place most often-used directories first.
 3. Small updates to fnPARSE_CMDLINE and fnUSAGE, to
    clarify valid syntax, and give appropriate error
    messages, if invalid options or parameters are used.
 4. Other minor changes.

CHANGES: V2.15
 1. Increased sleep time from 45 to 60 seconds, during
    auto-restart at log rotation or nightly update.
 2. Added checks at the start of the script to ensure
    that A.) MMDVMHost is running, and B.) that it is
    writing to the log.  If it's not running, exit.
    If it is running, but not (yet?) writing to the log,
    sleep 10 seconds and check again.
 3. Strip any "/" or "-" suffix from YSF callsigns
    before attempting to resolve names from the user.csv
    or NXDN.csv files.
 4. Added a missing incrementation of the array index
    in fnPARSE_CMDLINE, and cleaned up the default case.

CHANGES: V2.14
 1. Fixed broken parenthesis when fetching CPU temp.
 2. Made a pass with beautysh.
 3. Fixed cmdline parsing to accept an equals sign (=)
    or a space, between an option and it's parameter.
    The following are all now valid examples of the forms
    an option and it's parameter can take.
      $ pistar-lastqso -f 1 -t 24
      $ pistar-lastqso -f=1 -t=24
      $ pistar-lastqso --font 1 --top 24
      $ pistar-lastqso --font=1 --top=24
 4. Added a timestamp to the "Auto-Restart" line in the
    history, to indicate what time the restart occurred,

CHANGES: V2.13
 1. Preserve and carry forward any history, during auto-
    restarts, at log rotation or service bounce.
 2. Colorize CPU Temp in the "-t|--top" section of screen.
    < 50°C is green, >= 50°C is yellow, >= 69°C is red.
 3. Fixed a missing check for /usr/local/etc/MY_LIST.txt
    before attempting to search it.
 4. If the traffic is YSF, and only the country is resolved
    (based on the callsign's prefix), then don't bother
    showing "n/a" for either the city or state fields.
 5. A few cleanups suggested by shellcheck.
 6. Removed redundant parsing of date/timestamps.
 7. Other small cleanups.

CHANGES: V2.12
 1. There is no source for YSF callsign "first name" data.
    However, as a YSF user may also have a registered DMR
    or NXDN id, check the user.csv and NXDN.csv files to
    see if we can find the callsign's first name.  If so,
    display it in the QSO details for a YSF QSO, in the
    same manner as with DMR QSOs.
 2. Added handling of YSF "received late" entries.
 3. Add handling of YSF RF dropped transmissions.
 4. Added a new "-w|--wrap" cmdline option.  Ordinarily,
    figlet will wrap the text that it displays, based on
    the size of the font selected, and the width of the
    screen (in columns).  However, setting this option
    tells figlet to ignore the screen width, and just
    keep printing on the same line, even if that means
    the text will disappear off the right edge of the
    screen.  You sacrifice whatever information was off
    the edge of the screen, but without wasting so much
    vertical screen space to line-wrap.  This can be
    helpful with smaller 80x24 displays, for example.
 5. Updated help and usage screens.
 6. Do a better job skipping dxcc lookups for senders
    sending things like "openSPOT2" as a YSF "callsign".
 7. Added an additional line at top of the screen when
    "-t|--top" is used, showing CPU temp, modem port,
    and platform type.

CHANGES: V2.11
 1. Removed redundent BER "%" symbol on YSF RF traffic.
 2. To improve QTH info for YSF callsigns, first check
    the DMR user.csv file and/or pi-star's NXDN.csv
    file.  (Users of YSF may also have DMR or NXDN
    radios, and would be listed there.)  Only if not
    found in those files, would we launch the dxcc.pl
    perl script, which determines only country, based
    on the callsign's prefix.  Along with the QTH data,
    the source of that data is also displayed, be it
    the user.csv or NXDN.csv files, or the cty.dat
    used by dxcc.pl.

CHANGES: V2.10
 1. Commandline parsing has been reworked and improved.
 2. Using "-f|--font" without also passing a number 1-4 was
    not generating an error during commandline parsing.  This
    has been fixed.  If "-f|--font" is used, a valid font
    number MUST be specified.
 3. Replaced PI-STAR version with cty.dat file date info, at
    the top of screen, when "-t|--top" is used.

CHANGES: V2.09
 1. The changes to v2.08 inadvertently removed the display of
    statically linked Brandmeister DMR TalkGroups, in the
    information shown when "-t|--top" is used, for DMR.  This
    been corrected.

CHANGES: V2.08
 1. The depth of the history displayed as part of the "-t|--top"
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
