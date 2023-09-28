// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: APB interface - signals to the APB driver and APB monitor
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps
interface afvip_apb_if (
        input clk,
        input rst_n
    );

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    // declare signals
    bit psel; 
    bit penable; 
    bit [15:0] paddr; 
    bit pwrite; 
    bit [31:0] pwdata; 
    bit pready;
    bit [31:0] prdata;
    bit pslverr;

    // signals for the driver
    // driver acts as APB master
    clocking cb_driver @(posedge clk);
        output psel;
        output penable;
        output paddr;
        output pwrite;
        output pwdata;
        input pready;
        input prdata;
        input pslverr;
    endclocking : cb_driver

    // signals for the monitor
    clocking cb_monitor @(posedge clk);
        input psel;
        input penable;
        input paddr;
        input pwrite;
        input pwdata;
        input pready;
        input prdata;
        input pslverr;
    endclocking : cb_monitor

endinterface : afvip_apb_if