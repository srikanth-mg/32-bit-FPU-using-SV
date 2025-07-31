module Add_FPU (
    input  logic [31:0] A,    // Operand A (IEEE-754 format)
    input  logic [31:0] B,    // Operand B (IEEE-754 format)
    output logic [31:0] Result, // Result (IEEE-754 format)
    output logic NaN_error    // NaN detection flag
);

    // Internal signals
    logic sign_a, sign_b, result_sign;
    logic [7:0] exp_a, exp_b, exp_diff, result_exp;
    logic [23:0] mant_a, mant_b, aligned_mant_a, aligned_mant_b;
    logic [24:0] mant_sum;

    // Extract sign, exponent, and mantissa
    assign sign_a = A[31];
    assign sign_b = B[31];
    assign exp_a = A[30:23];
    assign exp_b = B[30:23];
    assign mant_a = {1'b1, A[22:0]}; // Add implicit leading 1 for normalized numbers
    assign mant_b = {1'b1, B[22:0]};

    always_comb begin
        NaN_error = 0;
        Result = 0;

        // Step 1: Special case handling
        if ((exp_a == 8'hFF && A[22:0] != 0) || (exp_b == 8'hFF && B[22:0] != 0)) begin
            Result = 32'h7FC00000; // NaN
            NaN_error = 1;
        end else if (exp_a == 8'hFF) begin
            Result = A; // A is Infinity
        end else if (exp_b == 8'hFF) begin
            Result = B; // B is Infinity
        end else begin
            // Step 2: Align Exponents
            if (exp_a > exp_b) begin
                exp_diff = exp_a - exp_b;
                aligned_mant_a = mant_a;
                aligned_mant_b = mant_b >> exp_diff;
                result_exp = exp_a;
            end else begin
                exp_diff = exp_b - exp_a;
                aligned_mant_a = mant_a >> exp_diff;
                aligned_mant_b = mant_b;
                result_exp = exp_b;
            end

            // Step 3: Add Mantissas
            if (sign_a == sign_b) begin
                mant_sum = aligned_mant_a + aligned_mant_b;
                result_sign = sign_a;
            end else begin
                if (aligned_mant_a >= aligned_mant_b) begin
                    mant_sum = aligned_mant_a - aligned_mant_b;
                    result_sign = sign_a;
                end else begin
                    mant_sum = aligned_mant_b - aligned_mant_a;
                    result_sign = sign_b;
                end
            end

            // Step 4: Normalize Result
            if (mant_sum[24]) begin
                mant_sum = mant_sum >> 1;
                result_exp = result_exp + 1;
            end else begin
                while (mant_sum[23] == 0 && result_exp > 0) begin
                    mant_sum = mant_sum << 1;
                    result_exp = result_exp - 1;
                end
            end

            // Step 5: Assemble Result
            Result = {result_sign, result_exp, mant_sum[22:0]};
        end
    end

endmodule
