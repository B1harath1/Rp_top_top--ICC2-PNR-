set input_netlist "/proj1/pd/users/deva/high_freq_rp_top/rp_top_top.v"

##create design library
create_lib -technology /home/deva/ICC2_28NM_TECH2/tsmcn28_9lm4X2Y2RUTRDL.tf -ref_libs {/home/deva/ICC2_28NM_TECH2/tcbn28hpcplusbwp30p140hvt.ndm /home/deva/ICC2_28NM_TECH2/ts1n28hpcpuhdhvtb2048x129m4swbso_170a.ndm /home/deva/ICC2_28NM_TECH2/tsdn28hpcpuhdb4096x33m4mwa_170a.ndm} $design_name.ndmL

##Saving design library
save_lib

##Read verilog file
read_verilog $input_netlist -top $design_name


###mmmc file
source /home/guepd010067susdp22/bharath/dcshell/rptoptop/floorplan/mmmc_config.tcl
#source ./scripts/derate.tcl

##saving block for init stage
save_block -as design_init
