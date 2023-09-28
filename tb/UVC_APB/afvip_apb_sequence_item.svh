class afvip_apb_sequence_item extends uvm_sequence_item;

    // declare variables of this sequence_item
    bit psel; 
    bit penable; 
    bit [15:0] paddr;
    bit pwrite; 
    bit [31:0] pwdata; 
    rand bit pready;
    rand bit [31:0] prdata;
    rand bit pslverr;

    `uvm_object_utils_begin(afvip_apb_sequence_item);
        `uvm_field_int(psel, UVM_ALL_ON)
        `uvm_field_int(penable, UVM_ALL_ON)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(pready, UVM_ALL_ON)
        `uvm_field_int(prdata, UVM_ALL_ON)
    `uvm_object_utils_end 

    function new(string name = "afvip_apb_sequence_item");
        super.new(name);
    endfunction : new

endclass

