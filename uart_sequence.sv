// uart_sequence.sv content placeholder
`ifndef UART_SEQUENCE_SV
`define UART_SEQUENCE_SV

class uart_sequence extends uvm_sequence #(uart_txn);
  `uvm_object_utils(uart_sequence)

  function new(string name = "uart_sequence");
    super.new(name);
  endfunction

  task body();
    uart_txn tr;

    // Write character 'H' to TX data register (0x0)
    tr = uart_txn::type_id::create("tr", this);
    tr.addr  = 4'h0;
    tr.data  = 32'h00000048; // ASCII 'H'
    tr.write = 1;
    start_item(tr);
    finish_item(tr);

    // Delay
    repeat (5) @(posedge p_sequencer.axi_if.ACLK);

    // Read STATUS register (0x8)
    tr = uart_txn::type_id::create("tr_status", this);
    tr.addr  = 4'h8;
    tr.write = 0;
    start_item(tr);
    finish_item(tr);

    `uvm_info("UART_SEQUENCE", "Completed UART sequence", UVM_MEDIUM)
  endtask

endclass

`endif

