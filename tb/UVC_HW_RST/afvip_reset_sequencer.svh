`timescale 1ns/1ps

class afvip_reset_sequencer extends uvm_sequencer #(afvip_reset_sequence_item);

    `uvm_component_utils(afvip_reset_sequencer)

    function new(string name = "afvip_reset_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass : afvip_reset_sequencer