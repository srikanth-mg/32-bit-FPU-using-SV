module FPU_TOP (
    input logic [31:0] A, B,       // IEEE-754 inputs
    input logic [1:0] Opcode,      // Operation code: 00 - Add, 01 - Sub, 10 - Mul, 11 - Div
    output logic [31:0] Result,    // IEEE-754 result
    output logic NaN_error         // NaN detection flag
);

    // Internal signals
    logic [31:0] add_result, sub_result, mul_result, div_result;
    logic add_nan, sub_nan, mul_nan; // Remove div_nan

    // Instantiate Add_FPU
    Add_FPU adder (
        .A(A),
        .B(B),
        .Result(add_result),
        .NaN_error(add_nan)
    );

    // Instantiate Sub_FPU
    Sub_FPU subtractor (
        .A(A),
        .B(B),
        .Result(sub_result),
        .NaN_error(sub_nan)
    );

    // Instantiate Mul_FPU
    Mul_FPU multiplier (
        .A(A),
        .B(B),
        .Result(mul_result),
        .NaN_error(mul_nan)
    );

    // Instantiate Div_FPU
    Div_FPU divider (
        .A(A),
        .B(B),
        .result(div_result) // Removed NaN_error
    );

    // Opcode Selection
    always_comb begin
        case (Opcode)
            2'b00: begin // Add Operation
                Result = add_result;
                NaN_error = add_nan;
            end
            2'b01: begin // Subtract Operation
                Result = sub_result;
                NaN_error = sub_nan;
            end
            2'b10: begin // Multiply Operation
                Result = mul_result;
                NaN_error = mul_nan;
            end
            2'b11: begin // Divide Operation
                Result = div_result;
                NaN_error = 1'b0; // No NaN_error for division
            end
            default: begin // Default case
                Result = 32'h00000000;
                NaN_error = 1'b0;
            end
        endcase
    end

endmodule
