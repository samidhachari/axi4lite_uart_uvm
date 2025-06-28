// uart_txn.sv content placeholder`ifndef UART_TXN_SV
`define UART_TXN_SV

class uart_txn extends uvm_sequence_item;

  rand bit [3:0] addr;
  rand bit [31:0] data;
  rand bit write; // 1 = write, 0 = read

  bit [31:0] expected_data;
  bit expect_valid;

  `uvm_object_utils(uart_txn)

  function new(string name = "uart_txn");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("UART_TXN: %s to 0x%0h data=0x%0h", 
      write ? "WRITE" : "READ", addr, data);
  endfunction

endclass

`endif
