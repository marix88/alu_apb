`timescale 1ns/1ps

class afvip_interrupt_sequence_item extends uvm_sequence_item;
    
    // abstract level definition
    bit afvip_intr;

    `uvm_object_utils_begin(afvip_interrupt_sequence_item)
        `uvm_field_int(afvip_intr, UVM_ALL_ON)
    `uvm_object_utils_end 

    function new(string name = "afvip_interrupt_sequence_item");
        super.new(name);   
    endfunction

endclass