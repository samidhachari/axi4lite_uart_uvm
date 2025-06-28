// uart_test.sv content placeholder
`ifndef UART_TEST_SV
`define UART_TEST_SV

class uart_test extends uvm_test;
  `uvm_component_utils(uart_test)

  uart_env         env;
  uart_sequence    seq;

  function new(string name = "uart_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = uart_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    seq = uart_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);

    phase.drop_objection(this);
  endtask

endclass

`endif
