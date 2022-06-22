##Scenario settings
set_scenario_status -active true [all_scenarios]
##Instance prefix 
set_app_options -name opt.common.user_instance_name_prefix -value "PNR_CTSOPT"
set_app_options -name cts.common.user_instance_name_prefix -value "CTS_BUFF"


###Lib cell dont use
set_lib_cell_purpose -exclude optimization [get_lib_cells {*/CK* */*D24* */*D32* */*D20* */*D18*}]
set_lib_cell_purpose -exclude cts [get_lib_cells */*]
set_lib_cell_purpose -include cts [get_lib_cells {*/CK*D4BWP* */CK*D8BWP* */CK*D12BWP* */CK*D16BWP* */CKND*D4BWP */CKND*D8BWP* */CKND*D12BWP* */CKND*D16BWP*}]

##NDR
create_routing_rule -multiplier_width 2 -multiplier_spacing 2 cts_2w2s
create_routing_rule -multiplier_width 1 -multiplier_spacing 2 cts_1w2s
set_clock_routing_rules -net_type {internal} -rules cts_2w2s -max_routing_layer M7 -min_routing_layer M4 
set_clock_routing_rules -net_type {root} -rules cts_2w2s -max_routing_layer M7 -min_routing_layer M4
set_clock_routing_rules -net_type {sink} -rules cts_1w2s -max_routing_layer M6 -min_routing_layer M3

#CTS exceptions (skew groups, explicit exceptions, inter clock balacing, float pin delay)

##CCD
set_app_option -name clock_opt.flow.enable_ccd -value false

##CTS targets
set_clock_tree_options -target_skew 0.1

foreach_in_collection scen [all_scenarios] { current_scenario  $scen; set_max_transition 0.15 [get_clocks *] -clock_path }

clock_opt -from build_clock -to route_clock
connect_pg_net -automatic

save_block -as CTS_build

##reporting
file mkdir cts_build_reports
set report_dir cts_build_reports
set report_prefix cts_build
## Constraint violations
redirect -file ${report_dir}/${report_prefix}.report_constraint {report_constraint -all_violators -max_transition -max_capacitance -scenarios [all_scenarios]}
redirect -file ${report_dir}/${report_prefix}.report_timing.max {report_timing -delay max -scenarios [all_scenarios] -input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
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
