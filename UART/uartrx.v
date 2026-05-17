module uart_rx(
    input PCLK,
    input PRESETn,
    input rx,
    output reg [7:0] rx_data,
    output reg rx_done);
  
reg [2:0] state;
reg [2:0] bit_count;
reg [7:0] shift_reg;

parameter IDLE  = 3'b000;
parameter START = 3'b001;
parameter DATA  = 3'b010;
parameter STOP  = 3'b011;
parameter DONE  = 3'b100;
  
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        state <= IDLE;
        rx_done <= 0;
        bit_count <= 0;
        rx_data <= 0;
    end
    else
    begin
        case(state)
        IDLE:
        begin
            rx_done <= 0;
            if(rx == 0)
            begin
                state <= START;
            end
        end
          
        START:
        begin
            if(rx == 0)
            begin
                bit_count <= 0;
                state <= DATA;
            end
            else
            begin
                state <= IDLE;
            end
        end
          
        DATA:
        begin
            shift_reg[bit_count] <= rx;
            if(bit_count < 7)
            begin
                bit_count <= bit_count + 1;
            end
            else
            begin
                bit_count <= 0;
                state <= STOP;
            end
        end

        STOP:
        begin
            if(rx == 1)
            begin
                rx_data <= shift_reg;
                state <= DONE;
            end
            else
            begin
                state <= IDLE;
            end
        end
          
        DONE:
        begin
            rx_done <= 1;
            state <= IDLE;
        end
        endcase
    end
end
endmodule
