// uart_tx.sv 

module uart_tx #(
    parameter CLOCK_FREQ = 50000000,  // 50 MHz
    parameter BAUD_RATE  = 9600
)(
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [7:0] data_in,
    output logic tx,
    output logic busy
);

    localparam integer CLKS_PER_BIT = CLOCK_FREQ / BAUD_RATE;
    localparam integer BIT_CNT = 10;  // 1 start + 8 data + 1 stop

    logic [$clog2(CLKS_PER_BIT)-1:0] clk_cnt;
    logic [3:0] bit_index;
    logic [9:0] tx_shift_reg;
    logic sending;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_cnt      <= 0;
            bit_index    <= 0;
            tx_shift_reg <= 10'b1111111111;
            tx           <= 1'b1;
            busy         <= 0;
            sending      <= 0;
        end else begin
            if (start && !busy) begin
                // Frame = start(0) + data + stop(1)
                tx_shift_reg <= {1'b1, data_in, 1'b0};
                bit_index    <= 0;
                clk_cnt      <= 0;
                sending      <= 1;
                busy         <= 1;
            end else if (sending) begin
                if (clk_cnt == CLKS_PER_BIT - 1) begin
                    clk_cnt <= 0;
                    tx      <= tx_shift_reg[0];
                    tx_shift_reg <= {1'b1, tx_shift_reg[9:1]};
                    bit_index <= bit_index + 1;
                    if (bit_index == BIT_CNT - 1) begin
                        sending <= 0;
                        busy    <= 0;
                        tx      <= 1;
                    end
                end else begin
                    clk_cnt <= clk_cnt + 1;
                end
            end
        end
    end

endmodule

