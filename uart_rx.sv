// uart_rx.sv 

module uart_rx #(
    parameter CLOCK_FREQ = 50000000,
    parameter BAUD_RATE  = 9600
)(
    input  logic clk,
    input  logic rst_n,
    input  logic rx,
    output logic [7:0] data_out,
    output logic valid
);

    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;

    logic [3:0] bit_index;
    logic [7:0] rx_shift_reg;
    logic [$clog2(CLKS_PER_BIT)-1:0] clk_cnt;
    logic receiving;
    logic [1:0] rx_sync;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_index   <= 0;
            clk_cnt     <= 0;
            rx_shift_reg <= 0;
            receiving   <= 0;
            valid       <= 0;
            rx_sync     <= 2'b11;
        end else begin
            rx_sync <= {rx_sync[0], rx};

            if (!receiving && rx_sync == 2'b10) begin
                receiving <= 1;
                clk_cnt   <= CLKS_PER_BIT / 2; // Sample at mid-bit
                bit_index <= 0;
                valid     <= 0;
            end else if (receiving) begin
                if (clk_cnt == CLKS_PER_BIT - 1) begin
                    clk_cnt <= 0;
                    if (bit_index < 8) begin
                        rx_shift_reg[bit_index] <= rx_sync[1];
                        bit_index <= bit_index + 1;
                    end else begin
                        receiving <= 0;
                        data_out <= rx_shift_reg;
                        valid <= 1;
                    end
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end else begin
                valid <= 0;
            end
        end
    end

endmodule

