class afvip_interrupt_sequence_item extends uvm_sequence_item;

    rand logic afvip_intr;

    // Factory registration is made by Vivado

    `uvm_object_utils_begin(afvip_interrupt_sequence_item)
        `uvm_field_int(afvip_intr, UVM_DEFAULT)
    `uvm_object_utils_end
    
    function new(string name = "");
        super.new(name);   
    endfunction

endclass