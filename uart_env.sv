// uart_env.sv content placeholder
`ifndef UART_ENV_SV
`define UART_ENV_SV

class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  uart_agent       agent;
  uart_scoreboard  scoreboard;

  function new(string name = "uart_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent      = uart_agent::type_id::create("agent", this);
    scoreboard = uart_scoreboard::type_id::create("scoreboard", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    agent.monitor.mon_ap.connect(scoreboard.mon_imp);
  endfunction

endclass

`endif
