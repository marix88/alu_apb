/* when the interrupt signal from the DUT comes,
   the interrupt process begins */

interface afvip_interrupt_if (
    input clk,
    input rst_n
);


import uvm_pkg::*;
`include "uvm_macros.svh"

// declare wires
logic afvip_intr;

// for the monitor 
clocking cb_monitor @(posedge clk);
    input afvip_intr;
endclocking

endinterface