import re
import os
import sys
from glob import iglob

DIR="/mnt/f/skgit/NetContract/code/teavar/code/"
topo = sys.argv[1] #"b4-teavar.json" #sys.argv[0]

result_fname = "result.{}".format(topo)
baselines = {}
with open(result_fname, 'r') as rf:
    for line in rf:
        match = re.search(r'RESULT D (\d+) .* z (\d.+) PF flow/runtime (\d.+) (\d.+) NcIEPE flow/runtime (\d.+) (\d.+)', line)
        if match:
            num_demand = match.group(1)
            z = match.group(2)
            pf_flow = match.group(3)
            pf_runtime = match.group(4)
            nc_flow = match.group(5)
            nc_runtime = match.group(6)
            baselines[num_demand] = (z, pf_flow, pf_runtime, nc_flow, nc_runtime)
    rf.close()
# print("baselines={}".format(baselines))

output_fnames = list(iglob('{}/teavar_star_{}_d*_maxflow_edinvcap4_topo_*'.format(DIR, topo)))

for o_fname in output_fnames:
    # print("output filename={}".format(o_fname))
    num_edges = 0
    num_flows = 0
    num_tunnels = 0
    num_scenarios = 0
    beta = 0
    total_scenario_prob = 0
    runtime = 0
    total_demand = 0
    netalloc = 0
    topo_num = 0
    demand_num = 0

    with open(o_fname, "r") as of:
        for line in of:
            match = re.search(r'\#edges (\d+) \#flows (\d+) \#tunnels (\d+) \#scenarios (\d+)', line)
            if match:
                num_edges = match.group(1)
                num_flows = match.group(2)
                num_tunnels = match.group(3)
                num_scenarios = match.group(4)

            match = re.search(r'beta: ([\d.]+)', line)
            if match:
                beta = match.group(1)

            match = re.search(r'Runtime: ([\d.]+)', line)
            if match:
                runtime = match.group(1)

            match = re.search(r'total demand=([\d.]+)', line)
            if match:
                total_demand = match.group(1)

            match = re.search(r'netalloc1/2= ([\d.]+)', line)
            if match:
                netalloc = match.group(1)

            match = re.search(r'total_scenario_prob= ([\d.]+)', line)
            if match:
                total_scenario_prob = match.group(1)

            match = re.search(r'topo_n([\d.]+).txt', o_fname)
            if match:
                topo_num = match.group(1)

            match = re.search(r'_d([\d.]+)_maxflow', o_fname)
            if match:
                demand_num = match.group(1)


        of.close()

    f = float(netalloc)* 1000
    r = float(runtime)
    
    if demand_num in baselines:
        z = float(baselines[demand_num][0])
        pf_f = float(baselines[demand_num][1])
        pf_r = float(baselines[demand_num][2])
        print("Raw Topo {} # {} Demand# {} #Edges {} #Flows {} #Tunnels {} #Scenarios {} TotProb {} Beta {} Runtime {} TD {} NetAlloc {} PFf/r {} {} z {} #File {}".format(
            topo, topo_num, demand_num, num_edges, num_flows, num_tunnels, num_scenarios, total_scenario_prob, beta, runtime, float(total_demand)*1000, float(netalloc)*1000, 
            pf_f, pf_r, z,
            o_fname
            ))
    if f > 0 and r > 0:
        print("Flush {} {} {} {}".format(total_scenario_prob, z, f/pf_f, r/pf_r))

