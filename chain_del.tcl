proc trace_buff {args} {
if {[lindex $args 0] != ""} { set sp [lindex $args 0]} else {puts "please mention startpoint for tracing"}
if {[lindex $args 1] != ""} { set ep [lindex $args 1]} else {puts "please mention endpoint for tracing"}

set fanout_insts [get_pins -of_objects [remove_from_collection [remove_from_collection [all_fanout -from $sp -to $ep ] $sp ] $ep ] -filter "direction==out"]
set inv_c [sizeof_collection [get_cells -of_objects $fanout_insts -filter "is_inverter==true"]]
set buf_c [sizeof_collection [get_cells -of_objects $fanout_insts -filter "is_buffer==true || ref_name =~ *_DEL_*"]]
set comb_c [sizeof_collection [get_cells -of_objects $fanout_insts -filter "is_combinational==true && ref_name !~ *BUF* && ref_name !~ *INV* && ref_name !~ *_DEL_*"]]
puts "From sp to ep found : \n Buff : $buf_c\tInv : $inv_c \t comb_cells : $comb_c"
set buff "" ; set inv "" ; set temp_inv ""
	foreach_in_collection i $fanout_insts {
		set base_c [get_property $i ref_name]
		set fanout [sizeof_collection [get_pins -of_objects $i -filter "direction==out"]] 
		if {$fanout > 1 } {
			puts "found cell fanout > 1"
			continue
		} else {
			if {[regexp "INV" $base_c]} {
				if {$temp_inv eq ""} {
					set temp_inv $i  ; # store first inverter
				} else {
					lappend inv [lappend temp_inv $i] ; #found second inverter in a row — store both
					puts "Found back-to-back inverters: $temp_inv and $cell"
					set temp_inv ""
				}
			} elseif {[regexp "BUF" $base_c] || [regexp "_DEL_" $base_c])} {
				lappend buff $i
				# Reset temp_inv since inverter chain is broken
			} elseif {![regexp "BUF" $base_c] && ![regexp "INV" $base_c] && ![regexp "_DEL_" $base_c]} {
				puts "found comb cell : $i"
				set temp_inv ""
			} else {
			
			}
		}
	}
	puts "Buffers:\t$buff"
	puts "Inverters:\t$inv"
}
