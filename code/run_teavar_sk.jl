include("./util.jl")
include("./parsers.jl")
include("./Algorithms/TEAVAR_sk.jl")

env = Gurobi.Env()

topology = ARGS[1]
# failure probabilities must always come from topology
weibull = false
shape = 0.8
scale = 0.01

# we will change demand numerals and beta
demand_num = parse(Int, ARGS[2]) # used to be 1
beta=parse(Float64, ARGS[3]) # used to be 0.99
max_cf=ARGS[4] == "mcf" 
paths = ARGS[5] # used to be "SMORE" should be "SMORE4" or "SMORE8"

# output file for result analysis and debugging
outputfile=string(topology, "_d", demand_num, "_beta", beta, "_mcf", max_cf, "_paths", paths)


links, capacity, link_probs, nodes = readTopology(topology)
demand, flows = readDemand("$(topology)/demand", length(nodes), demand_num, matrix=true)
T, Tf, k = parsePaths("$(topology)/paths/$(paths)", links, flows)

if weibull
  probabilities = weibullProbs(length(links), shape=shape, scale=scale)
else
  probabilities = link_probs
end
println("FailureProbs= ", probabilities)

let cutoff = (sum(probabilities)/length(probabilities))^2
	while true
		global scenarios, scenario_probs = subScenariosRecursion(probabilities, cutoff)
		nscenarios = length(scenarios)
		total_scenario_prob = sum(scenario_probs)
	
		println("cutoff =", cutoff, " #scenarios=", nscenarios, " total_scenar_prob=", total_scenario_prob)

		if total_scenario_prob >= 1 - 0.1 * (1-beta)
			break
		end

		cutoff = cutoff / 2
	end
end

TEAVAR_SK(env, links, capacity, flows, demand, beta, k,
    T, Tf, scenarios, scenario_probs, outputfile, explain=true, verbose=true,
        utilization=true, max_concurrent_flow=max_cf)


