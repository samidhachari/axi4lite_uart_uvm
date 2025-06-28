// uart_coverage.sv content placeholder
`ifndef UART_COVERAGE_SV
`define UART_COVERAGE_SV

class uart_coverage extends uvm_subscriber #(uart_txn);
  `uvm_component_utils(uart_coverage)

  covergroup uart_cov;
    option.per_instance = 1;

    addr_cp: coverpoint uart_txn.addr;
    data_cp: coverpoint uart_txn.data {
      bins ascii_range[] = {[8'h41:8'h5A]}; // A–Z
    }
    rw_cp: coverpoint uart_txn.write {
      bins write = {1};
      bins read  = {0};
    }
  endgroup

  function new(string name = "uart_coverage", uvm_component parent = null);
    super.new(name, parent);
    uart_cov = new();
  endfunction

  function void write(uart_txn t);
    uart_cov.sample();
  endfunction

endclass

`endif
