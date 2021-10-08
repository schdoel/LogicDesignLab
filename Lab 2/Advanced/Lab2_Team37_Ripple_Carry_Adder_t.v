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
        //POKOKNYA INI BIKIN DRI A 0000 B 0000 SAMPE B 1111
        //TERUS BRU MULAI A NYA 0001 TERUS JDI BRP TUH 4^4 ?

    end
    
endmodule