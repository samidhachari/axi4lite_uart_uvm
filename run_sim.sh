// run_sim.sh content placeholder
#!/bin/bash
# Simulate your AXI UART UVM testbench using ModelSim or Icarus

vlog +acc \
     +incdir+./uvm_env \
     ./rtl/axi4lite_uart.sv \
     ./rtl/uart_tx.sv \
     ./rtl/uart_rx.sv \
     ./uvm_env/*.sv \
     ./tb/axi_uart_tb.sv

vsim -c work.axi_uart_tb -do "run -all; quit"

