#!/usr/bin/perl -w

use strict;
use utf8;

binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");

while(<STDIN>) {
  chomp;
  next if /#/;
  next if /wikipedia:|Image:|talk:|\.jpg|\.png|Module:|Project:|MediaWiki:|user:|Help:|User:|Wikisource:|Wikipedia:|Special:|File:/i;
  s/Author:|Portal://g;
  my ($a,$b) = split / \|\|\| /;
  $a =~ s/\([^)]+\)//;
  $b =~ s/\([^)]+\)//;
  next if ($b =~ /template:|Template:|Category:/);
  next if ($a =~ /^\s*$/ or $b =~ /^\s*$/);
  my $z = "$a ||| $b";
  $z =~ s/\s+/ /g;
  print "$z\n";
}
