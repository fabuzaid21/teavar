#!/bin/bash
ODIR="teavar_star_plots/data"

# parse the teavar_star results
for topo in b4-teavar.json AttMpls.graphml uninett2010.graphml;
do
	topol=`echo $topo | awk '{print tolower($0)}'`
	echo "Parsing ${topo} runlogs/ topol = ${topol}";
	python3 sk_parse_results_v2.py ${topo} teavar_star > ${ODIR}/parse_result_${topol}
	grep ^Flush ${ODIR}/parse_result_${topol} > ${ODIR}/parse_result_${topol}.flush
done;


# parse teavar results
for topo in b4-teavar.json AttMpls.graphml;
do
	topol=`echo $topo | awk '{print tolower($0)}'`
	echo "Parsing TEAVAR results for ${topo}/ topol = ${topol}";
	python3 sk_parse_results_v2.py ${topo} teavar > ${ODIR}/teavar_parse_result_${topol}
	grep ^Flush ${ODIR}/teavar_parse_result_${topol} > ${ODIR}/teavar_parse_result_${topol}.flush
done;
