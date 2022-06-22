foreach_in_collection  active_scen  [all_scenarios] {

     set dc_corner       [get_object_name [get_attribute [get_scenarios $active_scen] corner]]
     set constraint_mode       [get_object_name [get_attribute [get_scenarios $active_scen] mode]]
    
    puts "INFO: Applying derates for $dc_corner corner" 
    current_scenario $active_scen
    current_mode $constraint_mode
    current_corner $dc_corner
    if { $dc_corner == "ssg0p81v125c_rcw" || $dc_corner == "ssg0p81vm40c_cw"} {
    
	set derate($dc_corner,data_cell_late) 1.02
	set derate($dc_corner,data_cell_early) 0.9
	set derate($dc_corner,clock_cell_late) 1.02
	set derate($dc_corner,clock_cell_early) 0.9
	
	set derate($dc_corner,data_net_late) 1.02
	set derate($dc_corner,data_net_early) 0.9
	set derate($dc_corner,clock_net_late) 1.02
	set derate($dc_corner,clock_net_early) 0.9
    
    } elseif { $dc_corner == "ffg0p99v125c_rcb" || $dc_corner == "ffg0p99vm40c_cb"} { 

	set derate($dc_corner,data_cell_late) 1.1
	set derate($dc_corner,data_cell_early) 0.98
	set derate($dc_corner,clock_cell_late) 1.1
	set derate($dc_corner,clock_cell_early) 0.98
	
	set derate($dc_corner,data_net_late) 1.1
	set derate($dc_corner,data_net_early) 0.98
	set derate($dc_corner,clock_net_late) 1.1
	set derate($dc_corner,clock_net_early) 0.98

    } elseif { $dc_corner == "tt_25c_typ" } {

        set derate($dc_corner,data_cell_late) 1.06
        set derate($dc_corner,data_cell_early) 0.94
        set derate($dc_corner,clock_cell_late) 1.06
        set derate($dc_corner,clock_cell_early) 0.94

        set derate($dc_corner,data_net_late) 1.06
        set derate($dc_corner,data_net_early) 0.94
        set derate($dc_corner,clock_net_late) 1.06
        set derate($dc_corner,clock_net_early) 0.94
	
    } else {

    puts "ERROR : dc_corner is not recognised"

    }

set_timing_derate -late  -data  -cell_delay $derate($dc_corner,data_cell_late) -corner $dc_corner
set_timing_derate -early -data  -cell_delay $derate($dc_corner,data_cell_early) -corner $dc_corner

set_timing_derate -late  -clock -cell_delay $derate($dc_corner,clock_cell_late) -corner $dc_corner
set_timing_derate -early -clock -cell_delay $derate($dc_corner,clock_cell_early) -corner $dc_corner

set_timing_derate -late  -data  -net_delay $derate($dc_corner,data_net_late) -corner $dc_corner
set_timing_derate -early -data  -net_delay $derate($dc_corner,data_net_early) -corner $dc_corner

set_timing_derate -late  -clock -net_delay $derate($dc_corner,clock_net_late) -corner $dc_corner
set_timing_derate -early -clock -net_delay $derate($dc_corner,clock_net_early) -corner $dc_corner

report_timing_derate

}
