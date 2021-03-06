set terminal pdfcairo dashed font ",16" size 6,3

set style line 1 lc rgb '#ff6611' pt 1 ps 2 lt 1 lw 2 # --- red
set style line 2 lc rgb '#337711' pt 6 ps 2 lt 1 lw 2 # --- green
set style line 3 lc rgb "#cc33ff" pt 2 ps 2 lt 1 lw 2
set style line 4 lc rgb "#33ccff" pt 8 ps 2 lt 1 lw 2

set style line 11 lc rgb '#ff6611' pt 1 ps 2 lt 1 dashtype 1 lw 1 # --- red
set style line 21 lc rgb '#337711' pt 6 ps 2 lt 1 dashtype 2 lw 1 # --- green
set style line 31 lc rgb "#cc33ff" pt 2 ps 2 lt 1 dashtype 4 lw 1
set style line 41 lc rgb "#33ccff" pt 8 ps 2 lt 1 dashtype 5 lw 1

set style line 101 lc rgb '#303030' lt 1
set border 3 back ls 101
set tics nomirror

set style line 102 lc rgb '#505050' lt 0 lw 1
set grid back ls 102

set log y
set output 'teavar_star_beta_v3.pdf'
set multiplot
set size 0.52,0.95
set xlabel 'Beta (Extent of fault assurance)'
set xrange [0.45:1]
set xtics (0.5 0.6, 0.7, 0.8, 0.9, 1)
set ylabel "Runtime ratio\n over PF_4" offset -1.5,0
set yrange [1:*]
set origin 0,0
set style fill pattern
set boxwidth 0.02 absolute
set style textbox opaque noborder
set key at screen 0.9,0.97 vertical spacing 1 samplen 0.1 maxrows 1
set ytics ("1" 1, "10^2" 100, "10^4" 10000, "10^6" 1000000, "10^8" 100000000)
plot \
	'data/parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:12:8:9:14 title 'B4 TEAVAR*' with candlesticks ls 1, \
	'data/parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:4 notitle w l ls 11, \
	'data/parse_result_attmpls.graphml.flush.runtime_percentiles' using 1:12:8:9:14 title 'ATT TEAVAR*' with candlesticks ls 2, \
	'data/parse_result_attmpls.graphml.flush.runtime_percentiles' using 1:4 notitle w l ls 21, \
	'data/teavar_parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:12:8:9:14 title 'B4 TEAVAR' with candlesticks ls 3, \
	'data/teavar_parse_result_b4-teavar.json.flush.runtime_percentiles' using 1:4 notitle w l ls 31, \
	'data/teavar_parse_result_attmpls.graphml.flush.runtime_percentiles' using 1:12:8:9:14 title 'ATT TEAVAR' with candlesticks ls 4, \
	'data/teavar_parse_result_attmpls.graphml.flush.runtime_percentiles' using 1:4 notitle w l ls 41

set origin 0.48,0
set size 0.52,0.95
set yrange [0:1.05]
set ytics auto
set nolog y
set ylabel "Flow ratio\n over PF_4" offset -0.25,0
set key off
plot \
	'data/parse_result_b4-teavar.json.flush.flow_percentiles' using ($1-.015):12:8:9:14 title 'B4' with candlesticks ls 1, \
	'data/parse_result_b4-teavar.json.flush.flow_percentiles' using ($1-.015):4 notitle w l ls 11, \
	'data/parse_result_attmpls.graphml.flush.flow_percentiles' using ($1-.005):12:8:9:14 title 'ATT' with candlesticks ls 2, \
	'data/parse_result_attmpls.graphml.flush.flow_percentiles' using ($1-.005):4 notitle w l ls 21, \
	'data/teavar_parse_result_b4-teavar.json.flush.flow_percentiles' using ($1+.005):12:8:9:14 title 'B4 teavar' with candlesticks ls 3, \
	'data/teavar_parse_result_b4-teavar.json.flush.flow_percentiles' using ($1+.005):4 notitle w l ls 31, \
	'data/teavar_parse_result_attmpls.graphml.flush.flow_percentiles' using ($1+.015):12:8:9:14 title 'ATT TEAVAR' with candlesticks ls 4, \
	'data/teavar_parse_result_attmpls.graphml.flush.flow_percentiles' using ($1+.015):4 notitle w l ls 41
