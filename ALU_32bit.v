/*
================================================================================
  PROJECT: ASIC Implementation of Low Power, High Speed ALU
  USING BOOTH MULTIPLIER AND BARREL SHIFTER
  
  MODULE: ALU_32bit (Top-Level)
  
  DESCRIPTION:
  This is the top-level ALU module that integrates:
  1. ALU Core (ADD, SUB, AND, OR, XOR, NOT)
  2. Booth Multiplier (32-bit x 32-bit multiplication)
  3. Barrel Shifter (single-cycle shift operations)
  
  FEATURES:
  - 32-bit operands A and B
  - 3-bit operation selector (sel[2:0]) for 8 operations
  - op_switch signal to multiplex SHIFT and MULTIPLY (both use sel=101)
  - 5-bit shift amount (shamt[4:0]) for 0-31 position shifts
  - 2-bit shift mode (shift_mode[1:0]) for LSL/LSR/ASR
  - 32-bit result output Y
  - Carry flag output
  
  OPERATION MAPPING:
  sel[2:0] | op_switch | Operation
  ---------|-----------|----------
  000      | -         | ADD
  001      | -         | SUB
  010      | -         | AND
  011      | -         | OR
  100      | -         | XOR
  101      | 0         | SHIFT (uses shamt and shift_mode)
  101      | 1         | MULTIPLY
  110      | -         | NOT
  
  TECHNOLOGY: 180nm CMOS
  AUTHOR: Batch 01 - KLE Technological University
  DATE: May 28, 2026
================================================================================
*/

`timescale 1ns/1ps

module ALU_32bit(
    input [31:0] A,              // 32-bit Operand A
    input [31:0] B,              // 32-bit Operand B
    input [2:0] sel,             // 3-bit Operation Selector
    input op_switch,             // Multiplexer for SHIFT vs MULTIPLY (when sel=101)
    input [4:0] shamt,           // 5-bit Shift Amount (0-31)
    input [1:0] shift_mode,      // Shift Mode: 00=LSL, 01=LSR, 10=ASR
    output reg [31:0] Y,         // 32-bit ALU Result
    output reg carry             // Carry Flag
);

// Internal wires for sub-module outputs
wire [31:0] shift_out;           // Output from Barrel Shifter
wire [31:0] mult_out;            // Output from Booth Multiplier

// Instantiate Barrel Shifter sub-module
barrel_shifter BS(
    .A(A),
    .shamt(shamt),
    .shift_mode(shift_mode),
    .Y(shift_out)
);

// Instantiate Booth Multiplier sub-module
booth_multiplier BM(
    .A(A),
    .B(B),
    .Y(mult_out)
);

// Combinational logic for ALU core operations and output selection
always @(*) begin
    carry = 0;  // Default carry = 0
    
    case(sel)
        3'b000: begin
            // ADD: A + B
            {carry, Y} = A + B;
        end
        
        3'b001: begin
            // SUB: A - B (Two's complement subtraction)
            {carry, Y} = A - B;
        end
        
        3'b010: begin
            // AND: A & B
            Y = A & B;
        end
        
        3'b011: begin
            // OR: A | B
            Y = A | B;
        end
        
        3'b100: begin
            // XOR: A ^ B
            Y = A ^ B;
        end
        
        3'b101: begin
            // Shared opcode for SHIFT and MULTIPLY
            // op_switch determines which operation executes
            if(op_switch == 1'b0) begin
                // SHIFT operation (uses Barrel Shifter output)
                Y = shift_out;
            end else begin
                // MULTIPLY operation (uses Booth Multiplier output)
                Y = mult_out;
            end
        end
        
        3'b110: begin
            // NOT: ~A (Bitwise NOT / One's complement)
            Y = ~A;
        end
        
        default: begin
            // Default case: output zero
            Y = 32'b0;
            carry = 0;
        end
    endcase
end

endmodule

// ============================================================================
// End of ALU_32bit.v
// ============================================================================
