`timescale 1ns/1ps
module spi_master_tb;
    reg        clk, rst, start;
    reg  [7:0] data_in;
    wire       miso, sclk, mosi, cs, done;
    wire [7:0] data_out;
    reg  [7:0] slave_data;

assign miso = slave_data[7];

always @(negedge sclk) begin
        if (!cs) slave_data <= {slave_data[6:0], 1'b0};
    end

    spi_master_mode0 uut(
        .clk(clk),.rst(rst),.start(start),
        .data_in(data_in),.miso(miso),
        .data_out(data_out),.sclk(sclk),
        .mosi(mosi),.cs(cs),.done(done)
    );

    initial clk=0;
    always #5 clk=~clk;
    initial begin
        $dumpfile("spi_master.vcd");
        $dumpvars(0, spi_master_tb);
        rst=1; start=0;
        data_in=8'hCC;
        slave_data=8'h55;
repeat(4) @(posedge clk); #1; rst=0;
        repeat(2) @(posedge clk); #1;
        start=1; @(posedge clk); #1; start=0;
        @(posedge done); @(posedge clk); #1;
        if (data_out===8'h55) 
          $display("T1 PASS: sent=CC recv=55");
        else 
          $display("T1 FAIL: sent=CC recv=%h exp=55", data_out);
        #20;
        slave_data=8'hA3;
        data_in=8'h5A;
        repeat(2) @(posedge clk); #1;
        start=1; @(posedge clk); #1; start=0;
        @(posedge done); @(posedge clk); #1;
        if (data_out===8'hA3)
          $display("T2 PASS: sent=5A recv=A3");
        else 
          $display("T2 FAIL: sent=5A recv=%h exp=A3", data_out);
        #50; $finish;
    end
endmodule
