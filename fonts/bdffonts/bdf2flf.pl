#!/usr/bin/perl

# This script reads a bitmapped X font (BDF format) and writes
# a FIGfont.  The smushmode is set to 1.  Arbitrary encodings
# are handled.  All comments and properties are copied in.
# Copyright 1996 by John Cowan.  May be freely distributed.

$comments =
"Converted from $ARGV[0] by bdf2flf (by John Cowan <cowan\@ccil.org>)\n";
$magic = 0;

%charmap = (
	"Lslash", 0x0141,
	"OE", 0x0152,
	"Scaron", 0x0160,
	"Ydieresis", 0x0178,
	"Zcaron", 0x017d,
	"breve", 0x02d8,
	"bullet", 0x2022,
	"caron", 0x02c7,
	"dagger", 0x2020,
	"daggerdbl", 0x2021,
	"dotaccent", 0x02d9,
	"dotlessi", 0x0131,
	"ellipsis", 0x2026,
	"emdash", 0x2013,
	"endash", 0x2014,
	"fi", 0xfb01,
	"fl", 0xfb02,
	"florin", 0x0192,
	"fraction", 0x2044,
	"guilsinglleft", 0x2039,
	"guilsinglright", 0x203a,
	"hungarumlaut", 0x02dd,
	"lslash", 0x0142,
	"oe", 0x0153,
	"ogonek", 0x02db,
	"perthousand", 0x2030,
	"quotedblbase", 0x201e,
	"quotedblleft", 0x201c,
	"quotedblright", 0x201d,
	"quotesinglbase", 0x201a,
	"quotesingle", 0x2018,
	"ring", 0x02da,
	"scaron", 0x0161,
	"trademark", 0x2122,
	"zcaron", 0x017e);

while (<>) {
	chop;
	if (/^STARTFONT/) {
		($ver) = /^STARTFONT (\d+\.\d+)/;
		die "Source font is not BDF 2.1\n" unless $ver eq "2.1";
		}
	elsif (/^FONTBOUNDINGBOX/) {
		($width, $height, $junk, $depth) =
			/^FONTBOUNDINGBOX ([-\d]+) ([-\d]+) ([-\d]+) ([-\d]+)/;
		$up_ht = $height + $depth;	# $depth is negative
		}
	elsif (/^STARTPROPERTIES/ || /^ENDPROPERTIES/ || /^CHARS/ ||
			/^SWIDTH/ || /^DWIDTH/ || /^ATTRIBUTES/) {
		;
		}
	elsif (/^FONT /) {
		print STDERR "$_\n";
		$comments .= $_;
		}
	elsif (/^STARTCHAR/) {
		($charname) = /^STARTCHAR (.*)/;
		}
	elsif (/^ENCODING/) {
		($charcode) = /^ENCODING ([-\d]+)/;
		$charcode = $charmap{$charname}
			if $charcode == -1 && defined($charmap{$charname});
		$charcode = --$magic if $charcode == -1;
		}
	elsif (/^BBX/) {
		($cwidth, $cheight, $junk, $ht_off) =
			/^BBX ([-\d]+) ([-\d]+) ([-\d]+) ([-\d]+)/;
		}
	elsif (/^BITMAP/) {
#		printf STDERR 
#	"Reading %s (%s): height %s of %s, width %s of %s, raise by %s\n",
#			$charname, $charcode, $cheight, $height,
#			$cwidth, $width, $ht_off + $depth;
		&readmap();
		}
	elsif (/^ENDFONT/) {
		&putcomments();
		&putchars();
		}
	else {
		$comments .= "$_\n";
		}
	}

sub readmap {
	local($char) = "";
	local($blank) = (" " x $cwidth) . "\$\@\n";
	while (<>) {
		chop;
		last if /^ENDCHAR/;
		tr/a-z/A-Z/;
		s/0/    /g;
		s/1/   #/g;
		s/2/  # /g;
		s/3/  ##/g;
		s/4/ #  /g;
		s/5/ # #/g;
		s/6/ ## /g;
		s/7/ ###/g;
		s/8/#   /g;
		s/9/#  #/g;
		s/A/# # /g;
		s/B/# ##/g;
		s/C/##  /g;
		s/D/## #/g;
		s/E/### /g;
		s/F/####/g;
		$char .= substr($_, 0, $cwidth) . "\$\@\n";
		}
	$char = $blank x ($height - $cheight - ($ht_off - $depth)) .
		$char . $blank x ($ht_off - $depth);
	$char =~ s/\n$/\@\n/;
	if ($charcode >= 32 && $charcode <= 126) {
		$chars[$charcode] = $char;
		}
	else {
		$chars{$charcode} = $char;
		}
	$charnames{$charcode} = $charname;
	}

sub putcomments {
	$cmt_count = (@junk = ($comments =~ /\n/g)) + 0;
	$pluswidth = $width + 20;
	print "flf2a\$ $height $up_ht $pluswidth -1 $cmt_count\n";
	print $comments;
	}

sub codewise {
	return $a <=> $b if $a > 0 && $b > 0;
					# ascending positive comparison
	return -($a <=> $b) if $a <= 0 && $b <= 0;
					# descending nonpositive comparison
	return -1 if $b <= 0;
					# nonpositive exceeds positive
	return 1;
	}

sub putchars {
	for ($charcode = 32; $charcode <= 126; $charcode++) {
		if ($chars[$charcode] eq "") {
			print "\@\n" x ($height - 1), "\@\@\n";
			}
		else {
			print $chars[$charcode];
			}
		}
	foreach $charcode (196, 214, 220, 228, 246, 252, 223) {
		if ($chars{$charcode} eq "") {
			print "\@\n" x ($height - 1), "\@\@\n";
			}
		else {
			print $chars{$charcode};
			}
		}
	foreach $charcode (sort codewise keys(%chars)) {
		print $charcode, " ", $charnames{$charcode}, "\n";
		print $chars{$charcode};
		}
	}
