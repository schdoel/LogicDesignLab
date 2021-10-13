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
        repeat (2 ** 8) begin
            #1 a = a + 8'b1; b = 8'b0;
            Test();
            #1 c0 = c0 + 1'b1;
            Test();
            repeat(2 ** 8)
                #1 b = b + 8'b1;
                Test();
                #1 c0 = c0 + 1'b1;
                Test();
            end
        end
        #1 $finish;
    end
    
    //utility task for testing
    task Test;
    begin
        if({cout, sum}!==(a+b+cin)) begin
            $display("[ERROR]");
            $write("a:%d",a);
            $write("b:%d",b);
            $write("c0 (cin):%d",c8);
            $write("c8 (cout):%d",c0);
            $write("s (Sum):%d",s);
            $display;
        end
    end
    endtask
endmodule

/*
module Ripple_Carry_Adder_t(a, b, cin, cout, sum);
    reg [7:0] a = 8'b0;
    reg [7:0] b = 8'b0;
    reg cin = 1'b0;
    wire cout;
    wire [7:0] sum;
    // reg CLK = 1;

    Ripple_Carry_Adder rca_i (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );

    initial begin
        repeat (2 ** 4) begin
            #1 {a,b} = {a,b} + 16'b1;
            Test;
            #1 cin = cin+1'b1;
            Test;
        end
        
        repeat (2 ** 4) begin
            #1 {b,a} = {b,a} + 16'b1;
            Test;
            #1 cin = cin+1'b1;
            Test;
        end

        #1 $finish;
    end


    
    //utility task for testing
    task Test;
    begin
        if({cout, sum}!==(a+b+cin)) begin
            $display("[ERROR]");
            $write("a:%d",a);
            $write("b:%d",b);
            $write("c0 (cin):%d",c8);
            $write("c8 (cout):%d",c0);
            $write("s (Sum):%d",s);
            $display;
        end
    end
    endtask
endmodule
*/
