`timescale 1ns/1ps
class afvip_apb_monitor extends uvm_monitor;

    `uvm_component_utils(afvip_apb_monitor)
    /* `uvm_component_utils_begin(afvip_apb_monitor)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end */

    /* Declare virtual interface handle
    Actual interface object is later obtained by doing a get() call on uvm_config_db */
    virtual afvip_apb_if apb_vif;

    // Control checking in monitor and interface
    // logic checks_enable = 1;  

    // Control coverage in monitor and interface
    // logic coverage_enable = 1;

    // declare port through which monitor data gets to scoreboard
    uvm_analysis_port #(afvip_apb_sequence_item) apb_item_collected_port;

    event cov_transaction; 

    covergroup cov_trans @cov_transaction;
        // option.per_instance = 1;
        // Coverage bins definition
    endgroup : cov_trans

    function new(string name, uvm_component parent);
        super.new(name, parent);
        apb_item_collected_port = new("apb_item_collected_port", this);
        cov_trans = new();
        cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
        //apb_sequence_item = new();
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from the configuration DB
        if (! uvm_config_db#(virtual afvip_apb_if) :: get (this, "", "apb_vif", apb_vif)) 
                `uvm_error (get_type_name (), "DUT apb interface not found")
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
            collect_transactions(); // collector task
    endtask : run_phase

    virtual  task collect_transactions();
        // apb_sequence_item is the signals/bus data from the DUT to be sent to other components
        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");
        forever begin
            @(posedge apb_vif.clk iff (apb_vif.cb_monitor.psel && apb_vif.cb_monitor.penable && apb_vif.cb_monitor.pready));
            begin
                // Collect data from the bus into apb_sequence_item
                apb_sequence_item.psel    = apb_vif.cb_monitor.psel;
                apb_sequence_item.penable = apb_vif.cb_monitor.penable;
                apb_sequence_item.pready  = apb_vif.cb_monitor.pready;
                apb_sequence_item.paddr   = apb_vif.cb_monitor.paddr;
                apb_sequence_item.pwrite  = apb_vif.cb_monitor.pwrite;
                apb_sequence_item.pwdata  = apb_vif.cb_monitor.pwdata;
                apb_sequence_item.prdata  = apb_vif.cb_monitor.prdata;
                // Send data object through the analysis port when data is available
                apb_item_collected_port.write(apb_sequence_item);
                `uvm_info(get_name(), $sformatf("Send item from monitor"), UVM_NONE);
            end 
        end
    endtask : collect_transactions

    virtual protected function void perform_transfer_coverage();
        -> cov_transaction;
    endfunction : perform_transfer_coverage

    virtual protected function void perform_transfer_checks();
        // Perform data checks on the data collected (apb_sequence_item)
    endfunction : perform_transfer_checks

    // Function to check basic protocol specs
    /* virtual function void check_protocol();
        // If protocol checker is enabled, perform checks
        if (checks_enable)
        check_protocol();
    endfunction : check_protocol */
  
endclass : afvip_apb_monitor