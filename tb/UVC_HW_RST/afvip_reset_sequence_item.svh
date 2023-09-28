`timescale 1ns/1ps

class afvip_reset_sequence_item extends uvm_sequence_item;

    bit rst_n;

    `uvm_object_utils_begin(afvip_reset_sequence_item)
        `uvm_field_int(rst_n, UVM_ALL_ON)
    `uvm_object_utils_end 

    function new(string name = "afvip_reset_sequence_item");
        super.new(name);
    endfunction 

endclass : afvip_reset_sequence_item //className extends superClass