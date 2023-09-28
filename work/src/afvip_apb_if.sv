interface afvip_apb_if (
        input clk,
        input rst_n
    );

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // declare signals
    logic psel; 
    logic penable; 
    logic [15:0] paddr; 
    logic pwrite; 
    logic [31:0] pwdata; 
    logic pready;
    logic [31:0] prdata;
    logic pslverr;

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
endinterface