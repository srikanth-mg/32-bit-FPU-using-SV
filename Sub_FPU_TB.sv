`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 12:59:42 AM
// Design Name: 
// Module Name: tb_sub_fpu
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


module Sub_FPU_TB;

    // Testbench signals
    logic [31:0] A, B;         // Inputs
    logic [31:0] Result;       // Output
    logic NaN_error;           // NaN detection flag

    // Instantiate the DUT
    Sub_FPU uut (
        .A(A),
        .B(B),
        .Result(Result),
        .NaN_error(NaN_error)
    );

    initial begin
        // Test Case 1: 9.65 - 2.3 = 7.35
        A = 32'h411a6666; // 9.65
        B = 32'h40133333; // 2.3
        #10;
        $display("sub: A = %h, B = %h, Result = %h, NaN = %b", A, B, result, nan_error);

        // Test Case 2: 0.0 - 7.9 = -7.9
        A = 32'h00000000; // 0.0
        B = 32'h40fccccd; // 7.9
        #10;
        $display("sub: A = %h, B = %h, Result = %h, NaN = %b", A, B, result, nan_error);

        // Test Case 3: NaN - 4.7 = NaN
        A = 32'h7FC00000; // NaN
        B = 32'h40966666; // 4.7
        #10;
        $display("sub: A = %h, B = %h, Result = %h, NaN = %b", A, B, result, nan_error);

        $stop; // End simulation
    end
endmodule

