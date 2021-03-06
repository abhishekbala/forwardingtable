onerror {quit -f}
vlib work
vlog -work work fwdTable.vo
vlog -work work fwdTable.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.fwdTable_vlg_vec_tst
vcd file -direction fwdTable.msim.vcd
vcd add -internal fwdTable_vlg_vec_tst/*
vcd add -internal fwdTable_vlg_vec_tst/i1/*
add wave /*
run -all
