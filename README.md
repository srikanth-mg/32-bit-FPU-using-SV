# 32-bit Floating Point Unit (FPU) in SystemVerilog

## Overview
This project implements a 32-bit IEEE 754 compliant Floating Point Unit (FPU) using **SystemVerilog**. It supports operations such as floating-point addition, subtraction, multiplication, and division. The design is verified using a testbench with simulation waveforms.

## Features
- Compliant with **IEEE 754 single-precision** format
- Supports:
  - Addition
  - Subtraction
  - Multiplication
  - Division
- Handles special cases: zero, infinity, NaN
- Robust verification using SystemVerilog testbench
  
## Technologies Used
- **SystemVerilog**
- **Xilinx Vivado** 
- **Testbench Simulation & Waveform analysis**

## Project Structure
- `FPU_TOP.sv` - It's the top module of this design which instantiate all other modules into it
- `Add_FPU.sv` - This file is for the addition operation
- `Sub_FPU.sv` - This file is for the subtraction operation
- `Mul_FPU.sv` - This file is for the Multiplication operation
- `Div_FPU.sv` - This file is for the division operation
  
- `FPU_TOP_TB.sv` - It's the top module of the testbench to verify the overall FPU design
- `Add_FPU_TB.sv` - This file is to verify the addition operation
- `Sub_FPU_TB.sv` - This file is to verify the subtraction operation
- `Mul_FPU_TB.sv` - This file is to verify the Multiplication operation
- `Div_FPU_TB.sv` - This file is to verify the division operation


## Testbench
- Inputs: 32-bit floating-point values
- Operations: Add / Multiply / Divide
- Monitored outputs:
  - `Opcode: %s | A = %h | B = %h | Result = %h | NaN_error = %b` in display console

## Future Improvements
- Add support for fused multiply-add (FMA)
- Implement hardware rounding modes
- Integrate with pipelined CPU core

## Author
**Srikanth Muthuvel Ganthimathi**  
🔗 [LinkedIn](https://www.linkedin.com/in/srikanth9503/)


