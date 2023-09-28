// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Reset interface - signals to the reset driver and reset monitor
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

/* once the reset process is started, 
the default state of the testbench components 
as well as DUT needs to be achieved */
interface afvip_reset_if (
    input clk,
    input rst_n
);

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // declare wires
    bit rst_n;

    // signals for the driver
    // driver acts as reset master
    clocking cb_driver @(posedge clk);
        output rst_n;
    endclocking : cb_driver

    // signals for the monitor
    clocking cb_monitor @(posedge clk);
        input rst_n;
    endclocking : cb_monitor

endinterface