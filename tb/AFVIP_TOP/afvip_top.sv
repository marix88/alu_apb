// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Connection to the DUT
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------
/* top connects the DUT and TestBench. 
It consists of DUT, Test and interface instances. */

// time-unit = 1 ns, precision = 1 ps
`timescale 1ns/1ps
module afvip_top;

    // use UVM constructs
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import apb_pkg::*;
    import intr_pkg::*;
    import rst_pkg::*;
    import env_scb_pkg::*;
    import test_pkg::*;

// Declare signals
logic clk = 0; 
logic rst_n;
logic afvip_intr;
bit [31:0] pwdata; 
bit [31:0] prdata;
bit [15:0] paddr;
bit psel, penable, pwrite, pready, pslverr;

// Generate clock
always begin 
    #5 clk <= ~clk;
end

// instantiate the design
// TP (propagation time for simulation) is an input parameter 
afvip 
    #(
        .TP(0)
    ) afvip_dut (
        .clk        (clk)       ,
        .rst_n      (rst_n)     ,
        .afvip_intr (afvip_intr),
        .psel       (psel)      ,
        .penable    (penable)   ,
        .paddr      (paddr)     ,
        .pwrite     (pwrite)    ,
        .pwdata     (pwdata)    ,
        .pready     (pready)    ,
        .prdata     (prdata)    ,
        .pslverr    (pslverr)
    );

// instance of afvip_apb_if
afvip_apb_if apb_interface (
    .clk(clk),
    .rst_n(rst_n)
);


// instance of afvip_interrupt_if
afvip_interrupt_if interrupt_interface (
    .clk(clk),
    .rst_n(rst_n)
);

// reset_interface is an instance of afvip_reset_if
afvip_reset_if reset_interface(
    .clk(clk),
    .rst_n(rst_n)
);

// Testcase instances
/* afvip_test apb_test (apb_interface);
afvip_test interrupt_test (interrupt_interface);
afvip_test reset_test (reset_interface); */

initial begin
    // Set virtual interface handle available to all components in the testbench
    // the 3rd argument is declared in the test and is used for ::get method in monitor and driver
    uvm_config_db#(virtual afvip_apb_if)::set(null, "*", "apb_vif", apb_interface);
    // Set virtual interface handle available to all components below interrupt_agent
    uvm_config_db#(virtual afvip_interrupt_if)::set(null, "*", "interrupt_vif", interrupt_interface);
    // Set virtual interface handle available to all components below reset_agent
    uvm_config_db#(virtual afvip_reset_if)::set(null, "*", "reset_vif", reset_interface);
    // Instantiate UVM testbench
    /* apb_test.run ();
    interrupt_test.run ();
    reset_test.run (); */
    // run_test("afvip_test_write_all_read_all"); // Write all registers, read all registers
    // run_test("afvip_test_write_one_read_all"); // Write one register, read all registers
    run_test("afvip_apb_opcode0_test");        // Calculate operation opcode0, write and read result in dst
    // run_test("afvip_apb_opcode1_test");
    // run_test("afvip_apb_opcode2_test");
    // run_test("afvip_apb_opcode3_test");
    // run_test("afvip_apb_opcode4_test");
end 

// See signals in simulation
// Inputs to DUT
assign psel     = apb_interface.psel    ;
assign penable  = apb_interface.penable ;
assign paddr    = apb_interface.paddr   ;
assign pwrite   = apb_interface.pwrite  ;
assign pwdata   = apb_interface.pwdata  ;
assign rst_n    = reset_interface.rst_n ;
// assign reset_interface.rst_n = rst_n;
// Outputs from DUT
assign apb_interface.pready             = pready    ;
assign apb_interface.prdata             = prdata    ;
assign apb_interface.pslverr            = pslverr   ;
assign interrupt_interface.afvip_intr   = afvip_intr;
endmodule : afvip_top
