#!/bin/bash
# this is a runner for B4 topology
# uns mcf with teavar unmod
# run from NetContract/code/teavar/code
topo='b4-teavar.json' 
for ((d=40; d>0; d=d-10)); # 10 20 30 40
do 
	for ((i=0; i<10; i=i+3)); # 0 3 6 9
	do 
		for beta in 0.995 0.999 0.3 0.5 0.7 0.9 0.99 0.8;
		do 
			echo "Demand $d Beta $beta Topo $topo faults $i"; 
			julia run_teavar_unmod_sk.jl $topo $d $beta EDInvCap4 topo_n${i}.txt 0.00001 | tee teavar_${topo}_d${d}_mcf_edinvcap4_topo_n${i}.txt_cutoff_0.00001_beta${beta} > /dev/null; 
		done; 
	done; 
done;
