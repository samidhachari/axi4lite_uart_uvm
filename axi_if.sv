// axi_if.sv content placeholder
interface axi_if #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 32
) (
    input logic ACLK,
    input logic ARESETN
);

    // Write Address Channel
    logic [ADDR_WIDTH-1:0] AWADDR;
    logic                  AWVALID;
    logic                  AWREADY;

    // Write Data Channel
    logic [DATA_WIDTH-1:0] WDATA;
    logic [3:0]            WSTRB;
    logic                  WVALID;
    logic                  WREADY;

    // Write Response Channel
    logic [1:0]            BRESP;
    logic                  BVALID;
    logic                  BREADY;

    // Read Address Channel
    logic [ADDR_WIDTH-1:0] ARADDR;
    logic                  ARVALID;
    logic                  ARREADY;

    // Read Data Channel
    logic [DATA_WIDTH-1:0] RDATA;
    logic [1:0]            RRESP;
    logic                  RVALID;
    logic                  RREADY;

    // UART IO (can optionally add here)
    logic uart_tx;
    logic uart_rx;

endinterface
