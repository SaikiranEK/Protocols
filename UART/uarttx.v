module uart_tx(
    input PCLK,
    input PRESETn,
    input tx_start,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_done);
  
reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        state <= IDLE;
        tx <= 1;
        tx_done <= 0;
        bit_count <= 0;
    end
    else
    begin
        case(state)
        IDLE:
        begin
            tx <= 1;
            tx_done <= 0;
            if(tx_start)
            begin
                shift_reg <= tx_data;
                state <= START;
            end
        end

        START:
        begin
            tx <= 0;
            bit_count <= 0;
            state <= DATA;
        end

        DATA:
        begin
            tx <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
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
            tx <= 1;
            tx_done <= 1;
            state <= IDLE;
        end
        endcase
    end
end

endmodule
