module top(
    input PCLK,
    input PRESETn,
    input tx_start,
    input [7:0] tx_data,
    output tx_done,
    output [7:0] rx_data,
    output rx_done);

wire tx_line;

uart_tx TX(
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx_line),
    .tx_done(tx_done));

uart_rx RX(
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .rx(tx_line),
    .rx_data(rx_data),
    .rx_done(rx_done));
endmodule
