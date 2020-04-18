#!/bin/bash
# this is a runner for B4 topology
# run from NetContract/code/teavar/code
topo='AttMpls.graphml' 
for ((i=0; i<10; i=i+3)); 
do 
	for ((d=5; d<= 40; d=d+5)); 
	do 
		for beta in 0.9 0.3 0.5 0.7; #0.99
		do 
			echo "Demand $d Beta $beta Topo $topo faults $i"; 
			julia run_teavar_sk_silly.jl $topo $d $beta x EDInvCap4 topo_n${i}.txt 2 1 | tee teavar_star_${topo}_d${d}_maxflow_edinvcap4_topo_n${i}.txt_cutoff_downscale_2_beta${beta} > /dev/null; 
		done; 
	done; 
done;

