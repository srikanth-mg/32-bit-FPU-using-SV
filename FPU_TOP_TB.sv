
module FPU_TOP_TB;

    // Testbench signals
    logic [31:0] A, B;               // IEEE-754 inputs
    logic [1:0] Opcode;              // Operation code
    logic [31:0] Result;             // Result
    logic NaN_error;                 // NaN error flag

    // Instantiate the FPU_TOP module
    FPU_TOP uut (
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .Result(Result),
        .NaN_error(NaN_error)
    );

    // Function to convert IEEE-754 format to real
    function real ieee_to_real(input [31:0] ieee);
        logic sign;
        logic [7:0] exponent;
        logic [22:0] mantissa;
        real value;

        sign = ieee[31];
        exponent = ieee[30:23];
        mantissa = ieee[22:0];

        if (exponent == 8'hFF) begin
            if (mantissa == 0)
                value = (sign) ? -1.0e308 : 1.0e308; // Infinity
            else
                value = 0.0 / 0.0; // NaN
        end else if (exponent == 0) begin
            value = (mantissa / (2.0 ** 23)) * (2.0 ** -126); // Subnormal
        end else begin
            value = (1.0 + mantissa / (2.0 ** 23)) * (2.0 ** (exponent - 127));
        end

        // Apply sign
        if (sign) value = -value;
        ieee_to_real = value;
    endfunction

    // Task to Display Results
    task display_result(input [31:0] a, input [31:0] b, input [1:0] opcode, input [31:0] Result, input logic nan_flag);
        string operation;
        case (opcode)
            2'b00: operation = "Add";
            2'b01: operation = "Subtract";
            2'b10: operation = "Multiply";
            2'b11: operation = "Divide";
            default: operation = "Unknown";
        endcase
        $display("| Opcode: %s | A = %h | B = %h | Result = %h | NaN_error = %b |", 
                 operation, a, b, Result, nan_flag);
        #20;  // Default delay
        $display(" A = %e, B = %e", ieee_to_real(a), ieee_to_real(b));
$display(" Result: Sign: %b, Exponent: %h, Mantissa: %h", Result[31], Result[30:23], Result[22:0]);


    endtask

    // Function to Generate Random IEEE-754 Values
    function [31:0] random_two_significant();
        real value;
        int sign, exponent;
        logic [22:0] mantissa;

        // Generate two significant digits between 1.10 and 1.99
        value = 1.0 + ($urandom_range(10, 99) / 100.0);
        sign = 0; // Always positive
        exponent = 127; // Normalized exponent for values around 1.x

        // Normalize mantissa
        mantissa = (value - 1.0) * (2.0 ** 23);

        return {sign, exponent[7:0], mantissa};
    endfunction

    // Test Control
    initial begin
        $display("--------------------------------------------------------");
        $display("Opcode: 00 - Add | 01 - Sub | 10 - Mul | 11 - Div");
        $display("--------------------------------------------------------");

        for (int i = 0; i < 10; i++) begin
            // Generate random inputs
            A = random_two_significant();
            B = random_two_significant();
            Opcode = $random % 4; // Random opcode: 00, 01, 10, 11

            // Avoid division by zero
            if (Opcode == 2'b11 && B == 32'h00000000) 
                B = 32'h3F800000; // Set B to 1.0 for division

            #10; // Wait for the operation to complete

            // Display results
            display_result(A, B, Opcode, Result, (Opcode == 2'b11) ? 1'b0 : NaN_error);
            $display("--------------------------------------------------------");
        end

        $stop;
    end
endmodule
