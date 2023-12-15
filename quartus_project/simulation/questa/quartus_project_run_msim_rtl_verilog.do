transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/seg.v}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/quartus_project {/home/dakshina/Projects/ADS/system-bus/quartus_project/master_1_ram.v}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/quartus_project {/home/dakshina/Projects/ADS/system-bus/quartus_project/slave_1_ram.v}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/quartus_project {/home/dakshina/Projects/ADS/system-bus/quartus_project/slave_2_ram.v}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/quartus_project {/home/dakshina/Projects/ADS/system-bus/quartus_project/slave_3_ram.v}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/quartus_project {/home/dakshina/Projects/ADS/system-bus/quartus_project/master_2_ram.v}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/uart_tx.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/uart_rx.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/slave_bus_bridge.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/demo.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/slave_port_v2.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/arbiter.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/master_port.sv}
vlog -sv -work work +incdir+/home/dakshina/Projects/ADS/system-bus/rtl {/home/dakshina/Projects/ADS/system-bus/rtl/top.sv}

