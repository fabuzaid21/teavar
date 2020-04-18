#!/bin/bash
# this is a runner for B4 topology
# run from NetContract/code/teavar/code
topo='b4-teavar.json' 
for ((d=5; d<=40; d=d+5));
do 
	for ((i=0; i<10; i=i+3)); # 0 3 6 9
	do 
		for beta in 0.999 0.3 0.5 0.7 0.9 0.99 0.8;
		do 
			echo "Demand $d Beta $beta Topo $topo faults $i"; 
			julia run_teavar_sk_silly.jl $topo $d $beta x EDInvCap4 topo_n${i}.txt 2 1 | tee teavar_star_${topo}_d${d}_maxflow_edinvcap4_topo_n${i}.txt_cutoff_downscale_2_beta${beta} > /dev/null; 
		done; 
	done; 
done;

