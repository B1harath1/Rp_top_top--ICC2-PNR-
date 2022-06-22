
set tluplus_path "/home/deva/ICC2_28NM_TECH2"

###Modes
create_mode func

###Create corners
create_corner ssg0p81v125c_rcw
create_corner ssg0p81vm40c_cw
create_corner ffg0p99vm40c_cb
create_corner ffg0p99v125c_rcb



###create RC corners
read_parasitic_tech -name cw -tlup $tluplus_path/cln28hpc+_1p09m+ut-alrdl_4x2y2r_cworst.tluplus
read_parasitic_tech -name rcw  -tlup $tluplus_path/cln28hpc+_1p09m+ut-alrdl_4x2y2r_rcworst.tluplus
read_parasitic_tech -name cb -tlup $tluplus_path/cln28hpc+_1p09m+ut-alrdl_4x2y2r_cbest.tluplus
read_parasitic_tech -name rcb -tlup $tluplus_path/cln28hpc+_1p09m+ut-alrdl_4x2y2r_rcbest.tluplus


###set operating conditions

current_corner ssg0p81v125c_rcw
set_voltage 0.81 -object_list VDD
set_voltage 0.00 -object_list VSS
set_temperature 125
set_process_number 1.0
set_operating_conditions -analysis_type on_chip_variation
set_parasitic_parameters -early_spec rcw -late_spec rcw -corners [get_corners ssg0p81v125c_rcw]

current_corner ssg0p81vm40c_cw
set_voltage 0.81 -object_list VDD
set_voltage 0.00 -object_list VSS
set_temperature -40
set_process_number 1.0
set_operating_conditions -analysis_type on_chip_variation
set_parasitic_parameters -early_spec cw -late_spec cw -corners [get_corners ssg0p81vm40c_cw]

current_corner ffg0p99vm40c_cb
set_voltage 0.99 -object_list VDD
set_voltage 0.00 -object_list VSS
set_temperature -40
set_process_number 1.0
set_operating_conditions -analysis_type on_chip_variation
set_parasitic_parameters -early_spec cb -late_spec cb -corners [get_corners ffg0p99vm40c_cb]

current_corner ffg0p99v125c_rcb 
set_voltage 0.99 -object_list VDD
set_voltage 0.00 -object_list VSS
set_temperature 125
set_process_number 1.0
set_operating_conditions -analysis_type on_chip_variation
set_parasitic_parameters -early_spec rcb -late_spec rcb -corners [get_corners ffg0p99v125c_rcb]


create_scenario -mode func -corner ssg0p81v125c_rcw -name func_setup_ssg0p81v125c_rcw
create_scenario -mode func -corner ssg0p81vm40c_cw -name func_setup_ssg0p81vm40c_cw
create_scenario -mode func -corner ffg0p99vm40c_cb -name func_hold_ffg0p99vm40c_cb
create_scenario -mode func -corner ffg0p99v125c_rcb -name func_hold_ffg0p99v125c_rcb


current_mode func
current_scenario func_setup_ssg0p81vm40c_cw

source /home/guepd010067susdp22/bharath/dcshell/rptoptop/floorplan/rp_top.sdc 

set_scenario_status -setup true -hold false [get_scenarios *setup*]
set_scenario_status -setup false -hold true [get_scenarios *hold*]
