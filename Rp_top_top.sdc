set ck_period 2.5

create_clock -period $ck_period -name clk [get_ports clk]
##Deva
create_clock -period $ck_period -name spi_clk [get_ports spi_clk]

set_clock_groups -group {clk} -group {spi_clk} -asynchronous -name func_scan1

set_driving_cell -lib_cell BUFFD4BWP30P140HVT [remove_from_collection [all_inputs] [get_ports {clk spi_clk}]]

#set_input_transition 0.150 [get_ports clk]

set_input_delay [expr 0.6*$ck_period] [remove_from_collection [all_inputs] {clk spi_clk}] -clock clk
set_input_delay [expr 0.6*$ck_period] [get_ports {spi_mosi}] -clock spi_clk

set_output_delay [expr 0.6*$ck_period] [all_outputs] -clock clk
set_output_delay [expr 0.6*$ck_period] [get_ports {spi_miso}] -clock spi_clk

#set_max_transition 0.250 -clock_path [get_clocks] 
#set_max_transition 0.300 -data_path [get_clocks]

#set_clock_transition -max -rise 0.25 [get_clocks clk]
#set_clock_transition -max -fall 0.25 [get_clocks clk]
#set_clock_transition -min -rise 0.25 [get_clocks clk]
#set_clock_transition -min -fall 0.25 [get_clocks clk]


#set_clock_uncertainty -setup [expr 0.25*$ck_period] [get_clocks clk]
set_clock_uncertainty -setup [expr 0.1*$ck_period] [get_clocks clk]
#set_clock_uncertainty -hold 0.05 [get_clocks clk]
set_clock_uncertainty -hold 0.07 [get_clocks clk]

set port_load [expr 8 * 0.006212]
set_load $port_load [all_outputs]

set_max_delay 28 -from [all_inputs] -to [all_outputs]

##Max delays from design team
source ./scripts/IO_constraints.tcl
