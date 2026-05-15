module master(input PCLK,
              input PRESETn,
              input PREADY,
              input [31:0]PRDATA,
              output reg PSEL,
              output reg PENABLE,
              output reg PWRITE,
              output reg [7:0] PADDR,
              output reg [31:0]PWDATA);
  reg [1:0]state;
  reg transaction;
  parameter IDLE=2'b00;
  parameter SETUP=2'b01;
  parameter ACCESS=2'b10;
  
  always@(posedge PCLK or negedge PRESETn) begin
    if(!PRESETn) begin
      state<=IDLE;
      PSEL<=0;
      PENABLE<=0;
      PWRITE<=0;
      transaction<=0;
    end
    else begin
      case(state)
        IDLE:
         begin
        PSEL<=1;
        PENABLE<=0;
        if(transaction == 0) begin
          PWRITE<=1;
          PADDR<=8'h04;
          PWDATA<=32'h12345678;
        end
        else begin
          PWRITE<=0;
          PADDR<=8'h04;
        end
        state<=SETUP;
        end
        SETUP:  
        begin
            PENABLE<=1;
            state<=ACCESS;
          end
        ACCESS:
        begin
          if(PREADY)
            begin
              if(PWRITE==0)
                PSEL<=0;
              PENABLE<=0;
              transaction=transaction+1;
              state<=IDLE;
            end
        end
      endcase
    end
  end
endmodule
