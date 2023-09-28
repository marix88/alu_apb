// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Interrupt interface - signal to the interrupt monitor
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

/* when the interrupt signal from the DUT comes,
   the interrupt process begins */

`timescale 1ns/1ps

interface afvip_interrupt_if (
    input clk,
    input rst_n,
    output afvip_intr
);


import uvm_pkg::*;
`include "uvm_macros.svh"

// declare wires
wire afvip_intr;

// for the monitor 
clocking cb_monitor @(posedge clk);
    input afvip_intr;
endclocking : cb_monitor

endinterface