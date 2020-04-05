#!/bin/perl
# 4/4/2020 for teavar failure result
# TODO: test binning carefully
# TODO: support logarithmic binning

use strict;

die "Usage: $0 <whichFile> <X: index of col to bin on> <Ys: index of cols to compute distribution over> [binSize:.01; e for explicit]\n"
if @ARGV < 3 || @ARGV > 4;

my $filename = $ARGV[0];
my $colX = $ARGV[1];
my @colYs = split(/,/, $ARGV[2]);
my $binSize = @ARGV>3? $ARGV[3]: .01;

my %storage;

open f, "<$filename" or die "cannot read $filename\n";
while(<f>){
  my @vals = split(/\s+/);

  die "not enough vals for colX in $_\n" if @vals < $colX;
  my $key = $vals[$colX];
  my $bin = $binSize eq "e" ? $key : int($key/$binSize);

  my $colY;
  foreach $colY (@colYs){
    die "not enough vals for colY in $_\n" if @vals < $colY;
    my $val = $vals[$colY];

    $storage{$bin}->{$colY}->{"num"} ++;
    $storage{$bin}->{$colY}->{"mean"} += ($val - $storage{$bin}->{$colY}->{"mean"}) / ($storage{$bin}->{$colY}->{"num"});
    $storage{$bin}->{$colY}->{"mean2"} += (($val*$val) - $storage{$bin}->{$colY}->{"mean2"}) / ($storage{$bin}->{$colY}->{"num"});
	$storage{$bin}->{$colY}->{"vals"} = [] if not defined $storage{$bin}->{$colY}->{"vals"};
	push @{$storage{$bin}->{$colY}->{"vals"}}, $val;
  }
}
close f;

my @percentiles = (0.1, 0.25, 0.5, 0.75, 0.9);
my $bin;
foreach $bin (sort {$a<=>$b} keys %storage){
  my $key = $binSize eq "e"? $bin : $bin * $binSize; #exp ($bin * $binSize) - 1;
  print "$key";

  my $colY;
  foreach $colY (@colYs){
    my $mean = 0;
    my $std = 0;
    my $num = 0;
	my ($minV, $maxV) = 0;
	my @percentileV;

    if ( defined $storage{$bin}->{$colY} ){

      $mean = $storage{$bin}->{$colY}->{"mean"};
      my $mean2 = $storage{$bin}->{$colY}->{"mean2"};
      $num = $storage{$bin}->{$colY}->{"num"};
	  my @vals = sort {$a <=> $b} @{$storage{$bin}->{$colY}->{"vals"}};

	  # print " $num $mean $mean2 vals= ", join(',', @vals), "\n";
	  
	  $std = ($mean2 < $mean*$mean) ? 0 : sqrt($mean2 - $mean*$mean);
	  
	  my $numvals = @vals + 1;
	  $minV = $vals[0];
	  $maxV = $vals[$#vals];
	  for (my $pid = 0; $pid <= $#percentiles; $pid++)
	  {
		my $percentile = $percentiles[$pid];
		$percentileV[$pid] = $vals[int($numvals * $percentile)];
	  }
    }

    print " col#$colY mean/std/num $mean $std $num";
	print " min/max $minV $maxV";
	print " percentiles:", join(',', @percentiles), " ", join(' ', @percentileV);
  }
  print "\n";
}
