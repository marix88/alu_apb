// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_apb_agent
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Driver connected to the reset interface
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

class afvip_reset_driver extends uvm_driver #(afvip_reset_sequence_item);

    // UVM automation macros for general components
    `uvm_component_utils(afvip_reset_driver)

    // Declare virtual handle
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_reset_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from the configuration DB
        if(!uvm_config_db#(virtual afvip_reset_if)::get(this, "", 
            "reset_vif", reset_vif)) 
            `uvm_fatal("NOVIF", 
                        {"Virtual interface must be set for: ", 
                        get_full_name(), ".vif"})
    endfunction : build_phase
    
    // translate transaction level objects into pin wiggles at the DUT interface
    task run_phase(uvm_phase phase);
        // Declare item from the sequencer
        afvip_reset_sequence_item req_reset_item;
        super.run_phase(phase);

        forever begin
            /* get next item from the sequencer. If none exists, then wait until
            next item is available -> this is blocking in nature */
            `uvm_info(get_type_name(), $sformatf("Waiting for data from sequencer"), UVM_MEDIUM)
            // Get next item from the sequencer through the port (may block)
            seq_item_port.get_next_item(req_reset_item);
            $display("%s", req_reset_item.sprint());
            drive_reset_item(req_reset_item);
            seq_item_port.item_done();
            // Finished driving given sequence item. Ready to request next item.
        end
    endtask : run_phase

    // reset is Asychronous Active LOW  

    // Send data from the item in the driver to the DUT interface
    task drive_reset_item(afvip_reset_sequence_item req_reset_item);
        reset_vif.cb_driver.rst_n <= req_reset_item.rst_n;
    endtask : drive_reset_item
endclass

   