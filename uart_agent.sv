// uart_agent.sv 

`ifndef UART_AGENT_SV
`define UART_AGENT_SV

class uart_agent extends uvm_agent;
  `uvm_component_utils(uart_agent)

  uart_sequencer   sequencer;
  uart_driver      driver;
  uart_monitor     monitor;

  function new(string name = "uart_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sequencer = uart_sequencer::type_id::create("sequencer", this);
    driver    = uart_driver::type_id::create("driver", this);
    monitor   = uart_monitor::type_id::create("monitor", this);

    uvm_config_db#(virtual interface)::set(this, "driver", "vif", 
      axi_if);
    uvm_config_db#(virtual interface)::set(this, "monitor", "vif", 
      axi_if);
  endfunction

  function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass

`endif

