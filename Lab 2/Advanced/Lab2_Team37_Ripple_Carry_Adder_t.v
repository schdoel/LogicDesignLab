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
        {a,b,cin} = 17'b0;
        repeat (2 ** 17) begin
            @(posedge CLK)
                Test;
            @(negedge CLK)
                {a,b,cin} = {a,b,cin} + 17'b1;
        end
        $finish;
    end

    task Test;
        begin
        if (sum !== (a + b + cin) & 32'b0000000011111111) begin
            $display("[ERROR] sum");
            $write("a: %d\t", a);
            $write("b: %d\t", b);
            $write("cin: %d\n", cin);
            $write("sum: %d\t", sum);
            $write("should be: %d\n", {(a + b + c0) & 16'b0000000011111111});
            $display;
        end
        if (cout !== &((a + b + cin) & 32'b000000100000000)) begin
            $display("[ERROR] cout");
            $write("a: %d\t", a);
            $write("b: %d\t", b);
            $write("cin: %d\n", cin);
            $write("cout: %d\t", cout);
            $write("should be: %b\n",&((a + b + c0) & 16'b000000100000000));
            $display;
        end
    end
    endtask

endmodule