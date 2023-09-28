class afvip_reset_sequence_item extends uvm_sequence_item;

    `uvm_object_utils_begin(afvip_reset_sequence_item)
        `uvm_field_int(rst_n, UVM_DEFAULT)
    `uvm_object_utils_end

    rand logic rst_n;

    // Factory registration is made by Vivado

    function new(string name = "");
        super.new(name);
    endfunction 
endclass : afvip_reset_sequence_item //className extends superClass