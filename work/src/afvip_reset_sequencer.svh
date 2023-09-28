class afvip_reset_sequencer extends uvm_sequencer #(afvip_reset_sequence_item);

    `uvm_component_utils(afvip_reset_sequencer)

    function new(string name = "afvip_reset_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Variable: seq_item_export
    // Provides access to this sequencer's implementation of the sequencer interface
    uvm_seq_item_pull_imp #(afvip_reset_sequence_item) seq_item_export;
endclass : afvip_reset_sequencer