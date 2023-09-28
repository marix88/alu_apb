/* top connects the DUT and TestBench. 
It consists of DUT, Test and interface instances. */

// use UVM constructs
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_pkg::*;
import intr_pkg::*;
import rst_pkg::*;
import env_scb_pkg::*;
import test_pkg::*;

module afvip_top;

// Declare signals
logic clk, rst_n, afvip_intr;
logic [31:0] data; 
logic [31:0] pwdata; 
logic [31:0] prdata;
logic [15:0] addr;
logic [15:0] paddr;
logic psel, penable, pwrite, pready, pslverr;

// do I need a timescale? timeunit `timescale 10 ns/100 ps  // time-unit = 10 ns, precision = 100 ps

initial begin
    rst_n = 1;
    #10
    rst_n = 0;
    #10
    rst_n = 1;
end

// instantiate the design
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
// generate clock
always #10 clk =~ clk;

initial begin
    clk <= 0;
    // Set virtual interface handle available to all components below apb_agent
    uvm_config_db#(virtual afvip_apb_if)::set(null, "*.apb_agent.*", "apb_vif", apb_interface);
    // Set virtual interface handle available to all components below interrupt_agent
    uvm_config_db#(virtual afvip_interrupt_if)::set(null, "*.interrupt_agent.*", "interrupt_vif", interrupt_interface);
    // Set virtual interface handle available to all components below reset_agent
    uvm_config_db#(virtual afvip_reset_if)::set(null, "*.reset_agent.*", "reset_vif", reset_interface);
    // Instantiate UVM testbench
    run_test("test");
end 

// See signals in simulation
// Inputs to DUT
assign psel     = apb_interface.psel    ;
assign penable  = apb_interface.penable ;
assign paddr    = apb_interface.paddr   ;
assign pwrite   = apb_interface.pwrite  ;
assign pwdata   = apb_interface.pwdata  ;
// Outputs from DUT
assign apb_interface.pready     = pready    ;
assign apb_interface.prdata     = prdata    ;
assign apb_interface.pslverr    = pslverr   ;
assign interrupt_interface.afvip_intr = afvip_intr;

endmodule : afvip_top
