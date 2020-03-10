include("../util.jl")

using JuMP, Gurobi

function TEAVAR(env,
                edges,
                capacity,
                flows,
                demand,
                beta,
                k,
                T,
                Tf,
                scenarios,
                scenario_probs;
                max_concurrent_flow=true,
                explain=false,
                verbose=false,
                utilization=false,
                average=false)
                
    nedges = length(edges)
    nflows = length(flows)
    ntunnels = length(T)
    nscenarios = length(scenarios)
    p = scenario_probs

    #CREATE TUNNEL SCENARIO MATRIX
    X  = ones(nscenarios,ntunnels)
    for s in 1:nscenarios
        for t in 1:ntunnels
            if size(T[t],1) == 0
                X[s,t] = 0
            else
                for e in 1:nedges
                    if scenarios[s][e] == 0
                        back_edge = findfirst(x -> x == (edges[e][2],edges[e][1]), edges)
                        if in(e, T[t]) || in(back_edge, T[t])
                        # if in(e, T[t])
                            X[s,t] = 0
                        end
                    end
                end
            end
        end
    end

    #CREATE TUNNEL EDGE MATRIX
    L = zeros(ntunnels, nedges)
    for t in 1:ntunnels
        for e in 1:nedges
            if in(e, T[t])
                L[t,e] = 1
            end
        end
    end

    model = Model(solver=GurobiSolver(env, OutputFlag=1))
    # flow per commodity per path variables
    @variable(model, a[1:nflows, 1:k] >= 0, basename="a", category=:SemiCont)
    # alpha variable
    @variable(model, alpha >= 0, basename="alpha", category=:SemiCont)
    # maximum flow lost in that scenario
    @variable(model, umax[1:nscenarios] >= 0, basename="umax")
    # flow lost per commod per scenario
    @variable(model, u[1:nscenarios, 1:nflows] >= 0, basename="u")
 
    # for s in 1:nscenarios
    # capacity constraints for final flow assigned to "a" variables
    for e in 1:nedges
        @constraint(model, sum(a[f,t] * L[Tf[f][t],e] for f in 1:nflows, t in 1:size(Tf[f],1)) <= capacity[e])
    end
    # end

    if max_concurrent_flow
      println("Running max concurrent flow")
      # FLOW LEVEL LOSS
      @expression(model, satisfied[s=1:nscenarios, f=1:nflows], sum(a[f,t] * X[s,Tf[f][t]] for t in 1:size(Tf[f],1)) / demand[f])

      for s in 1:nscenarios
          for f in 1:nflows
              # @constraint(model, (demand[f] - sum(a[f,t] * X[s,Tf[f][t]] for t in 1:size(Tf[f],1))) / demand[f] <= u[s,f])
              @constraint(model, u[s,f] >= 1 - satisfied[s,f])
          end
      end

      # SCENARIO LEVEL LOSS
      # for s in 1:nscenarios
          # @constraint(model, umax[s] + alpha >= 0)
      # end

      for s in 1:nscenarios
          if average
              @constraint(model, umax[s] + alpha >= (sum(u[s,f] for f in 1:nflows)) / nflows)
              # @constraint(model, umax[s] + alpha >= avg_loss[s])
          else
              for f in 1:nflows
                  @constraint(model, umax[s] + alpha >= u[s,f])
              end
          end
      end
      @objective(model, Min, alpha + (1 / (1 - beta)) * sum((p[s] * umax[s] for s in 1:nscenarios)))
    else
      # srikanth 3/6/2020
      # TODO: do these loss formulas hold if demands are not satisfiable?
      println("Running max total flow")
      @expression(model, satisfied[s=1:nscenarios, f=1:nflows], sum(a[f,t] * X[s, Tf[f][t]] for t in 1:size(Tf[f],1)))

      for s in 1:nscenarios
	for f in 1:nflows
	  @constraint(model, u[s, f] >= demand[f] - satisfied[s,f])
	  @constraint(model, umax[s] + alpha >= u[s,f])
	end
      end

      @objective(model, Min, alpha + (1/ (1-beta)) * sum((p[s] * umax[s] for s in 1:nscenarios)))
    end
    solve(model)


    if (explain)
        println("Runtime: ", getsolvetime(model))
	
	# some simple debugging information
	println("#edges: ", nedges)
	println("#tunnels: ", ntunnels)
	println("#demands: ", nflows, " total demand=", sum(demand[f] for f in 1:nflows))
	println("#scenarios: ", nscenarios)

	result_alpha = getvalue(alpha)
	result_a = getvalue(a)
	
	# compute net flow
	factor = 1 - result_alpha
	totalflow = 0
	for f in 1:nflows
	 println("Flow= ", f, " #tunnels= ", size(Tf[f], 1))
	 for t in 1:size(Tf[f], 1)
	  totalflow += result_a[f,t]
         end
        end

	println("totalalloc= ", totalflow, " netalloc= ", factor * totalflow)

        printResults(getobjectivevalue(model), result_alpha, result_a, getvalue(u), getvalue(umax), edges, scenarios, T, Tf, L, capacity, p, demand, verbose=verbose, utilization=utilization)
    end
    
    return (getvalue(alpha), getobjectivevalue(model), getvalue(a), getvalue(umax), getsolvetime(model))
end

