`timescale 1ns / 1ps
module Mul_FPU_TB;

    // Testbench variables
    logic [31:0] A, B;         // Inputs
    logic [31:0] Result;   
       logic NaN_error;     // Output

    // Instantiate the DUT
    Mul_FPU uut (
        .A(A),
        .B(B),
        .Result(Result),
        .NaN_error(NaN_error)
    );

    // Testbench logic
    initial begin
        // Test Case: 8.7 * 4.5 = ~39.15
        A = 32'h410B3333; // 8.7 in IEEE-754
        B = 32'h40900000; // 4.5 in IEEE-754
        #10;
        $display("Test Case: A = %h, B = %h, Result = %h", A, B, Result,NaN_error );
        
            // Test Case 2: 0.0 * 5.5 = 0.0
        A = 32'h00000000; // 0.0 in IEEE-754
        B = 32'h40B00000; // 5.5 in IEEE-754
        #10;
        $display("A = %h, B = %h, Result = %h, NaN = %b", A, B, Result, NaN_error);

        // Test Case 3: Inf * 0 = NaN
        A = 32'h7F800000; // Infinity
        B = 32'h00000000; // Zero
        #10;
        $display("A = %h, B = %h, Result = %h, NaN = %b", A, B, Result, NaN_error);
        
           // Test Case 4: 8.2 * 5.6 = 45.92
        A = 32'h41033333; // 8.2 in IEEE-754
        B = 32'h40b33333; // 5.6 in IEEE-754
        #10;
        $display("A = %h, B = %h, Result = %h, NaN = %b", A, B, Result, NaN_error);

        // Add additional cases if needed

        $stop; // End simulation
    end

endmodule
