class afvip_apb_sequence_item extends uvm_sequence_item;

    // declare variables of this sequence_item
    rand logic psel; 
    rand logic penable; 
    rand logic [15:0] paddr;
    rand logic pwrite; 
    rand logic [31:0] pwdata; 
    logic pready;
    logic [31:0] prdata;
    logic pslverr;

    `uvm_object_utils_begin(afvip_apb_sequence_item);
        `uvm_field_int(psel, UVM_DEFAULT)
        `uvm_field_int(penable, UVM_DEFAULT)
        `uvm_field_int(paddr, UVM_DEFAULT)
        `uvm_field_int(pwrite, UVM_DEFAULT)
        `uvm_field_int(pwdata, UVM_DEFAULT)
        `uvm_field_int(pready, UVM_DEFAULT)
        `uvm_field_int(prdata, UVM_DEFAULT)
        `uvm_field_int(pslverr, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "afvip_apb_sequence_item");
        super.new(name);
    endfunction
    
endclass

