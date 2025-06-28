// uart_monitor.sv 

`ifndef UART_MONITOR_SV
`define UART_MONITOR_SV

class uart_monitor extends uvm_monitor;
  `uvm_component_utils(uart_monitor)

  virtual interface axi_if;
  uvm_analysis_port #(uart_txn) mon_ap;

  function new(string name = "uart_monitor", uvm_component parent = null);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual interface)::get(this, "", "vif", axi_if))
      `uvm_fatal("NO_VIF", "Virtual interface not set in monitor.")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      uart_txn tr;
      tr = uart_txn::type_id::create("tr");

      // Monitor reads only (RVALID/RDATA) for simplicity
      @(posedge axi_if.ACLK);
      if (axi_if.RVALID && axi_if.RREADY) begin
        tr.addr = axi_if.ARADDR;
        tr.data = axi_if.RDATA;
        tr.write = 0;
        tr.expected_data = axi_if.RDATA;
        tr.expect_valid = 1;
        `uvm_info("UART_MONITOR", $sformatf("Read: addr=%h data=%h", tr.addr, tr.data), UVM_LOW)
        mon_ap.write(tr);
      end
    end
  endtask

endclass

`endif

