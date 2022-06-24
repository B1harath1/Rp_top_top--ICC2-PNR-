###Power planning
set_host_options -max_cores 8
puts "USER_INFO: ####----------------------Start of PG insertion--------------------------------####"
#To disable via creation during compile pg
set_app_options -name plan.pgroute.disable_via_creation -value true
###To create M1 rails
#create_pg_std_cell_conn_pattern rail_pattern -layers M1
create_pg_std_cell_conn_pattern rail_pattern -layers M1 -rail_width 0.15
set_pg_strategy M1_rails -core -pattern {{name: rail_pattern} {nets: vdd vss}}
###Define PG mesh for M5 to M7 layers (only in core region)
create_pg_mesh_pattern m5tom7_mesh_pattern -layers {{{vertical_layer: M5} {width: 0.45} {spacing: minimum} {pitch: 5.0} {offset: 0.6}} \
					     {{horizontal_layer: M6} {width: 0.45} {spacing: minimum} {pitch: 5.0} {offset: 0.6}} \
					     {{vertical_layer: M7} {width: 0.62} {spacing: minimum} {pitch: 3.0} {offset: 0.6}}}
set_pg_strategy PG_mesh -core -pattern {{name: m5tom7_mesh_pattern} {nets: vdd vss}} -extension {{layers: M5} {stop: 0.2}}
##Define PG mesh for M8 & M9 (extended till die boundary, assuming they need to be aligned at top)
create_pg_mesh_pattern m8m9_mesh_pattern -layers {{{horizontal_layer: M8} {width: 1.52} {spacing: minimum} {pitch: 6.0} {offset: 3.2}} \
					     	  {{vertical_layer: M9} {width: 3.0} {spacing: minimum} {pitch: 7.3} {offset: 3.48}}}
set_pg_strategy M8M9PG_mesh -design_boundary -pattern {{name: m8m9_mesh_pattern} {nets: vdd vss}} -extension {{stop: design_boundary_and_generate_pin}}
##
compile_pg -strategies {M8M9PG_mesh PG_mesh M1_rails}


###Create PG vias
set layer_pairs [list {M9 M8 VIA89_1cut} {M8 M7 VIA78_1cut} {M7 M6 VIA67_1cut} {M6 M5 VIA56_1cut}]
foreach lyr_pr $layer_pairs {
set frm_lyr [lindex $lyr_pr 0]
set to_lyr [lindex $lyr_pr 1]
set via_mstr [lindex $lyr_pr 2]
puts "$via_mstr"
puts "USER_INFO: ####----------------------Creating PG vias between $frm_lyr & $to_lyr------------------------####"
#create_pg_vias -from_layers $frm_lyr -to_layers $to_lyr -nets {v08 vss} -within_bbox [get_attribute [current_block] bbox] -via_masters $via_mstr
create_pg_vias -from_layers $frm_lyr -to_layers $to_lyr -nets {vdd vss} -within_bbox [get_attribute [current_block] bbox] 
}
##Creating pg vias between M1 & M5
set_pg_via_master_rule via1_rule -contact_code VIA12_1cut -cut_spacing 0.1 -via_array_dimension {3 1}
set_pg_via_master_rule via2_rule -contact_code VIA23_1cut -cut_spacing 0.1 -via_array_dimension {3 1}
set_pg_via_master_rule via3_rule -contact_code VIA34_1cut -cut_spacing 0.1 -via_array_dimension {3 1}
set_pg_via_master_rule via4_rule -contact_code VIA45_1cut -cut_spacing 0.1 -via_array_dimension {3 1}
create_pg_vias -from_layers M5 -to_layers M1 -nets {vdd vss} -within_bbox [get_attribute [current_block] bbox] -via_masters {via1_rule via2_rule  via3_rule via4_rule}
puts "USER_INFO: ####----------------------End of PG insertion--------------------------------####"

#Via over macro pins
set_pg_via_master_rule via4_macro_rule -contact_code VIA45_1cut -cut_spacing 0.1 -via_array_dimension {3 2}
create_pg_vias -from_types macro_pin -from_layers M4 -to_types stripe -to_layers M5 -nets {vdd vss} -via_masters {via4_macro_rule}
