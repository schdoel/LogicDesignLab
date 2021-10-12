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
        initial begin 
        #10 a=4'b0; b=4'b0;
        #10 a=4'b1; b=4'b0;
        #10 a=4'b2; b=4'b0;
        #10 a=4'b3; b=4'b0;
        #10 a=4'b4; b=4'b0;
        #10 a=4'b5; b=4'b0;
        #10 a=4'b6; b=4'b0;
        #10 a=4'b7; b=4'b0;

        #10 a=4'b0; b=4'b1;
        #10 a=4'b1; b=4'b1;
        #10 a=4'b2; b=4'b1;
        #10 a=4'b3; b=4'b1;
        #10 a=4'b4; b=4'b1;
        #10 a=4'b5; b=4'b1;
        #10 a=4'b6; b=4'b1;
        #10 a=4'b7; b=4'b1;

        #10 a=4'b0; b=4'b2;
        #10 a=4'b1; b=4'b2;
        #10 a=4'b2; b=4'b2;
        #10 a=4'b3; b=4'b2;
        #10 a=4'b4; b=4'b2;
        #10 a=4'b5; b=4'b2;
        #10 a=4'b6; b=4'b2;
        #10 a=4'b7; b=4'b2;

        #10 a=4'b0; b=4'b3;
        #10 a=4'b1; b=4'b3;
        #10 a=4'b2; b=4'b3;
        #10 a=4'b3; b=4'b3;
        #10 a=4'b4; b=4'b3;
        #10 a=4'b5; b=4'b3;
        #10 a=4'b6; b=4'b3;
        #10 a=4'b7; b=4'b3;

        #10 a=4'b0; b=4'b4;
        #10 a=4'b1; b=4'b4;
        #10 a=4'b2; b=4'b4;
        #10 a=4'b3; b=4'b4;
        #10 a=4'b4; b=4'b4;
        #10 a=4'b5; b=4'b4;
        #10 a=4'b6; b=4'b4;
        #10 a=4'b7; b=4'b4;

        #10 a=4'b0; b=4'b5;
        #10 a=4'b1; b=4'b5;
        #10 a=4'b2; b=4'b5;
        #10 a=4'b3; b=4'b5;
        #10 a=4'b4; b=4'b5;
        #10 a=4'b5; b=4'b5;
        #10 a=4'b6; b=4'b5;
        #10 a=4'b7; b=4'b5;

        #10 a=4'b0; b=4'b4;
        #10 a=4'b1; b=4'b4;
        #10 a=4'b2; b=4'b4;
        #10 a=4'b3; b=4'b4;
        #10 a=4'b4; b=4'b4;
        #10 a=4'b5; b=4'b4;
        #10 a=4'b6; b=4'b4;
        #10 a=4'b7; b=4'b4;
        
        #10 a=4'b0; b=4'b5;
        #10 a=4'b1; b=4'b5;
        #10 a=4'b2; b=4'b5;
        #10 a=4'b3; b=4'b5;
        #10 a=4'b4; b=4'b5;
        #10 a=4'b5; b=4'b5;
        #10 a=4'b6; b=4'b5;
        #10 a=4'b7; b=4'b5;

        #10 a=4'b0; b=4'b6;
        #10 a=4'b1; b=4'b6;
        #10 a=4'b2; b=4'b6;
        #10 a=4'b3; b=4'b6;
        #10 a=4'b4; b=4'b6;
        #10 a=4'b5; b=4'b6;
        #10 a=4'b6; b=4'b6;
        #10 a=4'b7; b=4'b6;

        #10 a=4'b0; b=4'b7;
        #10 a=4'b1; b=4'b7;
        #10 a=4'b2; b=4'b7;
        #10 a=4'b3; b=4'b7;
        #10 a=4'b4; b=4'b7;
        #10 a=4'b5; b=4'b7;
        #10 a=4'b6; b=4'b7;
        #10 a=4'b7; b=4'b7;
        
        #10 $finish
    end 
    end
    
endmodule
