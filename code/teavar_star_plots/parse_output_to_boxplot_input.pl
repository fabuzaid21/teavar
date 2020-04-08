#!/usr/bin/perl

my $scriptdir = "/home/kandula/NetContract/code/teavar/code/teavar_star_plots";
my $datadir = $scriptdir."/data";
my @filenames = (
	"parse_result_attmpls.graphml.flush", "parse_result_b4-teavar.json.flush", 
	"teavar_parse_result_attmpls.graphml.flush", "teavar_parse_result_b4-teavar.json.flush");

my @commandargs = ( ["1 4 e", "flow"], ["1 5 e", "runtime"] );

foreach my $filename (@filenames)
{
	foreach my $cmdarg (@commandargs)
	{
		my $cmd = "perl ${scriptdir}/binByX_DistribYs.pl ${datadir}/$filename ". @{$cmdarg}[0]. " > ${datadir}/${filename}.". @{$cmdarg}[1]. "_percentiles";
		print "To exec: [$cmd]\n";
		system($cmd);
	}
}