
`timescale 1ns/1ps

module alu4 (
    input  logic [3:0] A,
    input  logic [3:0] B,
    input  logic [2:0] opcode,

    output logic [3:0] result,
    output logic       carry_borrow,
    output logic       zero
);

    logic [4:0] temp;

    always_comb begin

        result       = 4'b0000;
        carry_borrow = 1'b0;
        temp         = 5'b00000;

        case (opcode)

            3'b000: begin
                // ADDITION
                temp = {1'b0, A} + {1'b0, B};
                result = temp[3:0];
                carry_borrow = temp[4];
            end

            3'b001: begin
                // SUBTRACTION
                result = A - B;
                carry_borrow = (A < B);
            end

            3'b010: begin
                // AND
                result = A & B;
            end

            3'b011: begin
                // OR
                result = A | B;
            end

            3'b100: begin
                // XOR
                result = A ^ B;
            end

            default: begin
                result = 4'b0000;
                carry_borrow = 1'b0;
            end

        endcase

        // ZERO FLAG
        zero = (result == 4'b0000);

    end

endmodule
