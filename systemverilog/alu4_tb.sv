
`timescale 1ns/1ps

module alu4_tb;

    logic [3:0] A;
    logic [3:0] B;
    logic [2:0] opcode;

    logic [3:0] result;
    logic carry_borrow;
    logic zero;

    // DUT INSTANTIATION
    alu4 uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .carry_borrow(carry_borrow),
        .zero(zero)
    );

    initial begin

        $display("==============================================");
        $display("       4-BIT ALU SYSTEMVERILOG SIMULATION");
        $display("==============================================");

        $monitor("Time=%0t | A=%b | B=%b | OP=%b | RESULT=%b | C/B=%b | ZERO=%b",
                  $time, A, B, opcode, result,
                  carry_borrow, zero);

        // ADDITION: 5 + 3 = 8
        A = 4'b0101;
        B = 4'b0011;
        opcode = 3'b000;
        #20;

        // ADDITION: 15 + 1 = 16
        A = 4'b1111;
        B = 4'b0001;
        opcode = 3'b000;
        #20;

        // SUBTRACTION: 5 - 3 = 2
        A = 4'b0101;
        B = 4'b0011;
        opcode = 3'b001;
        #20;

        // SUBTRACTION: 3 - 5 = -2
        A = 4'b0011;
        B = 4'b0101;
        opcode = 3'b001;
        #20;

        // AND: 5 & 3 = 1
        A = 4'b0101;
        B = 4'b0011;
        opcode = 3'b010;
        #20;

        // OR: 5 | 3 = 7
        A = 4'b0101;
        B = 4'b0011;
        opcode = 3'b011;
        #20;

        // XOR: 5 ^ 3 = 6
        A = 4'b0101;
        B = 4'b0011;
        opcode = 3'b100;
        #20;

        // ZERO FLAG: 5 - 5 = 0
        A = 4'b0101;
        B = 4'b0101;
        opcode = 3'b001;
        #20;

        $display("==============================================");
        $display("       SIMULATION COMPLETED");
        $display("==============================================");

        $finish;

    end

endmodule
