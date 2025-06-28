// uart_driver.sv content placeholder
`ifndef UART_DRIVER_SV
`define UART_DRIVER_SV

class uart_driver extends uvm_driver #(uart_txn);
  `uvm_component_utils(uart_driver)

  virtual interface axi_if;

  function new(string name = "uart_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual interface)::get(this, "", "vif", axi_if))
      `uvm_fatal("NO_VIF", "Virtual interface not set for driver.")
  endfunction

  task run_phase(uvm_phase phase);
    uart_txn tr;
    forever begin
      seq_item_port.get_next_item(tr);

      // Simple write or read sequence
      if (tr.write) begin
        // Write Address
        axi_if.AWADDR  <= tr.addr;
        axi_if.AWVALID <= 1;
        wait (axi_if.AWREADY);
        axi_if.AWVALID <= 0;

        // Write Data
        axi_if.WDATA  <= tr.data;
        axi_if.WSTRB  <= 4'hF;
        axi_if.WVALID <= 1;
        wait (axi_if.WREADY);
        axi_if.WVALID <= 0;

        // Write Response
        axi_if.BREADY <= 1;
        wait (axi_if.BVALID);
        axi_if.BREADY <= 0;

      end else begin
        // Read Address
        axi_if.ARADDR  <= tr.addr;
        axi_if.ARVALID <= 1;
        wait (axi_if.ARREADY);
        axi_if.ARVALID <= 0;

        // Read Data
        axi_if.RREADY <= 1;
        wait (axi_if.RVALID);
        axi_if.RREADY <= 0;

        tr.expected_data = axi_if.RDATA;
        tr.expect_valid = 1;
      end

      `uvm_info("UART_DRIVER", $sformatf("Drove TXN: %s", tr.convert2string()), UVM_MEDIUM)
      seq_item_port.item_done();
    end
  endtask

endclass

`endif
