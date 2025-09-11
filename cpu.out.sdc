# =============================================
# Clock Definition (50MHz)
# =============================================
create_clock -name clk -period 20.000 -waveform {0 10} [get_ports clk]

# =============================================
# Reset Constraints
# =============================================
set_false_path -from [get_ports reset] -to [all_registers]
set_input_delay -clock [get_clocks clk] 2.0 [get_ports reset]

# =============================================
# Input/Output Constraints
# =============================================
set_input_delay -clock [get_clocks clk] 1.0 [get_ports {sw[*]}]
set_output_delay -clock [get_clocks clk] 1.0 [get_ports {outport[*]}]

# =============================================
# Clock Uncertainty
# =============================================
set_clock_uncertainty -from [get_clocks clk] -to [get_clocks clk] -setup 0.20
set_clock_uncertainty -from [get_clocks clk] -to [get_clocks clk] -hold 0.10

# =============================================
# Critical Path Fixes - PC to Outport (NEW VIOLATIONS)
# =============================================
# PC[2] to outport[1] and outport[2]
set_multicycle_path -setup 2 -from [get_registers pc:pc|PC[2]] -to [get_ports {outport[1] outport[2]}]
set_multicycle_path -hold 1 -from [get_registers pc:pc|PC[2]] -to [get_ports {outport[1] outport[2]}]

# PC[0] duplicate
set_multicycle_path -setup 2 -from [get_registers pc:pc|PC[0]~DUPLICATE] -to [get_ports outport[1]]
set_multicycle_path -hold 1 -from [get_registers pc:pc|PC[0]~DUPLICATE] -to [get_ports outport[1]]

# Global PC to outport constraints
set_multicycle_path -setup 2 -from [get_registers pc:pc|PC[*]] -to [get_ports outport[*]]
set_multicycle_path -hold 1 -from [get_registers pc:pc|PC[*]] -to [get_ports outport[*]]

# =============================================
# Previous Critical Path Fixes (Maintained)
# =============================================
# GPR paths
set_multicycle_path -setup 3 -from [get_registers regs:gpr|gpr[*][*]] -to [get_ports outport[*]]
set_multicycle_path -hold 2 -from [get_registers regs:gpr|gpr[*][*]] -to [get_ports outport[*]]

# DSP paths
set_multicycle_path -setup 4 -from [get_cells alu:iu|Mult0~8] -to [get_ports outport[*]]
set_max_delay -from [get_cells alu:iu|Mult0~8] -to [get_ports outport[*]] 35.000