module Ripple_Carry_Adder_t(a, b, cin, cout, sum);
    reg CLK = 1;
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
    always #1 CLK = ~CLK;

    initial begin
        {a,b,cin} = 9'b0;

        repeat (2 ** 9) begin
            @(posedge CLK)
                Test;
            @(negedge CLK)
                {a,b,cin} = {a,b,cin} + 1'b1;
        end
        $finish;
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
