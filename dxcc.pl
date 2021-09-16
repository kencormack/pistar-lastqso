#!/usr/bin/perl

# dxcc - determining the DXCC country of a callsign
# 
# Copyright (C) 2007-2019  Fabian Kurz, DJ1YFK
#
# This program is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 2 of the License, or 
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, 
# but WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License 
# along with this program; if not, write to the 
# Free Software Foundation, Inc., 59 Temple Place - Suite 330, 
# Boston, MA 02111-1307, USA. 

use strict;
use POSIX;

my $version = '20191204';
my $gui = 0;
my $earthfile = '';		# world map. location will be found later.
my $splash =  "                    Please enter a callsign!";
my $credits = "dxcc $version (c) Fabian Kurz, DJ1YFK.  http://fkurz.net/ham/dxcc.html

Determines the ARRL DXCC entity of a ham radio callsign, based on the cty.dat
country file by Jim Reisert, AD1C (http://country-files.com/). 

This is free software, and you are welcome to redistribute it
under certain conditions (see COPYING).";

my %fullcalls;          # hash of full calls (=DL1XYZ)
my %prefixes;			# hash of arrays  main prefix -> (all, prefixes,..)
my %dxcc;				# hash of arrays  main prefix -> (CQZ, ITUZ, ...)
my $mainprefix;
my @dxcc;

my ($mylat, $mylon) = (0,0);
my $args='';

my $lidadditions="^QRP\$|^LGT\$";
my $csadditions="(^P\$)|(^M{1,2}\$)|(^AM\$)|(^A\$)";

&read_cty();

if (!$ARGV[0] || ($ARGV[0] =~ /-[^mg]/)) {
print "$credits

Usage:  dxcc <callsign>\n\n";
		
exit;
}
else {
	$args = "@ARGV";
	if ($args =~ /-g/) {
		$gui = 1;
	}
	if ($args =~ /-m (.+?)\b/) {			# Own DXCC for beam headings
		($mylat, $mylon)  = (&dxcc("\U$1"))[4,5];
		$args =~ s/.+\b([A-Z0-9\/]+)/$1/g;
	}
}

unless ($gui) {
	my @dxcc = &dxcc("\U$args");

	my ($bearing, $distance) = &qrbqtf($mylat, $mylon, $dxcc[4], $dxcc[5]);

	print "Callsign: \U$args\n\n";

	print "Main Prefix:    $dxcc[7]\n";
	print "Country Name:   $dxcc[0]\n";
	print "WAZ Zone:       $dxcc[1]\n";
	print "ITU Zone:       $dxcc[2]\n";
	print "Continent:      $dxcc[3]\n";
	print "Latitude:       $dxcc[4]\n";
	print "Longitude:      $dxcc[5]\n";
	print "UTC shift:      $dxcc[6]\n";
	if ($mylat || $mylon) {
	print "Bearing:        $bearing°\n";
	print "Distance:       $distance km\n";
	}
	print "\n";
}

###############################################################################
# GUI
# This part is for the GUI only. 
###############################################################################

else {								# if $gui

	our $hastk = 0;
	foreach (@INC) {
		if (-e $_."/Tk.pm") {
			$hastk = 1;
		}
	}
	
	unless ($hastk) {
		die "Tk.pm not found. Exiting.";
	}

	# This is like 'use Tk', except that use is always done at compile
	# time, which is not wanted in this case (when running w/o gui).
	require Tk; import Tk; 

	$earthfile = &search_earth_file;

	print "Found earth.gif: $earthfile\n";

	my $callsign='';

	my $dxcc_result = $splash;
	my $mw = MainWindow->new(); 
	$mw->geometry("640x480");
	$mw->title("dxcc - a DXCC lookup utility");

	my $dot;
	my $t_frame = $mw->Frame(-relief=>'groove', -bd=>1)
		->pack(-side => 'top', -fill => 'y');
	my $m_frame = $mw->Frame(-bd => 2)
		->pack(-side => 'top', -fill => 'y');
	my $b_frame = $mw->Frame( -bd => 2)
		->pack(-side => 'bottom', -fill => 'both');

	my $canvas = $t_frame->Canvas(-height => 320, -width=> 640  )->pack( );	   
	my $photo = $t_frame->Photo( -file => $earthfile );
	my $earth = $canvas->createImage(320,160, -image=> $photo, -tags => 'item');

	# Home-Marker, if $mylon || $mylat set
	if ($mylon || $mylat) {
		my $homedot = $canvas->createOval((640*(180 - $mylon)/360)-5,(320*(90 -
				$mylat)/180)-5, (640*(180 - $mylon)/360)+5, 
				(320*(90 - $mylat)/180)+5, -fill => 'green');
	}

	$m_frame->Label(-text => "Callsign: ")->pack(-side => 'left');
	my $call_entry = $m_frame->Entry(-textvariable => \$callsign,
		-relief => 'sunken', -validate => 'all', -validatecommand => 
		\&validate) ->pack(-side =>'right');
	
	$call_entry->focus;

	$mw->Label(-textvariable => \$dxcc_result, -justify => 'left',
			-font => "courier 12")->pack(-side => 'left');


	my $exit_b = $b_frame->Button(-text => "Exit", -command => sub { exit })
		->pack(-side=>'right', -expand => 1);
	my $clear_b= $b_frame->Button(-text => "Clear", -command => 
		sub { $call_entry->delete(0, 'end'); $callsign = ''; })
		->pack(-side => 'left', -expand => 1);

	my $credits_b = $b_frame->Button(-text => "Credits", -command => \&credits)
	->pack(-side => 'left', -expand => 1);

	MainLoop(); 

sub validate {
	if ($_[1] =~ /[0-9A-Za-z\/]/) {
		@dxcc = &dxcc("\U$_[0]");
		my ($bearing, $distance) = &qrbqtf($mylat, $mylon, $dxcc[4], $dxcc[5]);
		unless ($dxcc[2]) {
			$dxcc_result = $splash;
		}
		else {
			$dxcc[0] .= " ($dxcc[7])";
			$dxcc_result = sprintf(
			"Country Name:   %-20s".
			"WAZ Zone:       %s\n".
			"ITU Zone:       %-20s".
			"Continent:      %s\n".
			"Latitude:       %-20s".
			"Longitude:      %s\n".
			"UTC shift:      %-20s\n", @dxcc[0..6]
			);
			if ($mylat || $mylon) {		# One may be zero :-)
				$dxcc_result .= sprintf(
					"Distance (km):  %-20s".
					"Bearing (°):    %s\n", 
					$distance, $bearing
				)
			}
		}

		my $lon = 640*(180 - $dxcc[5])/360;
		my $lat = 320*(90 - $dxcc[4])/180;

		$canvas->delete($dot) if (defined($dot));
		
		$dot = $canvas->createOval($lon-5,$lat-5, $lon+5, $lat+5, -fill =>
				'red') if ($dxcc[2]); 

		return 1;
	}
	else {
		return 0;
	}
}

sub credits {
	my $creditwindow = MainWindow->new(); 
	$creditwindow->geometry("500x170");
	$creditwindow->title("dxcc - Credits");
	$creditwindow->Label(-text => 
	"$credits\n\nMap: http://earthobservatory.nasa.gov/Newsroom/BlueMarble/",
		-justify => 'left')->pack();
	my $exit_b = $creditwindow->Button(-text => "Exit", -command => 
		sub { $creditwindow->destroy })
		->pack(-side=>'right', -expand => 1);
}

}
# End of GUI

###############################################################################
#
# &wpx derives the Prefix following WPX rules from a call. These can be found
# at: http://www.cq-amateur-radio.com/wpxrules.html
#  e.g. DJ1YFK/TF3  can be counted as both DJ1 or TF3, but this sub does 
# not ask for that, always TF3 (= the attached prefix) is returned. If that is 
# not want the OP wanted, it can still be modified manually.
#
###############################################################################
 
sub wpx {
  my ($prefix,$a,$b,$c);
  
  # First check if the call is in the proper format, A/B/C where A and C
  # are optional (prefix of guest country and P, MM, AM etc) and B is the
  # callsign. Only letters, figures and "/" is accepted, no further check if the
  # callsign "makes sense".
  # 23.Apr.06: Added another "/X" to the regex, for calls like RV0AL/0/P
  # as used by RDA-DXpeditions....
    
if ($_[0] =~ 
	/^((\d|[A-Z])+\/)?((\d|[A-Z]){3,})(\/(\d|[A-Z])+)?(\/(\d|[A-Z])+)?$/) {
   
    # Now $1 holds A (incl /), $3 holds the callsign B and $5 has C
    # We save them to $a, $b and $c respectively to ensure they won't get 
    # lost in further Regex evaluations.
   
    ($a, $b, $c) = ($1, $3, $5);
    if ($a) { chop $a };            # Remove the / at the end 
    if ($c) { $c = substr($c,1,)};  # Remove the / at the beginning
    
    # In some cases when there is no part A but B and C, and C is longer than 2
    # letters, it happens that $a and $b get the values that $b and $c should
    # have. This often happens with liddish callsign-additions like /QRP and
    # /LGT, but also with calls like DJ1YFK/KP5. ~/.yfklog has a line called    
    # "lidadditions", which has QRP and LGT as defaults. This sorts out half of
    # the problem, but not calls like DJ1YFK/KH5. This is tested in a second
    # try: $a looks like a call (.\d[A-Z]) and $b doesn't (.\d), they are
    # swapped. This still does not properly handle calls like DJ1YFK/KH7K where
    # only the OP's experience says that it's DJ1YFK on KH7K.

if (!$c && $a && $b) {                  # $a and $b exist, no $c
        if ($b =~ /$lidadditions/) {    # check if $b is a lid-addition
            $b = $a; $a = undef;        # $a goes to $b, delete lid-add
        }
        elsif (($a =~ /\d[A-Z]+$/) && ($b =~ /\d$/)) {   # check for call in $a
        }
}    

	# *** Added later ***  The check didn't make sure that the callsign
	# contains a letter. there are letter-only callsigns like RAEM, but not
	# figure-only calls. 

	if ($b =~ /^[0-9]+$/) {			# Callsign only consists of numbers. Bad!
			return undef;			# exit, undef
	}

    # Depending on these values we have to determine the prefix.
    # Following cases are possible:
    #
    # 1.    $a and $c undef --> only callsign, subcases
    # 1.1   $b contains a number -> everything from start to number
    # 1.2   $b contains no number -> first two letters plus 0 
    # 2.    $a undef, subcases:
    # 2.1   $c is only a number -> $a with changed number
    # 2.2   $c is /P,/M,/MM,/AM -> 1. 
    # 2.3   $c is something else and will be interpreted as a Prefix
    # 3.    $a is defined, will be taken as PFX, regardless of $c 

    if ((not defined $a) && (not defined $c)) {  # Case 1
            if ($b =~ /\d/) {                    # Case 1.1, contains number
                $b =~ /(.+\d)[A-Z]*/;            # Prefix is all but the last
                $prefix = $1;                    # Letters
            }
            else {                               # Case 1.2, no number 
                $prefix = substr($b,0,2) . "0";  # first two + 0
            }
    }        
    elsif ((not defined $a) && (defined $c)) {   # Case 2, CALL/X
           if ($c =~ /^(\d)$/) {              # Case 2.1, number
                $b =~ /(.+\d)[A-Z]*/;            # regular Prefix in $1
                # Here we need to find out how many digits there are in the
                # prefix, because for example A45XR/0 is A40. If there are 2
                # numbers, the first is not deleted. If course in exotic cases
                # like N66A/7 -> N7 this brings the wrong result of N67, but I
                # think that's rather irrelevant cos such calls rarely appear
                # and if they do, it's very unlikely for them to have a number
                # attached.   You can still edit it by hand anyway..  
                if ($1 =~ /^([A-Z]\d)\d$/) {        # e.g. A45   $c = 0
                                $prefix = $1 . $c;  # ->   A40
                }
                else {                         # Otherwise cut all numbers
                $1 =~ /(.*[A-Z])\d+/;          # Prefix w/o number in $1
                $prefix = $1 . $c;}            # Add attached number    
            } 
            elsif ($c =~ /$csadditions/) {
                $b =~ /(.+\d)[A-Z]*/;       # Known attachment -> like Case 1.1
                $prefix = $1;
            }
            elsif ($c =~ /^\d\d+$/) {		# more than 2 numbers -> ignore
                $b =~ /(.+\d)[A-Z]*/;       # see above
                $prefix = $1;
			}
			else {                          # Must be a Prefix!
                    if ($c =~ /\d$/) {      # ends in number -> good prefix
                            $prefix = $c;
                    }
                    else {                  # Add Zero at the end
                            $prefix = $c . "0";
                    }
            }
    }
    elsif (defined $a) {                    # $a contains the prefix we want
            if ($a =~ /\d$/) {              # ends in number -> good prefix
                    $prefix = $a
            }
            else {                          # add zero if no number
                    $prefix = $a . "0";
            }
    }

# In very rare cases (right now I can only think of KH5K and KH7K and FRxG/T
# etc), the prefix is wrong, for example KH5K/DJ1YFK would be KH5K0. In this
# case, the superfluous part will be cropped. Since this, however, changes the
# DXCC of the prefix, this will NOT happen when invoked from with an
# extra parameter $_[1]; this will happen when invoking it from &dxcc.
    
if (($prefix =~ /(\w+\d)[A-Z]+\d/) && (not defined $_[1])) {
        $prefix = $1;                
}
    
return $prefix;
}
else { return ''; }    # no proper callsign received.
} # wpx ends here


##############################################################################
#
# &dxcc determines the DXCC country of a given callsign using the cty.dat file
# provided by K1EA at http://www.k1ea.com/cty/cty.dat .
# An example entry of the file looks like this:
#
# Portugal:                 14:  37:  EU:   39.50:     8.00:     0.0:  CT:
#    CQ,CR,CS,CT,=CR5FB/LH,=CS2HNI/LH,=CS5E/LH,=CT/DJ5AA/LH,=CT1BWW/LH,=CT1GFK/LH,=CT1GPQ/LGT,
#    =CT7/ON4LO/LH,=CT7/ON7RU/LH;
#
# The first line contains the name of the country, WAZ, ITU zones, continent, 
# latitude, longitude, UTC difference and main Prefix, the second line contains 
# possible Prefixes and/or whole callsigns that fit for the country, sometimes 
# followed by zones in brackets (WAZ in (), ITU in []).
#
# This sub checks the callsign against this list and the DXCC in which 
# the best match (most matching characters) appear. This is needed because for 
# example the CTY file specifies only "D" for Germany, "D4" for Cape Verde.
# Also some "unusual" callsigns which appear to be in wrong DXCCs will be 
# assigned properly this way, for example Antarctic-Callsigns.
# 
# Then the callsign (or what appears to be the part determining the DXCC if
# there is a "/" in the callsign) will be checked against the list of prefixes
# and the best matching one will be taken as DXCC.
#
# The return-value will be an array ("Country Name", "WAZ", "ITU", "Continent",
# "latitude", "longitude", "UTC difference", "DXCC").   
#
###############################################################################

sub dxcc {
	my $testcall = shift;
	my $matchchars=0;
	my $matchprefix='';
	my $test;
	my $zones = '';                 # annoying zone exceptions
	my $goodzone;
	my $letter='';


if ($fullcalls{$testcall}) {            # direct match with "="
    # do nothing! don't try to resolve WPX, it's a full
    # call and will match correctly even if it contains a /
}
elsif ($testcall =~ /(^OH\/)|(\/OH[1-9]?$)/) {    # non-Aland prefix!
    $testcall = "OH";                      # make callsign OH = finland
}
elsif ($testcall =~ /(^3D2R)|(^3D2.+\/R)/) { # seems to be from Rotuma
    $testcall = "3D2RR";                 # will match with Rotuma
}
elsif ($testcall =~ /^3D2C/) {               # seems to be from Conway Reef
    $testcall = "3D2CR";                 # will match with Conway
}
elsif ($testcall =~ /(^LZ\/)|(\/LZ[1-9]?$)/) {  # LZ/ is LZ0 by DXCC but this is VP8h
    $testcall = "LZ";
}
elsif ($testcall =~ /\w\/\w/) {             # check if the callsign has a "/"
    $testcall = &wpx($testcall,1)."AA";		# use the wpx prefix instead, which may
                                         # intentionally be wrong, see &wpx!
}

$letter = substr($testcall, 0,1);


foreach $mainprefix (keys %prefixes) {

	foreach $test (@{$prefixes{$mainprefix}}) {
		my $len = length($test);

		if ($letter ne substr($test,0,1)) {			# gains 20% speed
			next;
		}

		$zones = '';

		if (($len > 5) && ((index($test, '(') > -1)			# extra zones
						|| (index($test, '[') > -1))) {
				$test =~ /^([A-Z0-9\/]+)([\[\(].+)/;
				$zones .= $2 if defined $2;
				$len = length($1);
		}

		if ((substr($testcall, 0, $len) eq substr($test,0,$len)) &&
								($matchchars <= $len))	{
			$matchchars = $len;
			$matchprefix = $mainprefix;
			$goodzone = $zones;
		}
	}
}

my @mydxcc;										# save typing work

if (defined($dxcc{$matchprefix})) {
	@mydxcc = @{$dxcc{$matchprefix}};
}
else {
	@mydxcc = qw/Unknown 0 0 0 0 0 0 ?/;
}

# Different zones?

if ($goodzone) {
	if ($goodzone =~ /\((\d+)\)/) {				# CQ-Zone in ()
		$mydxcc[1] = $1;
	}
	if ($goodzone =~ /\[(\d+)\]/) {				# ITU-Zone in []
		$mydxcc[2] = $1;
	}
}

# cty.dat has special entries for WAE countries which are not separate DXCC
# countries. Those start with a "*", for example *TA1. Those have to be changed
# to the proper DXCC. Since there are opnly a few of them, it is hardcoded in
# here.

if ($mydxcc[7] =~ /^\*/) {							# WAE country!
	if ($mydxcc[7] eq '*TA1') { $mydxcc[7] = "TA" }		# Turkey
	if ($mydxcc[7] eq '*4U1V') { $mydxcc[7] = "OE" }	# 4U1VIC is in OE..
	if ($mydxcc[7] eq '*GM/s') { $mydxcc[7] = "GM" }	# Shetlands
	if ($mydxcc[7] eq '*IG9') { $mydxcc[7] = "I" }		# African Italy
	if ($mydxcc[7] eq '*IT9') { $mydxcc[7] = "I" }		# Sicily
	if ($mydxcc[7] eq '*JW/b') { $mydxcc[7] = "JW" }	# Bear Island
}

# CTY.dat uses "/" in some DXCC names, but I prefer to remove them, for example
# VP8/s ==> VP8s etc.

$mydxcc[7] =~ s/\///g;

return @mydxcc; 

} # dxcc ends here 


sub read_cty {
	# Read cty.dat from AD1C, or this program itself (contains cty.dat)
	my $self=0;
	my $filename;

	if (-e "/usr/local/etc/cty.dat") {
		$filename = "/usr/local/etc/cty.dat";
	}
	elsif (-e "/usr/local/share/dxcc/cty.dat") {
		$filename = "/usr/local/share/dxcc/cty.dat";
	}
	else {
		$filename = $0;
		$self = 1;
	}

	open CTY, $filename;

	while (my $line = <CTY>) {
		# When opening itself, skip all lines before "CTY".
		if ($self) {
			if ($line =~ /^#CTY/) {
				$self = 0
			}
			next;
		}

		# In case we're reading this file, remove #s
		if (substr($line, 0, 1) eq '#') {
			substr($line, 0, 1) = '';
		}

		if (substr($line, 0, 1) ne ' ') {			# New DXCC
			$line =~ /\s+([*A-Za-z0-9\/]+):\s+$/;
			$mainprefix = $1;
			$line =~ s/\s{2,}//g;
			@{$dxcc{$mainprefix}} = split(/:/, $line);
		}
		else {										# prefix-line
			$line =~ s/\s+//g;

            # read full calls into separate hash. this hash only
            # contains the information that this is a full call and
            # therefore doesn't need to be handled by &wpx even if
            # it contains a slash

            if ($line =~ /=/) {
                my @matches = ($line =~ /=([A-Z0-9\/]+)(\(\d+\))?(\[\d+\])?[,;]/g);
                foreach (@matches) {
                    $fullcalls{$_} = 1;
                }
            }

            # Continue with everything else. Including full calls, which will
            # be read as normal prefixes.

            $line =~ s/=//g;

            # handle "normal" prefixes
			unless (defined($prefixes{$mainprefix}[0])) {
				@{$prefixes{$mainprefix}} = split(/,|;/, $line);
			}
			else {
				push(@{$prefixes{$mainprefix}}, split(/,|;/, $line));
			}

		}
	}
	close CTY;

} # read_cty


sub search_earth_file {
	if (-e 'earth.gif') {		# current dir
		return 'earth.gif';
	}
	elsif ($0 =~ /(.+)\/bin\/dxcc$/) {	
		if (-e $1."/share/dxcc/earth.gif") {
			return $1."/share/dxcc/earth.gif"
		}
	}

	if (-e '/usr/local/share/dxcc/earth.gif') {
		return '/usr/local/share/dxcc/earth.gif';
	}
	elsif (-e '/usr/share/dxcc/earth.gif') {
		return '/usr/share/dxcc/earth.gif';
	}

	die "Couldn't find 'earth.gif'. Tried:\n".
		"./earth.gif,\n$1/share/dxcc/earth.gif,\n".
		"/usr/local/share/dxcc/earth.gif,\n/usr/share/dxcc/earth.gif\n";

}




sub qrbqtf {
	my ($mylat, $mylon, $hislat, $hislon) = @_;
	my $PI=3.14159265;
	my $z =180/$PI;

	my $g = acos(sin($mylat/$z)*sin($hislat/$z)+cos($mylat/$z)*cos($hislat/$z)*
						cos(($hislon-$mylon)/$z));

	my $dist = $g * 6371;
	my $dir = 0;

	unless ($dist == 0) {
		$dir = acos((sin($hislat/$z)-sin($mylat/$z)*cos($g))/
				(cos($mylat/$z)*sin($g)))*360/(2*$PI);
	}

	if (sin(($hislon-$mylon)/$z) < 0) { $dir = 360 - $dir;}
        $dir = 360 - $dir;

	return (int($dir), int($dist));

}




exit;
