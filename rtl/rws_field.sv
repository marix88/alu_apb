// -----------------------------------------------------------------------------
// Module name: rws_field
// HDL        : System Verilog
// Author     : Nicolae Nicoara (NN)
// Description: Read-Write Shared register field
// Date       : 25 May, 2023
// -----------------------------------------------------------------------------
`timescale 1ns/1ps
module rws_field #(
  parameter TP        = 1              , // Time Propagation
  parameter DWIDTH    = 32             , // Data Width
  parameter RST_VALUE = {DWIDTH{1'd0}}   // Reset Value
)(
// System and Control Interface
  input                   clk   , // Clock
  input                   rst_n , // Asynchronous Reset - Active low
  input                   a_en  , // Port A Write enable
  input                   b_en  , // Port B Write enable
// Data
  input      [DWIDTH-1:0] a_d   , // Port A Input data
  input      [DWIDTH-1:0] b_d   , // Port B Input data
  output reg [DWIDTH-1:0]   q     // Output data
);

// -----------------------------------------------------------------------------
// ---------------------------------- CODE -------------------------------------
// -----------------------------------------------------------------------------

always_ff @(posedge clk or negedge rst_n)
if (~rst_n) q <= #TP RST_VALUE; else // Reset
if (a_en)   q <= #TP a_d      ; else // Set
if (b_en)   q <= #TP b_d      ;      // Set

endmodule