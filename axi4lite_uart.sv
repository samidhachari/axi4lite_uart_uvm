// axi4lite_uart.sv 


module axi4lite_uart #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4
)(
    input  logic                  ACLK,
    input  logic                  ARESETN,

    // AXI4-Lite interface
    input  logic [ADDR_WIDTH-1:0] AWADDR,
    input  logic                  AWVALID,
    output logic                  AWREADY,

    input  logic [DATA_WIDTH-1:0] WDATA,
    input  logic [3:0]            WSTRB,
    input  logic                  WVALID,
    output logic                  WREADY,

    output logic [1:0]            BRESP,
    output logic                  BVALID,
    input  logic                  BREADY,

    input  logic [ADDR_WIDTH-1:0] ARADDR,
    input  logic                  ARVALID,
    output logic                  ARREADY,

    output logic [DATA_WIDTH-1:0] RDATA,
    output logic [1:0]            RRESP,
    output logic                  RVALID,
    input  logic                  RREADY,

    // UART Interface
    output logic                  uart_tx,
    input  logic                  uart_rx
);

    // Register addresses
    localparam REG_TXDATA = 4'h0;
    localparam REG_RXDATA = 4'h4;
    localparam REG_STATUS = 4'h8;

    // Internal registers
    logic [7:0] tx_data_reg;
    logic       tx_start_reg;
    logic       tx_busy;

    logic [7:0] rx_data_reg;
    logic       rx_valid;

    // AXI Write FSM
    typedef enum logic [1:0] {IDLE, WRITE, RESP} axi_wr_state_t;
    axi_wr_state_t wr_state;

    // AXI Read FSM
    typedef enum logic [1:0] {RIDLE, READ, RRESP} axi_rd_state_t;
    axi_rd_state_t rd_state;

    // AXI write logic
    always_ff @(posedge ACLK or negedge ARESETN) begin
        if (!ARESETN) begin
            wr_state <= IDLE;
            AWREADY <= 0;
            WREADY <= 0;
            BVALID <= 0;
            BRESP  <= 2'b00;
            tx_data_reg <= 8'd0;
            tx_start_reg <= 0;
        end else begin
            case (wr_state)
                IDLE: begin
                    if (AWVALID) begin
                        AWREADY <= 1;
                        wr_state <= WRITE;
                    end
                end
                WRITE: begin
                    if (WVALID) begin
                        WREADY <= 1;
                        AWREADY <= 0;

                        case (AWADDR)
                            REG_TXDATA: begin
                                tx_data_reg <= WDATA[7:0];
                                tx_start_reg <= 1;
                            end
                        endcase

                        wr_state <= RESP;
                    end
                end
                RESP: begin
                    WREADY <= 0;
                    BVALID <= 1;
                    if (BREADY) begin
                        BVALID <= 0;
                        wr_state <= IDLE;
                        tx_start_reg <= 0;
                    end
                end
            endcase
        end
    end

    // AXI read logic
    always_ff @(posedge ACLK or negedge ARESETN) begin
        if (!ARESETN) begin
            rd_state <= RIDLE;
            ARREADY <= 0;
            RVALID <= 0;
            RRESP <= 2'b00;
            RDATA <= 0;
        end else begin
            case (rd_state)
                RIDLE: begin
                    if (ARVALID) begin
                        ARREADY <= 1;
                        rd_state <= READ;
                    end
                end
                READ: begin
                    ARREADY <= 0;
                    case (ARADDR)
                        REG_RXDATA: RDATA <= {24'd0, rx_data_reg};
                        REG_STATUS: RDATA <= {30'd0, tx_busy, rx_valid};
                        default:    RDATA <= 32'hDEADBEEF;
                    endcase
                    RVALID <= 1;
                    rd_state <= RRESP;
                end
                RRESP: begin
                    if (RREADY) begin
                        RVALID <= 0;
                        rd_state <= RIDLE;
                    end
                end
            endcase
        end
    end

    // TODO: Connect tx_data_reg, tx_start_reg, rx_data_reg, rx_valid to actual UART TX/RX modules

endmodule

