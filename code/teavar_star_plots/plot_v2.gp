set terminal pdfcairo dashed font ",16" size 6,3

set style line 1 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#5e9c36' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb "#5060D0" pt 2 ps 2 lt 1 lw 2

set style line 11 lc rgb '#8b1a0e' pt 1 ps 2 lt 1 dashtype 1 lw 2 # --- red
set style line 21 lc rgb '#5e9c36' pt 6 ps 2 lt 1 dashtype 2 lw 2 # --- green
set style line 31 lc rgb "#5060D0" pt 2 ps 2 lt 1 dashtype 4 lw 2

set style line 4 lc rgb "#F25900" lw 6 pt 9
set style line 5 lc rgb "#3f3f3f" lw 6 pt 8

set style line 11 lc rgb '#303030' lt 1
set border 3 back ls 11
set tics nomirror

set style line 12 lc rgb '#505050' lt 0 lw 1
set grid back ls 12

set log y
set output 'teavar_star_beta_v3.pdf'
set multiplot
set size 0.52,0.95
set xlabel 'Beta (Extent of fault assurance)'
set xrange [0.5:1]
set xtics (0.5 0.6, 0.7, 0.8, 0.9, 1)
set ylabel "Runtime ratio\n over PF_4" offset -1.5,0
set yrange [1:*]
set origin 0,0
set style fill pattern
set boxwidth 0.1 relative
set style textbox opaque noborder
set key at screen 0.9,0.97 vertical spacing 1 samplen 0.1 maxrows 1
set ytics ("1" 1, "10^2" 100, "10^4" 10000, "10^6" 1000000, "10^8" 100000000)
plot \
	'data/parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:12:8:9:14 title 'B4 TEAVAR*' with candlesticks ls 1, \
	'data/parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:4 notitle w l ls 11, \
	'data/parse_result_attmpls.graphml.flush.runtime_percentiles' using 1:12:8:9:14 title 'ATT TEAVAR*' with candlesticks ls 2, \
	'data/parse_result_attmpls.graphml.flush.runtime_percentiles' using 1:4 notitle w l ls 21, \
	'data/teavar_parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:12:8:9:14 title 'B4 TEAVAR' with candlesticks ls 3, \
	'data/teavar_parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:4 notitle w l ls 31
	
#	, \
#	'data/parse_result_uninett2010.graphml.flush' using 2:6 title 'Uninett2010'

set origin 0.48,0
set size 0.52,0.95
set yrange [*:1.1]
set ytics ("10^{-3}" 0.001, "10^{-2}" 0.01, "0.1" 0.1, 0.2, 0.5, "1" 1)
set ylabel "Flow ratio\n over PF_4" offset -0.25,0
set key off
plot \
	'data/parse_result_b4-teavar.json.flush.flow_percentiles' using 1:12:8:9:14 title 'B4' with candlesticks ls 1, \
	'data/parse_result_b4-teavar.json.flush.flow_percentiles' using 1:4 notitle w l ls 11, \
	'data/parse_result_attmpls.graphml.flush.flow_percentiles' using 1:12:8:9:14 title 'ATT' with candlesticks ls 2, \
	'data/parse_result_attmpls.graphml.flush.flow_percentiles' using 1:4 notitle w l ls 21, \
	'data/teavar_parse_result_b4-teavar.json.flush.flow_percentiles' using 1:12:8:9:14 title 'B4 teavar' with candlesticks ls 3, \
	'data/teavar_parse_result_b4-teavar.json.flush.flow_percentiles' using 1:4 notitle w l ls 31


#	, \
#	'data/parse_result_uninett2010.graphml.flush' using 1:4 title 'Uninett2010'
	
unset multiplot	
reset

set terminal pdfcairo

set log x
set log y
set output 'teavar_star_beta_v2.pdf'
set size 2,1
set multiplot
set size 1,0.5
set xlabel 'Max. Assurance'
set xrange [0.5:1]
set xtics (0.5 0.6, 0.7, 0.8, 0.9, 1)
set ylabel 'Runtime ratio over PF_4'
set yrange [0.9:*]
set origin 0,0.5
set key at 0.7,10000000
plot \
	'data/parse_result_b4-teavar.json.flush' using 2:6 title 'B4', \
	'data/parse_result_attmpls.graphml.flush' using 2:6 title 'ATT', \
	'data/teavar_parse_result_b4-teavar.json.flush' using 2:6 title 'B4 teavar', \
	'data/teavar_parse_result_attmpls.graphml.flush' using 2:6 title 'ATT teavar'
	
#	, \
#	'data/parse_result_uninett2010.graphml.flush' using 2:6 title 'Uninett2010'

set origin 0,0
set size 1,0.5
set yrange [*:1.1]
set ylabel 'Flow ratio over PF_4'
set key at 0.97,0.4
plot \
	'data/parse_result_b4-teavar.json.flush' using 2:5 title 'B4', \
	'data/parse_result_attmpls.graphml.flush' using 2:5 title 'ATT', \
	'data/teavar_parse_result_b4-teavar.json.flush' using 2:5 title 'B4 teavar', \
	'data/teavar_parse_result_attmpls.graphml.flush' using 2:5 title 'ATT teavar'


#	, \
#	'data/parse_result_uninett2010.graphml.flush' using 1:4 title 'Uninett2010'
	
unset multiplot	
reset

set log x
set log y
set output 'teavar_star_oversub_v2.pdf'
set size 1,1
set origin 0,0
set yrange [*:*]
set xlabel 'Demand scale factor'
set xrange [0.01:2]
set xtics (0.01, 0.1, 0.5, 1, 2)
plot \
	'data/parse_result_b4-teavar.json.flush' using 3:4 title 'B4 Flow', \
	'data/parse_result_b4-teavar.json.flush' using 3:5 title 'B4 Runtime', \
	'data/parse_result_attmpls.graphml.flush' using 3:4 title 'ATT Flow', \
	'data/parse_result_attmpls.graphml.flush' using 3:5 title 'ATT Runtime', \
	'data/parse_result_uninett2010.graphml.flush' using 3:4 title 'Uninett2010', \
	'data/parse_result_uninett2010.graphml.flush' using 3:5 title 'Uninett2010'
