module baud_gen(
	input PCLK,
    input PRESETn,
    output reg baud_tick);

parameter BAUD_COUNT = 104;

reg [15:0] count;

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        count <= 0;
        baud_tick <= 0;
    end
    else
    begin
        if(count < BAUD_COUNT-1)
        begin
            count <= count + 1;
            baud_tick <= 0;
        end
        else
        begin
            count <= 0;
            baud_tick <= 1;
        end
    end
end
endmodule
