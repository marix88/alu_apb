// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Agent connected to the interrupt interface
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps

class afvip_interrupt_agent extends uvm_agent;

    `uvm_component_utils(afvip_interrupt_agent)

    function new(string name = "afvip_interrupt_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    afvip_interrupt_monitor interrupt_monitor;

    virtual function void build_phase (uvm_phase phase);
        interrupt_monitor = afvip_interrupt_monitor::type_id::create("interrupt_monitor", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // keep it empty
    endfunction

endclass