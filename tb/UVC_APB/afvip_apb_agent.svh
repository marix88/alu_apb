// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Agent connected to the APB interface
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------
`timescale 1ns/1ps
class afvip_apb_agent extends uvm_agent;

    `uvm_component_utils(afvip_apb_agent)

    // any component whose parent is set to null becomes a child of uvm_top
    function new(string name = "afvip_apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    afvip_apb_monitor apb_monitor;
    afvip_apb_driver apb_driver;
    afvip_apb_sequencer apb_sequencer;

    virtual function void build_phase (uvm_phase phase);
        // build monitor
        apb_monitor = afvip_apb_monitor::type_id::create("apb_monitor", this);
        // if the requested agent is active build driver and sequencer
        if (get_is_active()) begin
            apb_sequencer = afvip_apb_sequencer::type_id::create("apb_sequencer", this);
            apb_driver = afvip_apb_driver::type_id::create("apb_driver", this);
            `uvm_info(get_name(), "is an active agent", UVM_LOW);
        end
    endfunction : build_phase  


    virtual function void connect_phase(uvm_phase phase);
        // if the agent is active, connect the driver to the sequencer
        if(get_is_active())
            apb_driver.seq_item_port.connect(apb_sequencer.seq_item_export);  
    endfunction
endclass : afvip_apb_agent