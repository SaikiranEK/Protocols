module slave(input PCLK,
             input PRESETn,
             input PSEL,
             input PENABLE,
             input PWRITE,
             input [7:0]PADDR,
             input [31:0]PWDATA,
             output reg [31:0]PRDATA,
             output reg PREADY);
  reg[31:0] mem;
  reg[1:0] wait_count;
  
  always@(posedge PCLK or negedge PRESETn) begin
    if(!PRESETn) begin
      mem<=0;
      PREADY<=0;
      wait_count<=0;
    end
    else begin
      if(PSEL && PENABLE) begin
        if(wait_count<=2) begin
          wait_count<=wait_count+1;
          PREADY<=0;
        end
        else begin
          PREADY<=1;
          if(PWRITE)
            mem<=PWDATA;
          else
            PRDATA<=mem;
        end
      end
    else begin
      wait_count<=0;
      PREADY<=0;
    end
    end
  end
endmodule
