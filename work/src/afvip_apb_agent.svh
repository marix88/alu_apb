class afvip_apb_agent extends uvm_agent;

    `uvm_component_utils(afvip_apb_agent)

    // any component whose parent is set to null becomes a child of uvm_top
    function new(string name = "afvip_apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    afvip_apb_monitor apb_monitor;
    afvip_apb_driver apb_driver;
    afvip_apb_sequencer apb_sequencer;

    // declare instance of seq_item_port port used by driver to request items from the sequencer
    // seq_item_port apb_seq_port;
    // declare instance of seq_item_export port for apb sequencer
    // seq_item_export apb_seq_export;

    // declare port - get data to the monitor
    // uvm_analysis_port #(afvip_apb_sequence_item) data_object_collected_port;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        // build monitor
        apb_monitor = afvip_apb_monitor::type_id::create("apb_monitor", this);
        // if the requested agent is active build driver and sequencer
        if (get_is_active() == UVM_ACTIVE) begin
            apb_sequencer = afvip_apb_sequencer::type_id::create("apb_sequencer", this);
            `uvm_info(get_name(), "is an active agent", UVM_LOW);
            apb_driver = afvip_apb_driver::type_id::create("apb_driver", this);
        end
    endfunction : build_phase  


    virtual function void connect_phase(uvm_phase phase);
        // if the agent is active, connect the driver to the sequencer
        super.connect_phase(phase);
        if(get_is_active())
            apb_driver.apb_seq_port.connect(apb_sequencer.apb_seq_export);  
    endfunction
endclass : afvip_apb_agent