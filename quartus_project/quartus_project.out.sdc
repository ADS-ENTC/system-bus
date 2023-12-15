## Generated SDC file "quartus_project.out.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

## DATE    "Fri Dec 15 17:22:20 2023"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 26.000 -waveform { 0.000 13.000 } [get_ports {clk}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}] -setup 1.000  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}] -setup 1.000  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}] -setup 1.000  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}] -setup 1.000  


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[4]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[5]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[6]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[7]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[8]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[9]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[10]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[11]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[12]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[13]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[14]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {addr[15]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {keysn[0]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {keysn[1]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {keysn[2]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {keysn[3]}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m_ready_rx}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m_sig_rx}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s_ready_rx}]
set_input_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s_sig_rx}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex0[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex1[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex2[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[0]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[1]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[2]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[3]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[4]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[5]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {hex3[6]}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m1_ack_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m1_master_ready_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m1_master_valid_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m1_mode_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m1_slave_ready_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m1_slave_valid_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m2_mode_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m_ready_tx}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {m_sig_tx}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {rstn_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s1_master_ready_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s1_master_valid_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s1_slave_ready_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s1_slave_valid_led}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s_ready_tx}]
set_output_delay -add_delay  -clock [get_clocks {clk}]  8.000 [get_ports {s_sig_tx}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

