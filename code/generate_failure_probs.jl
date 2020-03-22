include("./util.jl")
include("./parsers.jl")
include("./Algorithms/TEAVAR_sk.jl")
using Dates;

env = Gurobi.Env()

topology = ARGS[1]

weibull = true
shape = 0.8
scale = 0.01

links, capacity, link_probs, nodes = readTopology(topology)

probabilities = weibullProbs(length(links), shape=shape, scale=scale)
println("FailureProbs= ", probabilities)

writeTopology(topology, links, capacity, probabilities)
