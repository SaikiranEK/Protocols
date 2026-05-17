
`timescale 1ns/1ps
module spi_master_mode0 (
    input            clk, rst, start,
    input      [7:0] data_in,
    input            miso,
    output reg [7:0] data_out,
    output reg       sclk, mosi, cs, done
);

parameter IDLE=0, LOAD=1, TRANSFER=2, DONE=3;

reg [1:0] state;
reg [2:0] bit_cnt;
reg [7:0] shift_reg, recv_reg;
reg       clk_div;
reg       first_cycle;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state      <= IDLE;
        cs         <= 1;
        done       <= 0;
        mosi       <= 0;
        sclk       <= 0;
        clk_div    <= 0;
        data_out   <= 0;
        bit_cnt    <= 7;
        shift_reg  <= 0;
        recv_reg   <= 0;
        first_cycle<= 0;
    end else begin
        case(state)


        IDLE: begin
            cs      <= 1;
            done    <= 0;
            mosi    <= 0;
            sclk    <= 0;
            clk_div <= 0;

            if(start)
                state <= LOAD;
        end
LOAD: begin
            cs         <= 0;
            shift_reg  <= data_in;
            bit_cnt    <= 7;
            sclk       <= 0;
            clk_div    <= 0;
            first_cycle<= 1; 
            state      <= TRANSFER;
        end
TRANSFER: begin
            clk_div <= ~clk_div;

            if (clk_div == 0) begin
                sclk <= 0;

 if (!first_cycle) begin
                    mosi <= shift_reg[bit_cnt];
                end 
              else begin
                    first_cycle <= 0;
                end
            end 
  else begin
                sclk <= 1;
                recv_reg[bit_cnt] <= miso;

                if (bit_cnt == 0)
                    state <= DONE;
                else
                    bit_cnt <= bit_cnt - 1;
            end
        end
DONE: begin
            cs       <= 1;
            sclk     <= 0;
            mosi     <= 0;
            data_out <= recv_reg;
            done     <= 1;
            state    <= IDLE;
        end

        endcase
    end
end

endmodule
