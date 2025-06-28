// axi_uart_tb.sv content placeholder
`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

module axi_uart_tb;

    // Clock & Reset
    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever #10 clk = ~clk; // 50 MHz
    end

    initial begin
        rst_n = 0;
        #100 rst_n = 1;
    end

    // AXI Interface Instantiation
    axi_if axi_bus (
        .ACLK(clk),
        .ARESETN(rst_n)
    );

    // DUT Instantiation
    axi4lite_uart dut (
        .ACLK        (clk),
        .ARESETN     (rst_n),

        .AWADDR      (axi_bus.AWADDR),
        .AWVALID     (axi_bus.AWVALID),
        .AWREADY     (axi_bus.AWREADY),
        .WDATA       (axi_bus.WDATA),
        .WSTRB       (axi_bus.WSTRB),
        .WVALID      (axi_bus.WVALID),
        .WREADY      (axi_bus.WREADY),
        .BRESP       (axi_bus.BRESP),
        .BVALID      (axi_bus.BVALID),
        .BREADY      (axi_bus.BREADY),

        .ARADDR      (axi_bus.ARADDR),
        .ARVALID     (axi_bus.ARVALID),
        .ARREADY     (axi_bus.ARREADY),
        .RDATA       (axi_bus.RDATA),
        .RRESP       (axi_bus.RRESP),
        .RVALID      (axi_bus.RVALID),
        .RREADY      (axi_bus.RREADY),

        .uart_tx     (axi_bus.uart_tx),
        .uart_rx     (axi_bus.uart_rx)
    );

    // Bind interface to UVM
    initial begin
        uvm_config_db#(virtual axi_if)::set(null, "*", "vif", axi_bus);
        run_test("uart_test");
    end

    // Optional: Dump waveform
    initial begin
        $dumpfile("axi_uart.vcd");
        $dumpvars(0, axi_uart_tb);
    end

endmodule
