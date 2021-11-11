`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg out;
output reg [2:0] state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [2:0] mealy_state, next_state;

always @(posedge clk)begin
    if(rst_n==1'b0) state<=S0;
    else state <=next_state;
end

always@(*)begin
    case(mealy_state)
    S0:begin
        next_state = ((in==1'b1)?S2:S0);
        out = ((in==1'b1)?1'b1:1'b0);
    end
    S1:begin
        next_state = ((in==1'b1)?S4:S0);
        out = 1'b1;
    end
    S2:begin
        next_state = ((in==1'b1)?S1:S5);
        out = ((in==1'b1)?1'b0:1'b1);
    end
    S3:begin
        next_state = ((in==1'b1)?S2:S3);
        out = ((in==1'b1)?1'b0:1'b1);
    end
    S4:begin
        next_state = ((in==1'b1)?S4:S2);
        out = ((in==1'b1)?1'b0:1'b1);
    end
    S5:begin
        next_state = ((in==1'b1)?S4:S3);
        out = 1'b0;
    end
    default: begin
        if(in==1'b0) begin
            next_state = S0;
            out = 1'b1;
        end
        else begin
            next_state = S1;
            out = 1'b0;
        end
    end
    endcase

end
endmodule
