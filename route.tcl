##Scenario settings
set_scenario_status -active true [all_scenarios]
##Instance prefix 
set_app_options -name opt.common.user_instance_name_prefix -value "PNR_ROUTE_"

##Crosstalk enable
set_app_options -name time.si_enable_analysis -value true

route_auto
add_redundant_vias
connect_pg_net -automatic

save_block -as Routed

##reporting
file mkdir route_reports
set report_dir route_reports
set report_prefix route
## Constraint violations
redirect -file ${report_dir}/${report_prefix}.report_constraint {report_constraint -all_violators -max_transition -max_capacitance -scenarios [all_scenarios]}
redirect -file ${report_dir}/${report_prefix}.report_timing.max {report_timing -delay max -scenarios [all_scenarios] -input_pins -nets -transition_time -capacitance -attributes -physical -derate -report_by group}
analyze_design_violations -type setup -stage postroute -output ${report_dir}/${report_prefix}.analyze_design_violations
redirect -tee -file ${report_dir}/${report_prefix}.report_utilization {report_utilization}
redirect -file ${REPORTS_DIR}/${REPORT_PREFIX}.report_design {report_design -library -netlist -floorplan -routing}
redirect -file ${report_dir}/${report_prefix}.check_legality {check_legality -verbose}

##CTS specific reports
redirect -tee -file ${report_dir}/${report_prefix}.report_clock_qor.summary {report_clock_qor}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.latency {report_clock_qor -type latency -show_paths}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.cell_area {report_clock_qor -type area}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.structure {report_clock_qor -type structure}
redirect -file ${report_dir}/${report_prefix}.report_clock_qor.drc_violators {report_clock_qor -type drc_violators -all}
#Route specific
redirect -file ${report_dir}/${report_prefix}.check_routes {check_routes}
redirect -file ${report_dir}/${report_prefix}.check_lvs {check_lvs -max_errors 0}
