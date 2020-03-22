import re
import os
import sys
from glob import iglob

# for sk-z820
# DIR="/mnt/f/skgit/NetContract/code/teavar/code/"
# for gcr-azsb-106
DIR = "/home/kandula/NetContract/code/teavar/code/"
topo = sys.argv[1] #"b4-teavar.json" #sys.argv[0]
DEBUG = False

result_fname = "result.{}".format(topo)
if DEBUG:
    print("Reading baselines from {}".format(result_fname))
baselines = {}
with open(result_fname, 'r') as rf:
    for line in rf:
        match = re.search(r'RESULT D (\d+) .* z (\d.+) PF flow/runtime (\d.+) (\d.+) NcIEPE flow/runtime.* (\d.+) (\d.+)', line)
        if match:
            num_demand = match.group(1)
            z = match.group(2)
            pf_flow = match.group(3)
            pf_runtime = match.group(4)
            nc_flow = match.group(5)
            nc_runtime = match.group(6)
            baselines[num_demand] = (z, pf_flow, pf_runtime, nc_flow, nc_runtime)
    rf.close()
    
if DEBUG:
    print("Found baselines={}".format(baselines))

output_fnames = list(iglob('{}/teavar_star_{}_d*_maxflow_edinvcap4_topo_*'.format(DIR, topo)))

for o_fname in output_fnames:
    if DEBUG:
        print("Parsing output filename={}".format(o_fname))
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
    num_match = 0
    num_must_match = 8  # ignore partial output files
    
    # parse some fields from file name
    match = re.search(r'_d([\d.]+)_maxflow', o_fname)
    if match:
        demand_num = match.group(1)
        num_match += 1
            
    if demand_num not in baselines:
        print("Skip {} since demand_num {} not in baselines".format(o_fname, demand_num))
        continue
            
    match = re.search(r'topo_n([\d.]+).txt', o_fname)
    if match:
        topo_num = match.group(1)
        num_match += 1

    # parse the actual file
    with open(o_fname, "r") as of:    
        for line in of:
            match = re.search(r'\#edges (\d+) \#flows (\d+) \#tunnels (\d+) \#scenarios (\d+)', line)
            if match:
                num_edges = match.group(1)
                num_flows = match.group(2)
                num_tunnels = match.group(3)
                num_scenarios = match.group(4)
                num_match += 1

            match = re.search(r'beta: ([\d.]+)', line)
            if match:
                beta = match.group(1)
                num_match += 1

            match = re.search(r'Runtime: ([\d.]+)', line)
            if match:
                runtime = match.group(1)
                num_match += 1

            match = re.search(r'total demand=([\d.]+)', line)
            if match:
                total_demand = match.group(1)
                num_match += 1

            match = re.search(r'netalloc1/2= ([\d.]+)', line)
            if match:
                netalloc = match.group(1)
                num_match += 1

            match = re.search(r'total_scenario_prob= ([\d.]+)', line)
            if match:
                total_scenario_prob = match.group(1)
                num_match += 1

        of.close()

    if num_match != num_must_match:
        print("Skipping case {} only {}/{} matches; perhaps output is partial?".format(o_fname, num_match, num_must_match))
        continue

    f = float(netalloc)* 1000
    r = float(runtime)
    
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