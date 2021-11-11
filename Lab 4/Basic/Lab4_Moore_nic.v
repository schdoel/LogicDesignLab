`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [1:0] out;
output reg [2:0] state;

parameter S0 = 3'b000;
parameter S1 = 2'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [3:0] next;

always @(posedge clk)begin
    if(rst_n==1'b0) state<=S0;
    else state <=next;
end

always@(*) begin
    case (state)
    S0: begin
        next = ((in==1'b1)? S2:S1);
        out = 2'b11;
    end
    S1: begin
        next = ((in==1'b1)? S5:S4);
        out = 2'b01;
    end
    S2: begin
        next = ((in==1'b1)? S3:S1);
        out = 2'b11;
    end
    S3: begin
        next = ((in==1'b1)? S0:S1);
        out = 2'b11;
    end
    S4: begin
       next = ((in==1'b1)? S5:S4);
        out = 2'b10;
    end
    S5: begin
        next = ((in==1'b1)? S0:S3);
        out = 2'b00;
    end
    default: begin
        next = ((in==1'b1)? S2:S0);
        out = 2'b11;
    end
    endcase 
end

endmodule
