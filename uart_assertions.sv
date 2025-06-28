// uart_assertions.sv content placeholder
// Example: TX must be idle (1) when not busy
property tx_idle_when_not_busy;
  @(posedge clk) disable iff (!rst_n)
    (!tx_busy) |-> (uart_tx == 1'b1);
endproperty
assert property (tx_idle_when_not_busy);
