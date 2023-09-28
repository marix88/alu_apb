// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Agent connected to the reset interface
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps
class afvip_reset_agent extends uvm_agent;

    `uvm_component_utils(afvip_reset_agent)

    function new(string name = "afvip_reset_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    afvip_reset_monitor reset_monitor;
    afvip_reset_driver reset_driver;
    afvip_reset_sequencer reset_sequencer;

    virtual function void build_phase (uvm_phase phase);
        // build monitor
        reset_monitor = afvip_reset_monitor::type_id::create("reset_monitor", this);
        // if the requested agent is active build driver and sequencer
        if (get_is_active()) begin
            reset_sequencer = afvip_reset_sequencer::type_id::create("reset_sequencer", this);
            reset_driver = afvip_reset_driver::type_id::create("reset_driver", this);
            `uvm_info(get_name(), "is an active agent", UVM_LOW);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // if the agent is active, connect the driver to the sequencer
        if(get_is_active())
            reset_driver.seq_item_port.connect(reset_sequencer.seq_item_export);  
    endfunction
endclass

