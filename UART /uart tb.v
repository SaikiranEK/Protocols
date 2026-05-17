module tb;
reg PCLK;
reg PRESETn;
reg tx_start;
reg [7:0] tx_data;
wire tx_done;
wire [7:0] rx_data;
wire rx_done;

top uut(
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_done(tx_done),
    .rx_data(rx_data),
    .rx_done(rx_done));

initial
begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
end

initial
begin
    PRESETn = 0;
    #20;
    PRESETn = 1;
end

initial
begin
    tx_start = 0;
    tx_data = 8'b10110010;
    #50;
    tx_start = 1;
    #10;
    tx_start = 0;
    #3000;
    $finish;
end

initial
begin
    $monitor(
    "TIME=%0t tx=%b tx_done=%b rx_done=%b rx_data=%b",
    $time,
    uut.tx_line,
    tx_done,
    rx_done,
    rx_data);
end

initial
begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
end
endmodule
