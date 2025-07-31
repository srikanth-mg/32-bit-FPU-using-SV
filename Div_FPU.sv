
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 11:57:53 PM
// Design Name: 
// Module Name: Div_FPU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Floating Point Division Implementation with correct exponent and mantissa handling
// 
//////////////////////////////////////////////////////////////////////////////////
odule Div_FPU (
    input logic [31:0] A,          // Operand A (IEEE-754 format)
    input logic [31:0] B,          // Operand B (IEEE-754 format)
    output logic [31:0] result,    // Result in IEEE-754 format
    output logic nan_error         // NaN detection flag
);
    logic sign_a, sign_b, sign_result;
    logic [7:0] exp_a, exp_b, exp_result;
    logic [23:0] mantissa_a, mantissa_b;
    real val_a, val_b, val_result;

    always_comb begin
        // Extract fields
        sign_a = A[31];
        sign_b = B[31];
        exp_a = A[30:23];
        exp_b = B[30:23];
        mantissa_a = {1'b1, A[22:0]};
        mantissa_b = {1'b1, B[22:0]};

        // NaN or division by zero detection
        if ((exp_a == 8'hFF && A[22:0] != 0) || (exp_b == 8'hFF && B[22:0] != 0)) begin
            nan_error = 1'b1;
            result = 32'h7FC00000; // NaN
        end else if (B == 32'h00000000) begin
            nan_error = 1'b1;
            result = 32'h7F800000; // Infinity for division by zero
        end else begin
            nan_error = 1'b0;

            // Convert inputs to real values
            val_a = (2.0 ** (exp_a - 127)) * (mantissa_a / (2.0 ** 23));
            val_b = (2.0 ** (exp_b - 127)) * (mantissa_b / (2.0 ** 23));
            
            if (sign_a) val_a = -val_a;
            if (sign_b) val_b = -val_b;
            
            // Perform division
            val_result = val_a / val_b;
            
            // Convert result back to IEEE-754 format
            sign_result = (val_result < 0) ? 1 : 0;
            val_result = (val_result < 0) ? -val_result : val_result;
            exp_result = 127;
            while (val_result >= 2.0) begin
                val_result = val_result / 2.0;
                exp_result = exp_result + 1;
            end
            while (val_result < 1.0 && val_result > 0) begin
                val_result = val_result * 2.0;
                exp_result = exp_result - 1;
            end

            mantissa_a = val_result * (2 ** 23);
            result = {sign_result, exp_result, mantissa_a[22:0]};
        end
    end
endmodule