///////////////////////////////////////////////////////////
// Module Name: Div_FPU_TB
// Description: Testbench for Div_FPU with Random Numbers (Two Significant Digits)
//////////////////////////////////////////////////////////////////////////////////
module Div_FPU_TB;

    logic [31:0] A, B, Result;    // Inputs and output
    logic NaN_error;              // NaN detection flag

    // Instantiate the Division FPU module
    Div_FPU uut (
        .A(A),
        .B(B),
        .result(Result),
        .nan_error(NaN_error)
    );

    // Function to Generate Random IEEE-754 Numbers with Two Significant Digits
    function [31:0] random_two_significant();
        int sign, exponent, mantissa;
        real value;

        sign = $urandom_range(0, 0); // Always positive for simplicity
        value = 1.0 + ($urandom_range(10, 99) * 0.01); // Random value between 1.10 and 1.99
        exponent = 127; // Biased exponent for normalized range (1.x)

        mantissa = (value - 1.0) * (2.0 ** 23); // Calculate 23-bit mantissa
        return {sign, exponent[7:0], mantissa[22:0]}; // Combine sign, exponent, and mantissa
    endfunction

    // Task to Display Results
    task display_result(input [31:0] a, input [31:0] b, input [31:0] result, input logic nan_flag);
        $display("A = %h, B = %h, Result = %h, NaN_error = %b", a, b, result, nan_flag);
    endtask

    // Simulation Logic
    initial begin
        $display("Floating-Point Division Testbench with Random Numbers\n");

        for (int i = 0; i < 10; i++) begin
            // Generate random inputs
            A = random_two_significant();
            B = random_two_significant();

            // Avoid division by zero
            if (B == 32'h00000000) B = 32'h3F800000; // Set B to 1.0 if zero

            #10; // Wait for 10ns
            display_result(A, B, Result, NaN_error);
        end

        // Edge Case: Division by Zero
        A = 32'h40400000; // 3.0
        B = 32'h00000000; // 0.0
        #10;
        $display("Division by Zero: A = %h, B = %h, Result = %h, NaN_error = %b", A, B, Result, NaN_error);

        $display("\nSimulation Complete.");
        $finish;
    end
endmodule
