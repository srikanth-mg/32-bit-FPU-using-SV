`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 11:57:53 PM
// Design Name: 
// Module Name: tb_add_fpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Add_FPU_TB;

    // Testbench signals
    logic [31:0] A, B;         // Inputs
    logic [31:0] Result;       // Output
    logic NaN_error;           // NaN detection flag

    // Instantiate the DUT
    Add_FPU uut (
        .A(A),
        .B(B),
        .Result(Result),
        .NaN_error(NaN_error)
    );

    initial begin
        // Test Case 1: 2.4 + 1.2 = 3.6
        A = 32'h4019999a; // 2.4
        B = 32'h3f99999a; // 1.2
        #10;
        $display("Addition: A = %h, B = %h, Result = %h, NaN = %b", A, B, result, nan_error);
       
         // Test Case 2: 0.0 + 0.8 = 0.8
        A = 32'h00000000; // 0.0
        B = 32'h3f4ccccd; // 0.8
        #10;
        $display("Addition: A = %h, B = %h, Result = %h,NaN = %b", A, B, result, nan_error);

        // Test Case 3: NaN + 7.85 = NaN
        A = 32'h7FC00000; // NaN
        B = 32'h40fb3333; // 7.85
        #10;
        $display("Addition: A = %h, B = %h, Result = %h, NaN = %b", A, B, result, nan_error);

        $stop; // End simulation
    end
endmodule
