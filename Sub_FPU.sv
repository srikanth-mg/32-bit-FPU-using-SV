module Sub_FPU (
    input  logic [31:0] A,    // Operand A (IEEE-754 format)
    input  logic [31:0] B,    // Operand B (IEEE-754 format)
    output logic [31:0] Result, // Result (IEEE-754 format)
    output logic NaN_error    // NaN detection flag
);
    logic [31:0] neg_B;

    // Negate the sign of B
    assign neg_B = {~B[31], B[30:0]};

    // Instantiate Add_FPU
    Add_FPU adder (
        .A(A),
        .B(neg_B),
        .Result(Result),
        .NaN_error(NaN_error)
    );

endmodule
