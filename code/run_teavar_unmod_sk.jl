include("./util.jl")
include("./parsers.jl")
include("./Algorithms/TEAVAR.jl")
using Dates;

env = Gurobi.Env()

topology = ARGS[1]
weibull = false
shape = 0.8
scale = 0.01
paths = ARGS[4]
demand_num = parse(Int, ARGS[2])
beta=parse(Float64, ARGS[3])
what_to_read = ARGS[5]
cutoff = parse(Float64, ARGS[6])
outputfile=string(topology, "_d", demand_num, "_paths", paths, "_beta", beta, "_topo", what_to_read)


links, capacity, link_probs, nodes = readTopology(topology, what_to_read=what_to_read)
demand, flows = readDemand("$(topology)/demand", length(nodes), demand_num, matrix=true)
T, Tf, k = parsePaths("$(topology)/paths/$(paths)", links, flows)

if weibull
  probabilities = weibullProbs(length(links), shape=shape, scale=scale)
else
  probabilities = link_probs
end
# cutoff = (sum(probabilities)/length(probabilities))^2
println("scenario cutoff =", cutoff)
println("FailureProbs= ", probabilities)
scenarios, scenario_probs = subScenariosRecursion(probabilities, cutoff)
TEAVAR(env, links, capacity, flows, demand, beta, k,
    T, Tf, scenarios, scenario_probs, outputfile, explain=true, verbose=true,
        utilization=true)


