##Scenario settings
set_scenario_status -active true [all_scenarios]
##Instance prefix 
set_app_options -name opt.common.user_instance_name_prefix -value "PNR_POSTCTS_OPT"


###Lib cell dont use
set_lib_cell_purpose -exclude optimization [get_lib_cells {*/CK* */*D24* */*D32* */*D20* */*D18*}]
##Cells for hold fixing
set_lib_cell_purpose -include hold [get_lib_cells {*/DEL* */BUFFD1BWP* */BUFFD2BWP*}]

##Only use if all scenarios are not active at CTS build stage 
#synthesize_clock_trees -propagate_only
#compute_clock_latency


##CCD
clock_opt -from final_opto -to final_opto
connect_pg_net -automatic

save_block -as Post_CTS

##reporting
file mkdir cts_opt_reports
set report_dir cts_opt_reports
set report_prefix cts_opt
## Constraint violations
redirect -file ${report_dir}/${report_prefix}.report_constraint {report_constraint -all_violators -max_transition -max_capacitance -scenarios [all_scenarios]}
redirect -file ${report_dir}/${report_prefix}.report_timing.max {report_timing -delay max -scenarios [all_scenarios] -input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
redirect -file ${report_dir}/${report_prefix}.report_timing.min {report_timing -delay min -scenarios [all_scenarios] -input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
analyze_design_violations -type setup -stage preroute -output ${report_dir}/${report_prefix}.analyze_design_violations
redirect -tee -file ${report_dir}/${report_prefix}.report_utilization {report_utilization}
redirect -file ${report_dir}/${report_prefix}.report_design {report_design -library -netlist -floorplan}
redirect -tee -file ${report_dir}/${report_prefix}.report_congestion.rpt {report_congestion -layers [get_layers -filter "layer_type==interconnect"] -rerun_global_router -nosplit}
redirect -file ${report_dir}/${report_prefix}.check_legality {check_legality -verbose}

##CTS specific reports
redirect -tee -file ${report_dir}/${report_prefix}.report_clock_qor.summary {report_clock_qor}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.latency {report_clock_qor -type latency -show_paths}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.cell_area {report_clock_qor -type area}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.structure {report_clock_qor -type structure}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.drc_violators {report_clock_qor -type drc_violators -all}

