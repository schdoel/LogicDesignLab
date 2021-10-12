module Ripple_Carry_Adder_t(a, b, cin, cout, sum);
    reg [7:0] a = 8'b0;
    reg [7:0] b = 8'b0;
    reg cin = 1'b0;
    wire cout;
    wire [7:0] sum;

    Ripple_Carry_Adder rca_i (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );

    initial begin
        #10 a=8'b00000001; b=8'b00000001; cin=1'b0; //sum=b00000010
        #10 a=8'b00011011; b=8'b11010111; cin=1'b0; //sum b11110010
        #10 a=9'b01111011; b=8'b01111011; cin=1'b1; //sum 01001111, overflow

        #10 a=8'b00001000; b=8'b00000001; cin=1'b1;
        #10 a=8'b00000007; b=8'b00000001; cin=1'b0;
        #10 a=8'b10011000; b=8'b10000001; cin=1'b1;
        #10 a=8'b10101010; b=8'b01000001; cin=1'b0;
        #10 a=8'b10001000; b=8'b00100001; cin=1'b0;
        #10 a=8'b00101000; b=8'b00010000; cin=1'b1;
        #10 a=8'b00001000; b=8'b00000010; cin=1'b1;


    end
    
endmodule
