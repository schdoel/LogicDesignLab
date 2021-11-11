`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [1:0] sel;
output clk1_2; //01
output clk1_4; //0123
output clk1_8; //012345678
output clk1_3; //012
output reg dclk;

reg [3:0] c2, c4, c8, c3; //count

always @(posedge clk) begin
    if(rst_n == 1'b0) begin
        c3 <= 4'b0;
        c2 <= 4'b0;
        c4 <= 4'b0;
        c8 <= 4'b0;      
    end
    else begin
        //count 3 (2)
        if(c3 == 4'd2) c3 <= 4'b0;
        else c3 <= c3 + 4'b1;
        //count 2 (1)
        if(c2 == 4'd1) c2 <= 4'b0;
        else c2 <= c2 + 4'b1;
        //count 4 (3)
        if(c4 == 4'd3) c4 <= 4'b0;
        else c4 <= c4 + 4'b1;
        //count 8 (7)
        if(c8 == 4'd7) c8 <= 4'b0;
        else c8 <= c8 + 4'b1;
    end
end

assign clk1_3 = (c3 == 4'd0 ? 1'b1 : 1'b0);
assign clk1_2 = (c2 == 4'd0 ? 1'b1 : 1'b0);
assign clk1_4 = (c4 == 4'd0 ? 1'b1 : 1'b0);
assign clk1_8 = (c8 == 4'd0 ? 1'b1 : 1'b0);

//MUX
always @(*) begin
    case (sel)
        2'b00: dclk = clk1_3;
        2'b01: dclk = clk1_2;
        2'b10: dclk = clk1_4;
        2'b11: dclk = clk1_8;
        default: dclk = 4'b0;
    endcase
end

endmodule