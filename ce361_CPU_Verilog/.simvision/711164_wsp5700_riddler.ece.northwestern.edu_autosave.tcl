
# XM-Sim Command File
# TOOL:	xmsim(64)	18.09-s011
#

set tcl_prompt1 {puts -nonewline "xcelium> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves cpu_tb.cpu_ut.clk cpu_tb.cpu_ut.instruction
probe -create -database waves cpu_tb.cpu_ut.RegDst cpu_tb.cpu_ut.MemWrite cpu_tb.cpu_ut.MemtoReg cpu_tb.cpu_ut.RegWrite
probe -create -database waves cpu_tb.cpu_ut.instructionfetcher.branch cpu_tb.cpu_ut.instructionfetcher.ctrl_branch
probe -create -database waves cpu_tb.cpu_ut.instructionfetcher.currpc
probe -create -database waves cpu_tb.cpu_ut.ALUout
probe -create -database waves cpu_tb.cpu_ut.ALUctrl cpu_tb.cpu_ut.ALUop
probe -create -database waves cpu_tb.cpu_ut.cpu_alu.B cpu_tb.cpu_ut.cpu_alu.A
probe -create -database waves cpu_tb.cpu_ut.zero
probe -create -database waves cpu_tb.cpu_ut.instructionfetcher.gtzfinal cpu_tb.cpu_ut.instructionfetcher.gtzoneout cpu_tb.cpu_ut.instructionfetcher.gtztwoout
probe -create -database waves cpu_tb.cpu_ut.instructionfetcher.bneqyn cpu_tb.cpu_ut.instructionfetcher.beqyn
probe -create -database waves cpu_tb.cpu_ut.datamem.mem[27] cpu_tb.cpu_ut.datamem.mem[26] cpu_tb.cpu_ut.datamem.mem[25] cpu_tb.cpu_ut.datamem.mem[24] cpu_tb.cpu_ut.datamem.mem[23] cpu_tb.cpu_ut.datamem.mem[22] cpu_tb.cpu_ut.datamem.mem[21] cpu_tb.cpu_ut.datamem.mem[20] cpu_tb.cpu_ut.datamem.mem[19] cpu_tb.cpu_ut.datamem.mem[18] cpu_tb.cpu_ut.datamem.mem[17] cpu_tb.cpu_ut.datamem.mem[16]

simvision -input /home/wsp5700/ce361/361-Project-One-Group-14/ce361_CPU_Verilog/.simvision/711164_wsp5700_riddler.ece.northwestern.edu_autosave.tcl.svcf
