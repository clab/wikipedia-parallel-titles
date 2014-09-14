#!/usr/bin/perl -w

use strict;
use utf8;

die "Usage: $0 (en|fa|zh|..) fr.wikipage.sql.gz fr.langlinks.sql.gz\n" unless scalar @ARGV == 3;

binmode(STDIN,":utf8");
binmode(STDOUT,":utf8");

my $lang = shift @ARGV;
die unless $lang =~ /^[a-z][a-z][a-z]?$/;
my $rde = extract_page($ARGV[0]);
my $rdl = extract_langlinks($ARGV[1], $lang);

for my $k (sort keys %$rdl) {
  my $e = $rde->{$k};
  my $f = $rdl->{$k};
  print "$e ||| $f\n";
}


# TODO:
# select p.page_title,l.ll_title from page as p, langlinks as l where p.page_id = l.ll_from and l.ll_lang='en';
sub extract_page {
  my $f = shift;
  my $r = shift; # may be undef
  print STDERR "Reading page data from $f...\n";
  open F, "gunzip -c $f| iconv -f utf8 -t utf8 -c|" or die "Pipe failed zcat $f: $!";
  binmode(F,":utf8");
  my %d;
  my $dc = 0;
  while(<F>){
    while(/\((\d+),[^']+'((?:[^'\\]|\\.)*)'[^)]+/g) {
      my ($p, $m) = ($1,$2);
      if (defined $r) { next unless $r->{$p}; }
      $m =~ s/\\'/'/g;
      $m =~ s/\\"/"/g;
      $m =~ s/_/ /g;
      $m =~ s/–/-/g;
      $d{$p}=$m;
      $dc++;
    }
  };
  close F;
  print STDERR "  read $dc documents\n";
  return \%d;
}

sub extract_langlinks {
  my ($f, $la) = @_;
  print STDERR "Reading langlinks data from $f...\n";
  open F, "gunzip -c $f| iconv -f utf8 -t utf8 -c|" or die "Pipe failed zcat $f: $!";
  binmode(F,":utf8");
  my %d;
  my $dc = 0;
  #(27289,'aa','User:Marcin Łukasz Kiejzik'),
  while(<F>){
    while(/\((\d+),'([^']+)','((?:[^'\\]|\\.)*)'/g) {
      my ($p, $lang, $m) = ($1,$2, $3);
      next if $m =~ /^$/;
      next if $lang ne $la;
      $m =~ s/\\'/'/g;
      $m =~ s/\\"/"/g;
      $m =~ s/_/ /g;
      $m =~ s/–/-/g;
      $d{$p}=$m;
      $dc++;
    }
  };
  close F;
  print STDERR "  read $dc documents\n";
  return \%d;
}

