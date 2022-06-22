##Scenario settings
set_scenario_status -active false [all_scenarios]
set_scenario_status -active true [get_scenarios *setup*]
##Instance prefix 
set_app_options -name opt.common.user_instance_name_prefix -value "PNR_PLACEOPT"

##Scan def setting
set_app_options -name place.coarse.continue_on_missing_scandef -value true
###Lib cell dont use
set_lib_cell_purpose -exclude optimization [get_lib_cells {*/CK* */*D24* */*D32* */*D20* */*D18* */DEL*}]
##Bounds, magnet placement

place_opt
connect_pg_net -automatic

save_block -as placed

##reporting
file mkdir place_opt_reports
set report_dir place_opt_reports
set report_prefix pnr_place_opt
## Constraint violations
redirect -file ${report_dir}/${report_prefix}.report_constraint {report_constraint -all_violators -max_transition -max_capacitance -scenarios [all_scenarios]}
redirect -file ${report_dir}/${report_prefix}.report_timing.max {report_timing -delay max -scenarios [all_scenarios] -input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
analyze_design_violations -type setup -stage preroute -output ${report_dir}/${report_prefix}.analyze_design_violations
redirect -tee -file ${report_dir}/${report_prefix}.report_utilization {report_utilization}
redirect -file ${report_dir}/${report_prefix}.report_design {report_design -library -netlist -floorplan}
redirect -tee -file ${report_dir}/${report_prefix}.report_congestion.rpt {report_congestion -layers [get_layers -filter "layer_type==interconnect"] -rerun_global_router -nosplit}
redirect -file ${report_dir}/${report_prefix}.check_legality {check_legality -verbose}
