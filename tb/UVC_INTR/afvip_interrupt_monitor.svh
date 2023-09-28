`timescale 1ns/1ps

class afvip_interrupt_monitor extends uvm_monitor;

    `uvm_component_utils(afvip_interrupt_monitor)
    
    // Declare virtual interface handle
    virtual afvip_interrupt_if interrupt_vif;

    // declare port through which monitor data gets to scoreboard
    uvm_analysis_port #(afvip_interrupt_sequence_item) interrupt_item_collected_port;

    // interrupt_data_object is the signals/bus data to be sent to other components

    event cov_transaction; 

    covergroup cov_trans @cov_transaction;
        // option.per_instance = 1;
        // Coverage bins definition
    endgroup : cov_trans

    function new(string name = "afvip_interrupt_monitor", uvm_component parent = null);
        super.new(name, parent);
        interrupt_item_collected_port = new("interrupt_item_collected_port", this);
        cov_trans = new();
        cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
        //interrupt_data_object = new();
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from the configuration DB
        if(!uvm_config_db #(virtual afvip_interrupt_if) :: get (this, "", "interrupt_vif", interrupt_vif)) begin
                `uvm_error (get_type_name (), "DUT interrupt interface not found")
        end
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        collect_transactions();
    endtask : run_phase

    virtual task collect_transactions();
        // placeholder to capture transaction info
        afvip_interrupt_sequence_item interrupt_data_object = afvip_interrupt_sequence_item::type_id::create("interrupt_data_object", this);
        forever begin
            @(posedge interrupt_vif.cb_monitor.afvip_intr) begin
            interrupt_data_object.afvip_intr = interrupt_vif.cb_monitor.afvip_intr;
                // Define the action to be taken when a packet is received via the declared port 
                interrupt_item_collected_port.write(interrupt_data_object);
                //`uvm_info(get_name(), $sformatf("Send value = %0h", interrupt_data_object.value), UVM_NONE);
            end 
        end
        
    endtask : collect_transactions 

    virtual protected function void perform_transfer_coverage();
        -> cov_transaction;
    endfunction : perform_transfer_coverage
  
endclass