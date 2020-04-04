#!/bin/perl

use strict;

die "Usage: $0 <whichFile> <X: col to bin on> <Y's the comma separated list of values to average> [binSize:.01]\n"
if @ARGV < 3 || @ARGV > 4;

my $filename = $ARGV[0];
my $colX = $ARGV[1];
my @colYs = split(/,/, $ARGV[2]);
my $binSize = @ARGV>3? $ARGV[3]: .01;

$binSize = $ARGV[3] if ( @ARGV >= 4);

my %storage;

open f, "<$filename" or die "cannot read $filename\n";
while(<f>){
  my @vals = split(/\s+/);

  die "not enough vals for colX in $_\n" if @vals < $colX;
  my $key = $vals[$colX];
  my $bin = int($key/$binSize); #int (log($key + 1) / $binSize);

  my $colY;
  foreach $colY (@colYs){
    die "not enough vals for colY in $_\n" if @vals < $colY;
    my $val = $vals[$colY];

    $storage{$bin}->{$colY}->{"num"} ++;
    $storage{$bin}->{$colY}->{"mean"} += ($val - $storage{$bin}->{$colY}->{"mean"})/ ($storage{$bin}->{$colY}->{"num"});
    $storage{$bin}->{$colY}->{"mean2"} += ($val*$val - $storage{$bin}->{$colY}->{"mean2"})/ ($storage{$bin}->{$colY}->{"num"});
  }
}
close f;


my $bin;
foreach $bin (sort {$a<=>$b} keys %storage){
  my $key = $bin * $binSize; #exp ($bin * $binSize) - 1;
  print "$key";

  my $colY;
  foreach $colY (@colYs){
    my $mean = 0;
    my $std = 0;
    my $num = 0;

    if ( defined $storage{$bin}->{$colY} ){

      $mean = $storage{$bin}->{$colY}->{"mean"};
      my $mean2 = $storage{$bin}->{$colY}->{"mean2"};
      $num = $storage{$bin}->{$colY}->{"num"};

      $std = sqrt($mean2 - $mean*$mean);
    }

    print " col#$colY mean/std/num $mean $std $num";
  }
  print "\n";
}
