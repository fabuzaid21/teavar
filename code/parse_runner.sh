#!/bin/bash
ODIR="teavar_star_plots/data"

# parse the teavar_star results
for topo in b4-teavar.json attmpls.graphml uninett2010.graphml;
do
	echo "Parsing ${topo} runlogs";
	python3 sk_parse_results_v2.py ${topo} teavar_star > ${ODIR}/parse_result_${topo}
	grep ^Flush ${ODIR}/parse_result_${topo} > ${ODIR}/parse_result_${topo}.flush
done;


# parse teavar results
# for topo in b4-teavar.json;
# do
	# echo "Parsing TEAVAR results for ${topo}";
	# python3 sk_parse_results_v2.py ${topo} teavar > ${ODIR}/teavar_parse_result_${topo}
	# grep ^Flush ${ODIR}/teavar_parse_result_${topo} > ${ODIR}/teavar_parse_result_${topo}.flush
# done;