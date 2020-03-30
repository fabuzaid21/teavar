#!/bin/bash
ODIR="teavar_star_plots/data"
for topo in b4-teavar.json attmpls.graphml uninett2010.graphml;
do
	echo "Parsing ${topo} runlogs";
	python3 sk_parse_results_v2.py ${topo} > ${ODIR}/parse_result_${topo}
	grep ^Flush ${ODIR}/parse_result_${topo} > ${ODIR}/parse_result_${topo}.flush
done;
