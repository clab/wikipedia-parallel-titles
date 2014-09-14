#!/usr/bin/perl -w
use strict;
die "Usage: $0 < file.txt\n" unless scalar @ARGV==0;
binmode(STDIN,":utf8");
binmode(STDOUT, ":utf8");
while(<STDIN>){
  print unless /[\x{0400}-\x{04ff}]/;
}
