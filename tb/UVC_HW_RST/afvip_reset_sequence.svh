`timescale 1ns/1ps

class afvip_reset_sequence extends uvm_sequence #(afvip_reset_sequence_item);

    `uvm_object_utils(afvip_reset_sequence)

    afvip_reset_sequence_item reset_sequence_item;

    function new(string name = "afvip_reset_sequence");
        super.new(name);
    endfunction

    // generate and send sequence_item
    virtual task body(); 
        `uvm_info ("afvip_reset_sequence", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM)
        // Create the sequence item
        reset_sequence_item = afvip_reset_sequence_item::type_id::create("reset_sequence_item");
        // rst_n is 0
        start_item(reset_sequence_item);
            reset_sequence_item.rst_n = 0;
        finish_item(reset_sequence_item);
        #100;
        // rst_n is 1
        start_item(reset_sequence_item);
            reset_sequence_item.rst_n = 1;
        finish_item(reset_sequence_item);  
    endtask 
endclass