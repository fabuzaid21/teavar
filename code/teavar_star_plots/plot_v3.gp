
set output 'loss_due_to_failures.pdf'
set xlabel '1 - (Flow carried by scheme/ Flow carried by PF_4 with no loss)'
set ylabel 'CDF (over faults)'

plot \
	'data/agg_data_NCI_col0.pcdf' using 1:3 w lp ls 1 title 'NC before fault', \
	'data/agg_data_NCI_col2.pcdf' using 1:3 w lp lt 2 title 'NC after fault', \
	'data/agg_data_NCI_col3.pcdf' using 1:3 w lp lt 3 title 'NC after recompute', \
	'data/agg_data_TEAVAR_col0.pcdf' using 1:3 w lp title 'TEAVAR before fault', \
	'data/agg_data_TEAVAR_col1.pcdf' using 1:3 w lp title 'TEAVAR after fault', \
	'data/agg_data_TEAVAR_col2.pcdf' using 1:3 w lp title 'TEAVAR after sources re-balance', \
	'data/agg_data_TEAVARSTAR_col0.pcdf' using 1:3 w lp title 'TEAVAR* before fault', \
	'data/agg_data_TEAVARSTAR_col1.pcdf' using 1:3 w lp title 'TEAVAR* after fault', \
	'data/agg_data_TEAVARSTAR_col2.pcdf' using 1:3 w lp title 'TEAVAR* after sources re-balance'
