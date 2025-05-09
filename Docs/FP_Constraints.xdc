create_clock -name clk -period 50.000 -waveform {0.000 25.000}
set_input_delay -clock clk 0 [get_ports add_or_sub]
set_input_delay -clock clk 0 [get_ports operand_1]
set_input_delay -clock clk 0 [get_ports operand_2]
set_output_delay -clock clk 0 [get_ports result]