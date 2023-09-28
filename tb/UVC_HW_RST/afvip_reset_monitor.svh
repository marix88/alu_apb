`timescale 1ns/1ps

class afvip_reset_monitor extends uvm_monitor;
    `uvm_component_utils(afvip_reset_monitor)

     // Declare virtual interface handle
    virtual afvip_reset_if reset_vif;

    // Control checking in monitor and interface
    // bit checks_enable = 1;  

    // Control coverage in monitor and interface
    // bit coverage_enable = 1;

    // event cov_transaction; 

    // declare port through which monitor data gets to scoreboard
    uvm_analysis_port #(afvip_reset_sequence_item) reset_item_collected_port;

    // reset_data_object is the signals/bus data to be sent to other components
    afvip_reset_sequence_item reset_data_object;


    /* `uvm_component_utils_begin(afvip_reset_monitor)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end */

    /* covergroup cov_trans @cov_transaction;
        // option.per_instance = 1;
        // Coverage bins definition
    endgroup : cov_trans */

    function new(string name = "afvip_interrupt_monitor", uvm_component parent = null);
        super.new(name, parent);
        // cov_trans = new();
        // cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
        reset_data_object = new();
        // reset_item_collected_port = new ("reset_item_collected_port", this); 
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from the configuration DB
        reset_item_collected_port = new("reset_item_collected_port", this);
        if (! uvm_config_db #(virtual afvip_reset_if) :: get (this, "", "reset_vif", reset_vif)) begin
                `uvm_error (get_type_name (), "DUT reset interface not found")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        collect_transactions(); // collector task
    endtask : run_phase

    virtual protected task collect_transactions();
        // Collect data from the bus into  reset_data_object

    endtask : collect_transactions

    /* virtual protected function void perform_transfer_coverage();
        -> cov_transaction;
    endfunction : perform_transfer_coverage

    virtual protected function void perform_transfer_checks();
        // Perform data checks on the data collected (apb_data_object)
    endfunction : perform_transfer_checks

    // Function to check basic protocol specs
    virtual function void check_protocol();
        // If protocol checker is enabled, perform checks
        if (checks_enable)
        check_protocol();
    endfunction : check_protocol */
endclass : afvip_reset_monitor