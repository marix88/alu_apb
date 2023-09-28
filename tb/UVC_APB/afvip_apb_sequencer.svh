class afvip_apb_sequencer extends uvm_sequencer #(afvip_apb_sequence_item);

    `uvm_component_utils(afvip_apb_sequencer)

    function new(string name = "afvip_apb_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Variable: seq_item_export
    // Provides access to this sequencer's implementation of the sequencer interface
    // uvm_seq_item_export #(afvip_apb_sequence_item) seq_item_export;

endclass