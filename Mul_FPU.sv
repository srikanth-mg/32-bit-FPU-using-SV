module Mul_FPU (
    input logic [31:0] A,          // Operand A (IEEE-754 format)
    input logic [31:0] B,          // Operand B (IEEE-754 format)
    output logic [31:0] Result,    // Result in IEEE-754 format
    output logic NaN_error         // NaN detection flag
);
    logic sign_a, sign_b, sign_result;
    logic [7:0] exp_a, exp_b, exp_result;
    logic [23:0] mant_a, mant_b;
    logic [47:0] mant_product;
    logic [23:0] N_mant;
    logic [7:0] adjusted_exp;
   
    always_comb begin
        // Extract fields
        sign_a = A[31];
        sign_b = B[31];
        exp_a = A[30:23];
        exp_b = B[30:23];
        mant_a = {1'b1, A[22:0]}; // Add implied leading 1
        mant_b = {1'b1, B[22:0]}; // Add implied leading 1

        // NaN detection
        if ((exp_a == 8'hFF && A[22:0] != 0) || (exp_b == 8'hFF && B[22:0] != 0)) begin
            NaN_error = 1'b1;
            Result = 32'h7FC00000; // NaN
        end else if (A == 32'h00000000 || B == 32'h00000000) begin
            NaN_error = 1'b0;
            Result = 32'h00000000; // Zero result
        end else begin
            NaN_error = 1'b0;

            // Determine sign
            sign_result = sign_a ^ sign_b;

            // Calculate exponent
            adjusted_exp = exp_a + exp_b - 127;

            // Multiply mantissas
            mant_product = mant_a * mant_b;

            // Normalize mantissa
            if (mant_product[47]) begin
                N_mant = mant_product[46:24]; // Shift right by 1
                adjusted_exp = adjusted_exp + 1;
            end else begin
                N_mant = mant_product[45:23];
            end

            // Check for overflow and underflow
            if (adjusted_exp >= 255) begin
                Result = {sign_result, 8'hFF, 23'b0}; // Overflow: Infinity
            end else if (adjusted_exp <= 0) begin
                Result = 32'h00000000; // Underflow: Zero
            end else begin
                // Assemble final result
                Result = {sign_result, adjusted_exp, N_mant[22:0]};
            end
        end
    end
endmodule