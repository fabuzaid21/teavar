#!/bin/perl
use strict;

die "Usage: $0 <whichKey> <whichVal> <whichFile> [binSize] [doLog] [debug]\n" if @ARGV < 3 || @ARGV > 6;

# data structure
my $totalValuesBinned = 0;
my %logBinsPDF;
my $defaultBinSize = (@ARGV >= 4 && $ARGV[3]>0)? $ARGV[3]: .0001;
my $positiveOffset = 32;
my $doLog = (@ARGV>=4)? $ARGV[4]: 0;
my $DEBUG = (@ARGV>=5)? $ARGV[5]: 0;

# take input
my $whichKey = $ARGV[0];
my $whichVal = $ARGV[1];
my $whichFile = $ARGV[2];

my $minKey = "undef";
my $minKey_associatedValue = 0;

my $maxKey = "undef";
my $maxKey_associatedValue = 0;

if( $whichVal < 0 ){
  print "binning on col: $whichKey, value = number-of\n";
} else 
{
  print "binning on col: $whichKey, value = col: $whichVal\n";
}

my $linenum = 0;
open f, "<$whichFile" or die "cannot read $whichFile\n";
while(<f>){
  s/^\s+//g;
  s/\s+$//g;
  my @vals = split(/\s+/);

  $linenum ++;

  if ( @vals-1 < $whichKey || @vals -1 < $whichVal ){
    print "not enough cols in [$_]\n";
    next;
  }

  my $key = $vals[$whichKey];
  my $bin;

  next if $key eq "NaN" || $key eq "nan";
  $bin = &GetBin($key);

  my $value = ($whichVal <0)? 1: $vals[$whichVal];
  next if $value eq "NaN" || $value eq "nan";

  print "\t [debug]: [$linenum] bin $bin key $key val $value\n" if ($DEBUG);

  # keep special track of min and max key
  if ( $minKey eq "undef" || $key < $minKey ){
    print "\t [debug]: [$linenum] min: $minKey -> $key\n" if ($DEBUG);
    $minKey = $key;
    $minKey_associatedValue = 0;
  }
  $minKey_associatedValue += $value if ( $key == $minKey);

  if ( $maxKey eq "undef" || $key > $maxKey ){
    print "\t [debug]: [$linenum] max: $maxKey -> $key\n" if ($DEBUG);
    $maxKey = $key;
    $maxKey_associatedValue =0;
  }
  $maxKey_associatedValue += $value if ($key == $maxKey);

  $logBinsPDF{$bin} += $value;
  $totalValuesBinned += $value;
}
close f;


print "binned $totalValuesBinned values\n";
my $bin;
my $totalSoFar = 0;


my @bins = sort {$a <=> $b} keys %logBinsPDF;
my $i;
for($i=0; $i < @bins; $i++){
  my $bin = $bins[$i];

  my %pointsInBin = &PointsInBin($bin);
  my $v = $logBinsPDF{$bin}/ $totalValuesBinned;

  $totalSoFar += $v;
	
  if ( $i == 0 )
    {
      my $x = $minKey_associatedValue/ $totalValuesBinned;
      my $point = .5 * ($minKey + $pointsInBin{"right"});

      print "\t [debug] [bin index $i bin $bin] minkey print\n" if ($DEBUG);
      print $minKey, "\t", $x, "\t", $x, "\n";
      print $point, "\t", $v-$x, "\t", $totalSoFar, "\n" if ($v > $x);
    }

  elsif ( $i == $#bins )
    {
      my $point = .5 * ($pointsInBin{"left"} + $maxKey);
      my $x = $maxKey_associatedValue/ $totalValuesBinned;

      print "\t [debug] [bin index $i bin $bin] maxkey print\n" if ($DEBUG);

      print $point, "\t", $v-$x, "\t", $totalSoFar - $x, "\n" if ($v > $x);
      print $maxKey, "\t", $x, "\t", $totalSoFar, "\n";
    }
  else {
    print "\t [debug] [bin index $i bin $bin] print\n" if ($DEBUG);

    my $point = $pointsInBin{"middle"};
    print $point, "\t", $v, "\t", $totalSoFar,"\n";
  }
}


sub GetBin
  {
    my ($key) = @_;
    my $bin;

    if ( $doLog ) {
      $bin = int( log($key+$positiveOffset) / $defaultBinSize);
    } else {
      $bin = int ( $key/ $defaultBinSize);
    }

    return $bin;
  }

sub PointsInBin
  {
    my ($bin) = @_;

    my %pointsInBin;

    if ( $doLog ) {
      $pointsInBin{"left"} = exp($bin * $defaultBinSize) - $positiveOffset;
      $pointsInBin{"right"} = exp(($bin+1)*$defaultBinSize) - $positiveOffset;
    } else {
      $pointsInBin{"left"} = $bin * $defaultBinSize;
      $pointsInBin{"right"} = ($bin+1) * $defaultBinSize;
    }
    $pointsInBin{"middle"} = .5 * ( $pointsInBin{"left"} + $pointsInBin{"right"});

    return %pointsInBin;
  }
