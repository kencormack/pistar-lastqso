# pistar-lastqso
## A Tool to Monitor DMR, YSF, DMR2YSF and YSF2DMR Traffic, on Pi-STAR

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/title-screen.jpg)

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/animation.gif)

-------------------------------------------------------------------
## PRELIMINARY SUPPORT HAS NOW BEEN ADDED, FOR NXDN, D-STAR, AND P25!
## As I do not personally own radios capable of these modes, support
## for NXDN, D-STAR, and P25 is currently limited to parsing NETWORK
## log entries ONLY.  However, what's now in place for these modes is
## a decent start.  (You wont see your own radio RF signals, but you
## WILL see traffic coming to you from the network.)
## Updates to the text and screenshots below, to show all the changes,
## will come later.  But what's shown below applies to the new modes.
-------------------------------------------------------------------
## See the CHANGE_LOG above, for details of what's changed, in each version. 
-------------------------------------------------------------------
## Contents
- **[About](https://github.com/kencormack/pistar-lastqso#about)**
- **[Installation](https://github.com/kencormack/pistar-lastqso#installation)**
- **[Updating](https://github.com/kencormack/pistar-lastqso#updating)**
- **[Large Font Display of the Callsign and Talkgroup or DG-ID](https://github.com/kencormack/pistar-lastqso#large-font-display-of-the-callsign-and-talkgroup-or-dg-id)**
- **[City, State, Country Lookups for Callsigns (DMR only)](https://github.com/kencormack/pistar-lastqso#city-state-country-lookups-for-callsigns-dmr-only)**
- **[City, State, Country Lookups for Callsigns (Other Modes)](https://github.com/kencormack/pistar-lastqso#city-state-country-lookups-for-callsigns-other-modes)**
- **[Commandline Options](https://github.com/kencormack/pistar-lastqso#commandline-options)**
- **[The Help Text](https://github.com/kencormack/pistar-lastqso#the-help-text)**
- **[Daily Log Rotation](https://github.com/kencormack/pistar-lastqso#daily-log-rotation)**
- **[User-Custom Talkgroup List (DMR only)](https://github.com/kencormack/pistar-lastqso#user-custom-talkgroup-list-dmr-only)**
- **[QSO, Kerchunk, and MMDVM Error Counts](https://github.com/kencormack/pistar-lastqso#qso-kerchunk-and-mmdvm-error-and-warning-counts)**
- **[More About the Large Font Support](https://github.com/kencormack/pistar-lastqso#more-about-the-large-font-support)**
- **[One More Thing About Large Fonts](https://github.com/kencormack/pistar-lastqso#one-more-thing-about-large-fonts)**
- **[Replaying a Log](https://github.com/kencormack/pistar-lastqso#replaying-a-log)**
- **[Sample Screenshots](https://github.com/kencormack/pistar-lastqso#sample-screenshots)**
- **[Other Notes](https://github.com/kencormack/pistar-lastqso#other-notes)**
- **[Getting Help](https://github.com/kencormack/pistar-lastqso#getting-help)**
- **[Acknowledgements](https://github.com/kencormack/pistar-lastqso#acknowledgements)**
- **[Special Thanks](https://github.com/kencormack/pistar-lastqso#special-thanks)**

-------------------------------------------------------------------
## About
**pistar-lastqso is a tool to monitor DMR and YSF traffic (including DMR2YSF and YSF2DMR cross-modes) on a PI-STAR node, either via SSH, or, on an HDMI-connected console.  Written as a bash shell script (with a few lines of python), no web browser or other GUI client is required.**

## Preliminary Support for NXDN, D-Star, and P25
**As of version 3.0, pistar-lastqso now contains limited support for NXDN, D-Star, and P25.  As I do not own radios of these types, I have no way to replicate for parsing, the log entrie needed for RF-based traffic (from the radio to the hotspot).  I have, however, been able to create the log entries for network-based traffic (from the network to the hotspot).

**For each QSO (all modes), the program displays the following data:**
- The localized Time and Date of the contact
- The running count of QSOs observed since launch
- The Sender (From)
- The Recipient (To)
- The Duration of the contact (in seconds)
- The BER, and Loss (Net), or Signal Strength (RF)

**In Addition:**
- Any MMDVM errors or warnings appearing in the log while the tool is monitoring

**For each DMR (Only) QSO, the program displays the following data beyond what the PI-STAR dashboard can show:**
- The contact's Name (from PI-STAR's **DMRIds.dat** file)
- The contact's QTH (from the downloaded **user.csv** file)
- The contact's Talker Alias (Note #1, below)
- The talkgroup's Name (Note #2, below)
- The contact's DMR ID# (Note #3, below)

**For the other modes, the program displays the following data beyond what the PI-STAR dashboard can show:**
- The contact's QTH (Determined with best effort, from several sources.)
- Possibly, the contact's First Name (keep reading.)

As several of the modes do does not require that users be registered, there is no single source for Name or QTH data for most users.  The script therefore assumes that the Callsign owner may also have either a registered DMR ID or NXDN ID number.  On the chance that they do, **pistar-lastqso** first attempts to find the Callsign's name and QTH info in the DMR **user.csv** file, then PI-STAR's **NXDN.csv** file.  If the Callsign is not found in either of those files, as a last resort, it then calls upon the perl script **dxcc.pl** and it's **cty.dat** file.  As the first two data sources generally contain the Callsign's Name, City, State, and Country info, they are tried first.  The **dxcc.pl** script, and it's **cty.dat** file, can only determine the Country that issued the Callsign, based on the Callsign's prefix.  The Callsign's Name will remain unresolved.  (Lookups with **dxcc.pl** can be disabled if needed, with the "-D|--DXCC" options - see **[the Help text](https://github.com/kencormack/pistar-lastqso#the-help-text)** for details.)

**Note #1:**
*Talker Alias data is shown, only if present and complete.  Kerchunkers don't stick around long enough for TA data to be gathered.  Partial TA data (or that which is received as empty/null) is not shown.*

**Note #2:**
*See the "User-Custom Talkgroup List" section below, for more info.*

**Note #3:**
*The MMDVMHost daemon internally knows the actual DMR ID# of the user, and does ID number to Callsign lookups from **DMRIds.dat**.  However, in the logfile, you end up with the Callsign, and lose the ID number.  Disabling this lookup gains you the ID numbers in the logfile, but loses the Callsigns.  If I were to disable the lookups for the MMDVMHost process, I could quite easily perform an ID to Callsign lookup within the program, but the PI-STAR web interface would suffer the loss of the Callsign.  Pi-star web-based Dashboard users wouldn't appreciate that at all.  So, I work backwords, taking the Callsign that MMDVMHost writes to the logs, and looking up the ID in the **DMRIds.dat** file.*

*But there's a small problem with that approach...*

*In the early days of DMR, some users were registering for multiple IDs (one for each radio, one for each hotspot, etc.)  The prefered method of identifying hotspots today is by adding a two-digit suffix to the user's normal 7-digit ID, for example.  However, those earlier cases of multiple ID numbers mapped to the same Callsign still exist in the file.  Each DMR ID links to only one Callsign, but not every Callsign links to just one ID.  (I saw one Callsign that has EIGHT consecutive DMR ID numbers associated with it.)  With no guarantee that I'm picking the correct ID linked to a given Callsign, I just arbitrarily pick the first number, on the assumption that that's the one that represents the user, not one of their hotspots, etc.  I wish MMDVMHost would log both Callsign and ID#.  But it's one or the other, not both.  For the vast (VAST!) majority of cases, my "lesser of two evils" approach will serve well enough.*

*If the Callsign maps to multiple ID#'s, I indicate that the ID shown is just a "guess", by displaying an asterisk, immediately after the ID#.*

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Installation

**pistar-lastqso** comes with an "install" script.  To install **pistar-lastqso**, log in to your PI-STAR hotspot with SSH, and perform the following steps:
```
Put the PI-STAR filesystem in read-write mode...
  $ rpi-rw

Pull down the pistar-lastqso files...
  $ git clone https://github.com/kencormack/pistar-lastqso.git

Change to the "pistar-lastqso" directory that was just created...
  $ cd pistar-lastqso

Run the install script...
  $ ./install
  (The install script will return the filesystem to read-only mode)

You are now ready to monitor DMR and/or YSF traffic from the commandline.
  $ pistar-lastqso
```

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Updating

Each time the script is run, it checks to see if an updated version has been posted online.  If an update is available, the user is notified.

To update, log in with SSH, 'cd' into the directory into which you originally cloned **pistar-lastqso**, and run the following commands:
```
$ rpi-rw
$ git pull
$ ./install
  (The install script will return the filesystem to read-only mode)
```
That should do it.

**If, for any reason, git detects that your local copy has changed, and gives the following message...**
```
error: Your local changes to the following files would be overwritten by merge:
        <filename>
Please commit your changes or stash them before you merge.
```
**... copy your local changed file to an alternate location, and run the following command to reset git's pointers:**
```
$ git reset --hard origin
```
**... and then re-try the "git pull".  This will overwrite your local changes with the update from github.**

Once the "git pull" is successful, run the install script, as described above.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Large Font Display of the Callsign and Talkgroup or DG-ID
One of the functions of the "install" script (see the "Installation" section, above) is to install the package "figlet" on your system.  With figlet, **pistar-lastqso** can display the Callsign and TG or DG-IG as a large banner, at the beginning of each QSO.

If figlet is disabled (see the "Commandline options" section, below), the large character display is omitted, but all other information is still displayed normally.

**SEE ADDITIONAL INFORMATION BELOW REGARDING LARGE-FONT SUPPORT**

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## City, State, Country Lookups for Callsigns (DMR only)

Upon first run, **pistar-lastqso** will download the latest version of the **user.csv** file from https://database.radioid.net/static/user.csv

If the **user.csv** file is already present on your hotspot, but is older than 7 days, **pistar-lastqso** will update the file to it's latest version automatically.  You can also force an update to the latest version at any time, using the "-c|--csv" commandline option.

**pistar-lastqso** uses the **user.csv** file to display the "City", "State", and "Country" data related to the Callsign.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## City, State, Country Lookups for Callsigns (Other Modes)

As mentioned above, pistar-lastqso will attempt to find QTH info in the DMR **user.csv** file, then PI-STAR's **NXDN.csv** file.  If the Callsign is not found in either of those files, it then calls upon the perl script **dxcc.pl** and it's **cty.dat** file.  As the first two data sources generally contain City, State, and Country info, they are tried first.

The **dxcc.pl** script, and it's **cty.dat** file, can only determine the Country that issued the Callsign, based on the Callsign's prefix.  (Lookups with **dxcc.pl** can be disabled if needed, with the "-D|--DXCC" options - see **[the Help text](https://github.com/kencormack/pistar-lastqso#the-help-text)** for details.)

Upon first run, **pistar-lastqso** will download the latest version of the **cty.dat** file from https://www.country-files.com/category/big-cty/

If the **cty.dat** file is already present on your hotspot, but is older than 30 days, **pistar-lastqso** will update the file to it's latest version automatically.  You can also force an update to the latest version at any time, using the "-d|--dat" commandline option.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Commandline Options

**pistar-lastqso** supports a number of commandline options, as shown below, and in **[the Help text](https://github.com/kencormack/pistar-lastqso#the-help-text)**.  Multiple options can be specified at the same time.  For example, specifying "-c -n -t" (or "--csv --nobig --top") will download the latest updated **user.csv** file, disable the large font
display of the Callsigns, and activate the non-scrolling information section at the top of the screen.

**Valid Options and Parameters...**
```
Short Form:
  [-12] [-c] [-d] [-D] [-e] [-f <1-5>] [-h] [-i]
  [-l] [-m] [-n] [-r /full/path/to/file] [-t [integer]] [-v] [-w]

Long Form:
  [--12hr] [--csv] [--dat] [--DXCC] [--errors] [--font <1-5>] [--help] [--info]
  [--logo] [--mono] [--nobig] [--replay /full/path/to/file] [--top [integer]]
  [--version] [--wrap]
```

Also, options that take a parameter (-f|--font, -t|--top, and -r|--replay) will accept either a space, or an equal sign (=) between the option, and it's parameter.  For example, all of the following are valid forms:
```
  $ pistar-lastqso -t 10 -f 1 -r /tmp/logfile
  $ pistar-lastqso -t=10 -f=1 -r=/tmp/logfile
  $ pistar-lastqso --top 10 --font 1 --replay /tmp/logfile
  $ pistar-lastqso --top=10 --font=1 --replay=/tmp/logfile
```

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## The Help Text

```
PISTAR-LASTQSO - HELP

(Cursor Up/Down keys to scroll, Page Up/Dn to page, Q to quit help.)

  With no options, the script watches for DMR and YSF traffic.
  Log entries are parsed and presented as each log line is read.
  Use Ctrl-C to exit.

  -12|--12hr
      By default, timestamps are shown in 24 hour military format.
      For example, 5:00 PM is displayed as "17:00:00".  However, by
      using this option, timestamps will be displayed in 12 hour
      format, with am/pm indicated, as appropriate (ex: 05:00:00 pm).

  -c|--csv
      Download an updated user.csv from radioid.net now, rather than
      waiting for the presently installed copy to age 7 days before it
      updates automatically.

  -d|--dat
      Download an updated cty.dat from country-files.com now, rather
      than waiting for the presently installed copy to age 30 days
      before it updates automatically.

  -D|--DXCC
      When resolving QTH location for callsigns, pistar-lastqso first
      gambles that the callsign might also be either a DMR or NXDN
      user.  In which case, a quick check of the DMR user.csv and/or
      NXDN NXDN.csv files will find their QTH data there.

      If the callsign can't be found in those files, pistar-lastqso
      calls upon dxcc.pl to determine the country that issued the call
      sign.  This can potentially impact pistar-lastqso's ability to
      "keep up" with log entries, as each call to dxcc.pl can take up
      to 4 or 5 seconds to resolve.  When YSF traffic lasts more than
      a few seconds, this is no problem, as the script normally just
      sits there saying "QSO In Progress...".  But when the bulk of
      traffic is "[[kerchunks]]", which pistar-lastqso considers any
      traffic lasting less than 2 seconds, the kerchunks can out-pace
      the ability of dxcc.pl to keep up.  A few kerchunks here and
      there are generally not a problem.  But a large series of them
      in quick succession can cause delays.  Effectively, you will be
      listening to one callsign, but still seeing data on the screen
      for QSOs logged many seconds ago.

      This "-D|--DXCC" cmdline option can be used to disable calls
      to the dxcc.pl script, if such delays become an issue for you.

      This option has no affect on DMR traffic.  DMR and NXDN users
      go through a registration process that results in their QTH data
      being readily available in the user.csv and NXDN.csv files, thus
      calls to the dxcc.pl script are never needed for DMR traffic.

  -e|--errors
      By default, pistar-lastqso will display any error messages found
      in the MMDVM log, as they occur.  It is NOT unusual to see an
      occasional, or sporadic message, such as a queue overflow.  But
      if these or other errors are frequent or persist, you may need
      to get help from the pi-star forums.  In the meantime, you can use
      the "-e" or "--error" option to suppress the onscreen reporting
      of these errors.  The errors will however still be counted for
      the current session, and the count will still be reported on the
      exit screen.  It is your responsibility to investigate any cause.

      Use of this option DOES NOT FIX THE ERRORS coming from pi-star.
      It only stops telling you that they are happening.

      NOTE: The script also displays and tallies any WARNINGS that may
      show up in the log.  Although the -e|--error option will supress
      display of ERRORS, it will NOT supress display of WARNINGS.

  -f|--font <1-5>
      The [-f|--font] option forces use of the selected font, regardless
      of screen-width.

      Valid options are 1, 2, 3, 4, or 5
        1 = "small"
        2 = "standard"
        3 = "big"
        4 = "ansi_shadow"
        5 = "emulator-dependent alternate charset"

      If this option is omitted, the script will auto-select an
      appropriately sized figlet font based on the following screen-
      width thresholds:

        < 80 chars wide:  "small" font
      80-120 chars wide:  "standard" font
        >120 chars wide:  "big" font

      The "ansi_shadow" and "emulator-dependent alternate character set"
      fonts are never auto-selected.

      Font # 5 may not work for everyone.  Not all terminal emulators
      or TERM-types support the ANSI control codes for this feature.

  -h|--help
      Display this help screen, then exit.

  -i|--info
      Shows a little info in the top-right corner of the screen, when
      the following THREE CONDITIONS apply...

      A.) You MUST specify the "-i|--info" option.
      B.) Your display MUST be at least 130 chars wide.
      C.) You MUST also activate the non-scrolling information zone
          at the top of the screen using the "-t|--top" option (the
          number of lines of history, if any, is irrelevant).

      If either B or C above is false, then A is useless.  If all
      three conditions are met, a small block of information, largely
      helpful only to those looking to modify the script, is shown
      in the top-right corner of the screen.  An example looks like
      this:
                       Options & Parameters: -t 15 -f 5 -w -i -l
                   Debugging: 3>/dev/null Profiling: 4>/dev/null
                 xterm SIZE=44x168 TTY=pts0 PID=2110 BG_PID=2414
             Modes and X-Modes: YSF=0 DMR=0 NXDN=0 DSTAR=0 P25=1
             YSF2DMR=0 YSF2NXDN=0 YSF2P25=0 DMR2YSR=0 DMR2NXDN=0
                Traffic Counts: DMR=0 YSF=0 NXDN=0 DSTAR=0 P25=0
        Other Counts: Kerchunks=0 Errors=0 Warnings=0 Restarts=0

      The first line shows the options and parameters passed to the
      script when launched.

      The second line lists any targets specified for the debug or
      profiling logs, as described in the ABOUT_DEBUGGING.md and
      ABOUT_PROFILING.md files.

      The third line shows TERM type, and size of the screen in rows &
      columns (useful to those who want to modify the script, as there
      is so much cursor management stuff going on).  Also shown are the
      TTY of the terminal/session the script is running on, the PID of
      the script, and the PID of the background task that watches for
      log activity (daily log rotations and pi-star nightly updates).

      The fourth line shows which of the following modes are enabled
      in pi-star: YSF, DMR, NXDN, DSTAR or P25.  If enabled, the mode
      will show a "1".  Disabled will show a "0".

      The fifth line shows which of the following cross-modes are
      enabled: YSF2DMR, YSF2NXDN, YSF2P25, DMR2YSR, and DMR2NXDN.
      If enabled, the mode will show a "1".  Disabled will show a "0".

      The sixth line shows a number of counters.  They show the number
      of DMR, YSF, NXDN, DSTAR, and P25 messages seen since the program
      was launched.

      The last line shows the number of Kerchunks, Errors, Warnings,
      and log Restarts observed since program launch.  However, when
      the "-r|--replay" option is used, the last line instead performs
      a different function.  It displays a reminder indicating that the
      program is in "replay mode" (not viewing live traffic)

  -l|--logo
      Disables the animated logo at startup.

  -m|--mono
      For monochrome displays, this option suppresses all color codes.

  -n|--nobig
      Disable the large font display of callsigns and ID #s.  This
      conserves vertical screen-space.

  -r|--replay /full/path/to/file
      FOR DEVELOPMENT USE: This option allows the specified file to
      be "replayed" from the start, as if it were the current log.
      This aids testing of coding changes, against problematic log
      entries, by replaying those log entries.  Troubleshooting
      another user's log too, becomes possible.  A fully qualified
      filename must be specified.

        Examples:
                -r /full/path/to/file
          --replay /full/path/to/file

        Not:
                -r filename
          --replay filename

      This also allows adding support for modes for which the user
      does not have appropriate radios, by soliciting sample logs
      from contributors who do own radios of the appropriate type.

  -t|--top [integer]
      Adds an information zone to the top of the screen that shows
      the version number of this script, date of the cty.dat and
      user.csv files, name of the active log file, TX and RX freqs,
      the hotspot's TCXO frequency and firmware version, CPU temp,
      the Modem's device node (port), the computer platform/model,
      the elapsed time since the script was launched, the system
      load averages for the last 1, 5, and 15 minutes, the DMR and/
      or YSF Master servers, and the first 5 statically defined
      BrandMeister TalkGroups.

      By default, the use of "-t|--top" also provides a history of
      the last 5 QSOs observed.  However, by specifying an integer
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

      As a point of reference, "-t 8 -n" will maximize the size of
      the history, while still allowing full details for the QSO in
      progress (without large fonts), on a typical 80x24 display.
      Larger screens will support other combinations.  Feel free to
      experiment - YMMV.

  -v|--version
      Display this script's version number, then exit.

  -w|--wrap
      Ordinarily, if figlet decides it needs to wrap the text that it
      displays, based on the size of the font selected, and the width
      of the screen (in columns), it will do so.  However, setting
      this option tells figlet to ignore the screen width, and just
      keep printing on the same line, even if that means the text will
      disappear off the right edge of the screen.  You sacrifice what-
      ever information was off the edge of the screen, but without
      wasting so much vertical screen space to line-wrap.

                            END OF HELP

(Cursor Up/Down keys to scroll, Page Up/Dn to page, Q to quit help.)
```

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Daily Log Rotation

When **pistar-lastqso** is launched, it searches for the most recent MMDVM log in the **/var/log/pi-star** directory.  It then watches only that log, to perform it's monitoring.  When the MMDVMHost service opens a new day's log (at midnight UTC), this program detects this, and resumes monitoring, but with the new log.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## User-Custom Talkgroup List (DMR only)

In order to display the name of a Talkgroup, **pistar-lastqso** consults the PI-STAR file **"/usr/local/etc/TGList_BM.txt"**.  This file is updated automatically by PI-STAR, but does NOT include talkgroup names that include UTF8 characters such as umlauts, like those found in German and other languages (ä ö ü ß), etc.  To compensate, this program allows the user to build their own custom file containing any missing talkgroup (or "private" contact ID) names the user wishes to display.

Create the file **"/usr/local/etc/MY_LIST.txt"**.  Records in that file must appear in the same format as PI-STAR's **TGList_BM.txt** file.

Examples should look like the following:
```
2627;0;BADEN-WUERTTEMBERG;TG2627
2629;0;SACHSEN/THUERINGEN;TG2629
26232;0;DREILAENDERECK-MITTE-DEUTSCHLAND;TG26232
26274;0;BW-BOEBLINGEN;TG26274
26283;0;REGION-MUENCHEN;TG26283
26287;0;ALLGAEU-BODENSEE;TG26287
26298;0;THUERINGEN;TG26298
262277;0;KIEL-GRUPPE;TG262277
```

You can also add certain 'private contact' IDs here that may not be listed.  Note the "PC", rather than "TG" references, in the last field of each line.  Users who take advantage of PI-STAR's "remote commands" can include references to those in their **MY_LIST.txt** file, if desired:
```
9990;0;PARROT;PC9990
262993;0;GPS-WX;PC262993
310999;0;APRS;PC310999
9999995;0;PISTAR-HOSTFILES;PC9999995
9999996;0;PISTAR-SHUTDOWN;PC9999996
9999997;0;PISTAR-REBOOT;PC9999997
9999998;0;PISTAR-SVC-RESTART;PC9999998
9999999;0;PISTAR-SVC-KILL;PC9999999
```

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## QSO, Kerchunk, and MMDVM Error and Warning Counts

**pistar-lastqso** counts the number of QSOs it has watched since last launched by the user.  With each QSO the running count is displayed.  Connections lasting less than 2 seconds are considered "kerchunks", which are also counted.  These are noted on the screen as kerchunks, but the running count is not displayed.  When the user quits the program using Ctrl-C, the closing screen shows the number of QSOs the program watched, and how many of these were considered kerchunks.

The program also watches the MMDVM log for any errors, or more severe warnings, reported by the MMDVMhost daemon that is the real "engine" behind PI-STAR.  Any such errors or warnings noted in the MMDVM log are reported by **pistar-lastqso** as they occur, and are tallied.  The total number of errors and warnings counted (if any) since **pistar-lastqso** was launched by the user, are reported on the exit screen, in a red pop-up box.  If no errors or warnings were tallied, the red pop-up box does not appear.

**It is the user's responsibility to judge the severity, and find the fix, for any MMDVM log errors or warnings reported by pistar-lastqso.  These MMDVM log errors and warnings are not caused, controlled, or solveable, by pistar-lastqso.  The script only reports what gets logged by the MMDVMhost daemon.  Pistar-lastqso does not create, diagnose, or eliminate the logged errors or warnings.**

Don't panic if you see a single transient occurrance of something like a "queue overflow" error.  Things like that may show up occasionally, and are harmless.  But if you see dozens (or hundreds!) of them, you will want to look into it.  Other types of errors may require more research on your part.  If you need to investigate any errors, search your **/var/log/pi-star/MMDVM-YYYY-MM-DD.log** for any lines beginning with "E:".  Warnings are more severe.  Those can be found in the log, on lines beginning with "W:".

**[Please visit the PI-STAR forums](https://forum.pistar.uk/)**, if you need help diagnosing any errors found in the MMDVM log.

Finally, all four of the counters (QSO, Kerchunks, Errors, and Warnings) are reset each time the user exits **pistar-lastqso** using Ctrl-C.  However, when the script pauses and resumes monitoring, either at log rotation or when PI-STAR's services get cycled during the nightly PI-STAR update, the running counts for each counter are carried forward when monitoring resumes.

The commandline option "-e|--errors" will supress onscreen notification of errors during QSOs, but will NOT supress the more severe "warnings".  With or without that option, the total numbers of any errors or warnings detected, will be displayed at program exit.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## More About the Large Font Support

By default, **pistar-lastqso** will use one of three basic large fonts to display the contact and TG or DG-ID at the beginning of each QSO.  Which of the fonts is selected is based on the width of the display, in columns.  The program dynamically senses when the screen size has been changed, such as when a user re-sizes an SSH window on-the-fly, and selects an appropriately sized font accordingly.  This auto-selection of font, based on screen width, helps to avoid unnecessary line-wrap, of figlet's output.  The default font selections are as follows:

```
  <= 80 chars... "small" font
 81-120 chars... "standard" font
  > 120 chars... "big" font
```

**pistar-lastqso** supports a "-f|--font <number>" commandline option to override auto-selection, and force a given font regardless of screen-width.  If the -f option is omitted, **pistar-lastqso** will auto-select an appropriately sized font as just described above.  If passed an invalid parameter, the usage screen will be displayed.

The "-f|--font" commandline option requires a numeric parameter to select between the fonts:

```
  "-f 1" or "--font 1" will force figlet's "small" font
  "-f 2" or "--font 2" will force figlet's "standard" font
  "-f 3" or "--font 3" will force figlet's "big" font
```

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## One More Thing About Large Fonts

In addition to the above fonts, which come with the base figlet package, the "install" script adds an additional supplemental "ansi_shadow" font.

The "ansi_shadow" font can be utilized by specifying "-f|--font 4" on the **pistar-lastqso** commandline.

```
  "-f 4" or "--font 4" will force the "ansi_shadow" font.
```

Note that for any given figlet font you specify with the "-f|--font" option, figlet may decide it needs to line-wrap the output.  This can waste a lot of screen space if you force a too-large font on a too-small screen.  If that happens, try a lower-numbered parameter for the "-f|--font" option to select a smaller font, or add the "-w|--wrap" option, to disable figlet's automatic line-wrapping.

Lastly, a 5th font *MAY* be available, depending upon the SSH client emulator, and your $TERM type.  This is *NOT* a figlet font, but is an
alternate character set that *some* term types and emulators support.  It is based on the '\e'#3 and '\e'#4 ANSI Escape sequences.  If it
works for you, you should see a line of text **DOUBLE HIGH & DOUBLE WIDE**.  If it does *NOT* work for you, you will either see *TWO* single-width &
single-height lines that look like any other line of text on the screen, or you will see unpredicatible results.  **Neither the Raspberry Pi HDMI console,
nor the pi-star web GUI's SSH screen supports this 5th font.**

The "emulator-dependent alternate charset" font can be tried by specifying "-f|--font 5" on the **pistar-lastqso** commandline.

```
  "-f 5" or "--font 5" will force the "emulator-dependent alternate charset" font.
```

If you specify an invalid numeric parameter for the "-f|--font" option, **pistar-lastqso** will display a usage screen showing valid options and parameters, and then exit.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Replaying a Log

Introduced with version 2.35, **pistar-lastqso** now has the ability to replay a log from the beginning, when the commandline option "-r|--replay" is specified.  Intended primarily for troubleshooting and development, this feature works best when an imported log is uploaded to the hotspot's **/tmp** directory, as **/tmp** does not require root access, and does not require the pi-star filesystem to first be placed in read-write mode.  Importantly, **/tmp** is ram-based and volatile.  Any file uploaded there will be removed upon reboot.  See **[the Help text](https://github.com/kencormack/pistar-lastqso#the-help-text)** above, for details.

Here is an example demonstrating the replay mode...

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/replay-demo.gif)

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Sample Screenshots
**Sample Screenshot:**

With "-t|--top" option, for the large font display of the Callsign...

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/with-figlet.jpg)

**Sample Screenshot:**

With "-t|--top" option, when the "-n|--nobig" option is also used...

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/without-figlet.jpg)

**Sample Screenshot:**

With "-t 24 -f 1" (or "--top 24 --font 1") showing a 24-line history...

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/long-history.jpg)

**Sample Screenshot:**

These are the 3 basic fonts supplied with the "figlet" package, along with the supplemental "ansi_shadow" font.

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/font-samples.jpg)

*IF* your terminal emulator and $TERM setting support it, this is an example of what the "emulator-dependent alternate charset" should look like, on your screen.

![Image](https://raw.githubusercontent.com/kencormack/pistar-lastqso/master/images/font-5.jpg)

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Other Notes

**pistar-lastqso** is heavily commented, and shouldn't be too difficult to figure out, by those wishing to modify it for
other modes of traffic (D-Star, or whatever.)

Key elements of the tool's operation include:

- determining which log is the latest
- the background process, forked to monitor whether MMDVMHost has the logfile open
- a trigger phrase written to the log by that fork, which signals the main loop to exit
- automatically pause & resume monitoring when the current log has been closed/re-opened, or a new log started

The rest of the program is mainly parsing the log entries, managing the history and counters, and presenting the data on-screen.  The two most-used commands in the script are "tput" and "echo".

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Getting Help

**pistar-lastqso's operation is dependent upon a fully operational PI-STAR configuration.  If your PI-STAR setup has problems, those problems cannot be solved here.  [Please visit the PI-STAR forums](https://forum.pistar.uk/) instead.  pistar-lastqso only reads the PI-STAR MMDVM log... What goes into that log is PI-STAR's doing.**

**Likewise, please don't expect the PI-STAR forums to offer any assistance with pistar-lastqso.  They did not write this script, and cannot be expected to know anything about it.**

Every effort has been made to anticipate and address any questions users may have about **pistar-lastqso**, in this README.  Please read through the above carefully.  That having been said, should you have questions, or encounter a problem that is not addressed above, please use the "**[Issues](https://github.com/kencormack/pistar-lastqso/issues)**" tab at the top of this page, to report it.  There, you and others will be able to see if a problem has already been identified, and whether it's been resolved.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; including any implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the [GNU General Public License](http://www.gnu.org/licenses/) for more details.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Acknowledgements

**figlet** (http://www.figlet.org/) is the work of Frank Sheeran, Ian Chai, and Glenn Chappell.

The **ansi_shadow** font pre-dates figlet.  It appears to have been created using an old DOS ANSI art package called "thedraw", and converted for figlet.  It's original creator is unknown.  It can be found at https://github.com/xero/figlet-fonts and from numerous other font collections on the Internet.

**dxcc** (https://fkurz.net/ham/dxcc.html) is a small command line utility, written in perl, which determines the ARRL DXCC entity of a ham radio Callsign.  It was written by Fabian Kurz, DJ1YFK and uses the **cty.dat** country file by Jim Reisert, AD1C (http://www.country-files.com/).

**pistar-lastqso** itself was developed on a Raspberry Pi Zero WH with eMMC (backed up to USB storage), with generic Chinese MMDVM boards (including Duplex and Simplex models).  Development began with PI-STAR 4.1.4, and has continued through all PI-STAR updates to date.  Testing the output is performed on 1.) a Lenovo Thinkpad laptop running Windows 10 Pro via SSH with PuTTY and Xming (an X-server), with PuTTY running as term-type TERM=xterm, or 2.) direct HDMI connection from the Pi to a 40" flatscreen (TERM=linux).

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
-------------------------------------------------------------------
## Special Thanks

I want to offer a big "Vielen Dank!" to Wolfgang Wendefeuer (DC6LK), for the testing, input, discussion, ideas, and sample TG entries he provided.  Thanks also, to Cal Kutemeier (N9KO) for spotting a time-sensitive bug in the conversion of UTC date-stamps to local dates, and Neil Redditch (M1CFK) for reporting a problem with Talker Alias.

- **[Section Links](https://github.com/kencormack/pistar-lastqso#contents)**
- **[Back to Files](https://github.com/kencormack/pistar-lastqso)**
