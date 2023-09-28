// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_environment
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Container for agents
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps
class afvip_environment extends uvm_env;

    `uvm_component_utils(afvip_environment)
    
    // Declare agents
    afvip_apb_agent apb_agent; // active agent
    afvip_interrupt_agent interrupt_agent; // passive agent
    afvip_reset_agent reset_agent; // active agent
    afvip_scoreboard scoreboard;


    /* name  : name of the class instance/an instance name for an object
       parent: a handle to parent class where this object is instantiated */
    function new(string name = "afvip_environment", uvm_component parent); 
        super.new(name, parent);
    endfunction : new

    // Instantiate agents and scoreboard using UVM factory create calls
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_agent = afvip_apb_agent::type_id::create("apb_agent", this);
        interrupt_agent = afvip_interrupt_agent::type_id::create("interrupt_agent", this);
        // Configure agent as passive agent
        uvm_config_db #(uvm_active_passive_enum)::set(this, "interrupt_agent", "is active", UVM_PASSIVE);
        reset_agent = afvip_reset_agent::type_id::create("reset_agent", this);
        scoreboard = afvip_scoreboard::type_id::create("scoreboard", this);
        // reference_model = afvip_reference_model::type_id::create("reference_model", this);
    endfunction : build_phase

    // Connect the scoreboard with the monitor  
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        apb_agent.apb_monitor.apb_item_collected_port.connect(scoreboard.apb_item_collected_export); 
        interrupt_agent.interrupt_monitor.interrupt_item_collected_port.connect(scoreboard.interrupt_item_collected_export);
        reset_agent.reset_monitor.reset_item_collected_port.connect(scoreboard.reset_item_collected_export);
    endfunction : connect_phase
endclass : afvip_environment