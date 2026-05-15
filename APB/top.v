module top(
    input PCLK,
    input PRESETn

);
wire PSEL;
wire PENABLE;
wire PWRITE;
wire [7:0] PADDR;
wire [31:0] PWDATA;
wire [31:0] PRDATA;
wire PREADY;
master M1(
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PREADY(PREADY),
    .PRDATA(PRDATA),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA));
  
slave S1(
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PREADY(PREADY));
endmodule
