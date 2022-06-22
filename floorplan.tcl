###Floorplan stage

##Assign routing directions for metal layers
set_attribute [get_layers {M1 M3 M5 M7 M9}] routing_direction vertical
set_attribute [get_layers {M2 M4 M6 M8 AP}] routing_direction horizontal


initialize_floorplan -control_type die -core_offset "1.48 2.2 1.48 2.2" -boundary {{0 0} {1380 710}} -flip_first_row true
#read_def ./scripts/uDPR.release_9_9_2021.DEF
#read_def ./scripts/Macro_placemnet_1309.def
##Extra DFT ports
#read_def ./scripts/dft_ports.def

##
#read_def ./scripts/rp_top_top.scandef

##Keepout_margin
create_keepout_margin -type hard -outer {1.4 1.2 1.4 1.2} [get_cells -physical_context -filter "is_hard_macro==true"]


##Placement blockages
create_placement_blockage -type hard -boundary {{1003.04 20.1} {1380 321.8}} -name PB_HARD1

##Soft blockages in channel regions
create_placement_blockage -type soft -boundary {{1180 386.2} {1220 709}} -name PB_SOFT1
create_placement_blockage -type soft -boundary {{610 1.2} {1380 20.1}} -name PB_SOFT2
create_placement_blockage -type soft -boundary {{980 1.2} {1008 119.5}} -name PB_SOFT3

set_size_only [get_cells -physical_context {*dft* *tessent* *MEM_interface_inst* *DFT*}]

save_block -as macro_placed
##boundary cells
create_boundary_cells -left_boundary_cell tcbn28hpcplusbwp30p140hvt/BOUNDARY_LEFTBWP30P140 -right_boundary_cell tcbn28hpcplusbwp30p140hvt/BOUNDARY_RIGHTBWP30P140 -prefix ENDCAP

if {0} {
create_net -power v08
create_net -ground vss
create_port -port_type power -direction in v08
create_port -port_type ground -direction in vss
}

connect_pg_net -net v08 [get_pins -physical_context */VDD]
connect_pg_net -net vss [get_pins -physical_context */VSS]

source ./scripts/pg.tcl
save_block -as PG_inserted
##Tap cells
create_tap_cells -lib_cell TAPCELLBWP30P140 -distance 30 -no_1x -pattern stagger -prefix Welltap -skip_fixed_cells

connect_pg_net -net v08 [get_pins -physical_context */VDD]
connect_pg_net -net vss [get_pins -physical_context */VSS]

save_block -as FP_done
check_pg_drc
check_pg_missing_vias
check_pg_connectivity
