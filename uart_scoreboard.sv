// uart_scoreboard.sv content placeholder
`ifndef UART_SCOREBOARD_SV
`define UART_SCOREBOARD_SV

class uart_scoreboard extends uvm_component;
  `uvm_component_utils(uart_scoreboard)

  uvm_analysis_imp #(uart_txn, uart_scoreboard) mon_imp;

  queue #(uart_txn) expected_q;

  function new(string name = "uart_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    mon_imp = new("mon_imp", this);
    expected_q = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void write(uart_txn tr);
    // Assume that every read has expected value loaded from driver
    uart_txn exp_tr;
    if (!expected_q.empty()) begin
      exp_tr = expected_q.pop_front();
      if (exp_tr.expect_valid && (exp_tr.expected_data !== tr.expected_data)) begin
        `uvm_error("UART_SCB", $sformatf(
          "Mismatch! Expected: %h, Got: %h", exp_tr.expected_data, tr.expected_data))
      end else begin
        `uvm_info("UART_SCB", $sformatf("PASS: Read %h matches expected.", tr.expected_data), UVM_LOW)
      end
    end else begin
      `uvm_warning("UART_SCB", "Unexpected transaction received in scoreboard.")
    end
  endfunction

  function void expect(uart_txn tr);
    expected_q.push_back(tr);
  endfunction

endclass

`endif

