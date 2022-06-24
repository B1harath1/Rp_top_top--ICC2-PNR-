
##Std cell filler
create_stdcell_filler -lib_cell [get_lib_cells */DCAP*]
connect_pg_net
remove_stdcell_fillers_with_violation
create_stdcell_filler -lib_cell [get_lib_cells */FILL*]
connect_pg_net



set design_name rp_top_top
change_names -rules verilog -hierarchy
write_def -version 5.8 $design_name.def

write_verilog -hierarchy all $design_name.lvs.v
write_verilog -compress gzip -exclude {pg_objects end_cap_cells well_tap cells filler_cells physical_only_cells} -hierarchy all $design_name.sta.v

##SPEF
## write_parasitics
update_timing
write_parasitics -output $design_name

write_gds -hierarchy all -long_names $design_name.gds
#
create_frame -block_all true
write_lef 
