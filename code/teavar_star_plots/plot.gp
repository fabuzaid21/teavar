set terminal pdfcairo

set log x
set log y
set output 'teavar_star_tsp.pdf'
set size 2,1
set multiplot
set size 1,0.5
set xlabel 'Max. Assurance (tot prob of considered scenarios)'
set xrange [0.5:1]
set xtics (0.5 0.6, 0.7, 0.8, 0.9, 1)
set ylabel 'Runtime ratio over PF_4'
set yrange [0.9:*]
set origin 0,0.5
set key at 0.7,10000000
plot \
	'data/all_parse_b4-teavar.json.flush' using 2:5 title 'B4', \
	'data/all_parse_attmpls.graphml.flush' using 2:5 title 'ATT', \
	'data/all_parse_uninett2010.graphml.flush' using 2:5 title 'Uninett2010'

set origin 0,0
set size 1,0.5
set yrange [*:1.1]
set ylabel 'Flow ratio over PF_4'
set key at 0.97,0.4
plot \
	'data/all_parse_b4-teavar.json.flush' using 2:4 title 'B4 Flow', \
	'data/all_parse_attmpls.graphml.flush' using 2:4 title 'ATT Flow', \
	'data/all_parse_uninett2010.graphml.flush' using 2:4 title 'Uninett2010'
	
unset multiplot	
reset

set log x
set log y
set output 'teavar_star_oversub.pdf'
set size 1,1
set origin 0,0
set yrange [*:*]
set xlabel 'Demand scale factor'
set xrange [0.01:2]
set xtics (0.01, 0.1, 0.5, 1, 2)
plot \
	'data/all_parse_b4-teavar.json.flush' using 3:4 title 'B4 Flow', \
	'data/all_parse_b4-teavar.json.flush' using 3:5 title 'B4 Runtime', \
	'data/all_parse_attmpls.graphml.flush' using 3:4 title 'ATT Flow', \
	'data/all_parse_attmpls.graphml.flush' using 3:5 title 'ATT Runtime', \
	'data/all_parse_uninett2010.graphml.flush' using 3:4 title 'Uninett2010', \
	'data/all_parse_uninett2010.graphml.flush' using 3:5 title 'Uninett2010'
