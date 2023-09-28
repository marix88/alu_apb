// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_driver
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Driver connected to the APB interface
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

`timescale 1ns/1ps
class afvip_apb_driver extends uvm_driver #(afvip_apb_sequence_item);

    // UVM automation macros for general components
    `uvm_component_utils(afvip_apb_driver)

    // Declare virtual interface, pointer to RTL instance
    virtual afvip_apb_if apb_vif;

    // Item requested from sequencer
    afvip_apb_sequence_item apb_sequence_item; 

    // Default constructor for driver sequence
    function new(string name = "afvip_apb_driver", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from the configuration DB
        if(!uvm_config_db#(virtual afvip_apb_if)::get(this, "", 
            "apb_vif", apb_vif))
                `uvm_fatal("NOVIF", 
                            {"Virtual interface must be set for: ", 
                            get_full_name(), ".apb_vif"})
    endfunction : build_phase
    

    // Translate transaction level objects into pin wiggles at the DUT interface
    virtual task run_phase(uvm_phase phase);
        drive_apb_item();              
    endtask : run_phase

    // Drive item to DUT, back to back transactions
    virtual task drive_apb_item();
        @(posedge apb_vif.rst_n);
        forever begin
            // Get next item from sequencer when item is available in the sequencer
            `uvm_info(get_type_name(), $sformatf("Waiting for data from sequencer"), UVM_MEDIUM)
            seq_item_port.get_next_item(req);                             // seq_item_port and req are part of the uvm_driver base class
                $cast(apb_sequence_item, req.clone());                    // cast: access the derived class members from uvm_object, clone: create apb_sequence_item and copy req to apb_sequence_item
                apb_vif.cb_driver.psel  <= 1;                             // Assert psel
                apb_vif.cb_driver.paddr <= apb_sequence_item.paddr;       // Drive paddr 
                apb_vif.cb_driver.pwrite <= apb_sequence_item.pwrite;     // Drive write access 
                apb_vif.cb_driver.pwdata <= apb_sequence_item.pwdata;     // Drive the written data
                @(apb_vif.cb_driver iff apb_vif.cb_monitor.psel);         // After one clock cycle iff psel read from monitor is asserted                            
                    apb_vif.cb_driver.penable <= 1;                       // Assert penable, start ACCESS state
                @(apb_vif.cb_driver iff apb_vif.cb_monitor.pready);       // After one clock cycle iff pready is asserted, exit the ACCESS state, current transfer complete   
                    apb_vif.cb_driver.penable <= 0;                       // Deassert penable
            seq_item_port.item_done();                                    // Let the sequencer know that it finished driving
        end
    endtask : drive_apb_item
endclass
