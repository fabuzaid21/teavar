set terminal pdfcairo dashed font ",16" size 6,3

set style line 1 lc rgb '#8b1a0e' pt 1 ps 1 lt 1 lw 5 # --- red
set style line 2 lc rgb '#8b1a0e' pt 8 ps 1 lt 1 dashtype 1 lw 5 # --- red diff points
set style line 3 lc rgb '#8b1a0e' pt 4 ps 1 lt 1 dashtype 1 lw 2 # --- red diff points

set style line 11 lc rgb '#5060D0' pt 1 ps 1 lt 1 lw 5 # --- green
set style line 12 lc rgb '#5060D0' pt 8 ps 1 lt 1 dashtype 1 lw 5 # --- green with diff points
set style line 13 lc rgb '#5060D0' pt 4 ps 1 lt 1 dashtype 1 lw 2 # --- green diff points
set style line 14 lc rgb '#5060D0' pt 4 ps 1 lt 1 dashtype 2 lw 5 # --- green diff points

set style line 21 lc rgb "#F25900" pt 1 ps 1 lt 1 lw 5
set style line 22 lc rgb "#F25900" pt 8 ps 1 lt 1 dashtype 1 lw 5
set style line 23 lc rgb "#F25900" pt 4 ps 1 lt 1 dashtype 1 lw 2
set style line 24 lc rgb "#F25900" pt 4 ps 1 lt 1 dashtype 4 lw 5

set style line 31 lc rgb "#990055" pt 1 ps 1 lt 1 lw 5

set style line 41 lc rgb "#005500" pt 1 ps 1 lt 1 dashtype 3 lw 3


set style line 101 lc rgb '#303030' lt 1
set border 3 back ls 101
set tics nomirror

set style line 102 lc rgb '#505050' lt 0 lw 1
set grid back ls 102

set output 'loss_due_to_failures.pdf'
set xlabel 'Loss = 1 - (Flow carried by scheme/ Flow carried by PF_4 when no fault)' offset 0,0.5
set ylabel 'CDF (over faults)' offset 1
set key at 0.9,0.7 font ",14"

plot \
	'data/agg_data_NCI_col0.pcdf' using 1:3 w lp ls 1 title 'NC before fault', \
	'data/agg_data_NCI_col3.pcdf' using 1:3 w lp ls 3 title 'NC after recompute', \
	'data/agg_data_NCI_col2.pcdf' using 1:3 w lp ls 2 title 'NC after fault', \
	'data/agg_data_TEAVARSTAR_B0.99_col0.pcdf' using 1:3 w lp ls 11 title 'TEAVAR* before fault', \
	'data/agg_data_TEAVARSTAR_B0.99_col2.pcdf' using 1:3 w lp ls 13 title 'TEAVAR* after re-balance',\
	'data/agg_data_TEAVARSTAR_B0.99_col1.pcdf' using 1:3 w lp ls 12 title 'TEAVAR* after fault', \
	'data/agg_data_TEAVAR_B0.99_col0.pcdf' using 1:3 w lp ls 21 title 'TEAVAR before fault', \
	'data/agg_data_TEAVAR_B0.99_col2.pcdf' using 1:3 w lp ls 23 title 'TEAVAR after re-balance', \
	'data/agg_data_TEAVAR_B0.99_col1.pcdf' using 1:3 w lp ls 22 title 'TEAVAR after fault'


set terminal pdfcairo dashed font ",22" size 3,3
set output 'nci_time_to_recompute.pdf'
set xlabel 'Recompute Time (ms)'
set ylabel 'CDF (over faults)'
set key at 14,0.5 spacing 1 samplen 0.4
plot \
	'data/agg_data_NCI_col4.pcdf' using (1000*$1):3 w l ls 31 title 'NC'
	

set terminal pdfcairo dashed font ",16" size 3,3
set output 'failure_timelapse.pdf'
set style textbox opaque noborder
set xlabel 'Time' offset 4,0.5
set ylabel 'Flow Allocation relative to PF_4'
set xrange [-10:30]
set yrange [0:1]
set key above spacing 1 samplen 0.6 font ",14"
set arrow nohead from 0,0 to 0,1 ls 41
set arrow nohead from 10,0 to 10,1 ls 41
set arrow nohead from 20,0 to 20,1 ls 41
set arrow from -3,0.12 to 0,0.18
set label "Fault happens" at -5, 0.1 font ",14" boxed
set arrow from 7,0.22 to 10, 0.28
set label "Tunnels rebalance" at 5, 0.2 font ",14" boxed
set arrow from 17,0.33 to 20, 0.38
set label "NC recomputes" at 15, 0.3 font ",14" boxed

eps=0.02
eps2=0.4
eps3=0.3
A=7 # first discontinuity
B=17 # next discontinuity
Y1=0 # lower axes
Y2=1 # upper axes
set arrow from A-eps2,Y1 to A+eps2,Y1 nohead lc rgb "#FFFFFF" front #whitespace on lower axes
set arrow from A-eps3-eps2,Y1-eps to A+eps3-eps2,Y1+eps nohead front
set arrow from A-eps3+eps2,Y1-eps to A+eps3+eps2,Y1+eps nohead front

set arrow from B-eps2,Y1 to B+eps2,Y1 nohead lc rgb "#FFFFFF" front #whitespace on lower axes
set arrow from B-eps3-eps2,Y1-eps to B+eps3-eps2,Y1+eps nohead front
set arrow from B-eps3+eps2,Y1-eps to B+eps3+eps2,Y1+eps nohead front
unset xtics
# set xtics ("Fault\n happens" 0, "Tunnels\n rebalance" 10, "NC\n recomputes" 20) font ",10" offset 0,.5
plot \
	'data/nci_timelapse' using 1:2 w l ls 1 title 'NC', \
	'data/teavarstar_timelapse' using 1:2 w l ls 14 title 'TEAVAR*', \
	'data/teavar_timelapse' using 1:2 w l ls 24 title 'TEAVAR'
