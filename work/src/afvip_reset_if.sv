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
wire rst_n;

// for the driver

// for the monitor


endinterface