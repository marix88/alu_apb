class afvip_reset_agent extends uvm_agent;

    `uvm_component_utils(afvip_reset_agent)

    afvip_reset_monitor rst_monitor;
    afvip_reset_driver rst_driver;
    afvip_reset_sequencer rst_sequencer;

    // handle to the reset interface. Do I need it?
    // reset_cfg hw_reset_cfg;

    function new(string name = "afvip_reset_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        // build monitor
        rst_monitor = afvip_reset_monitor::type_id::create("rst_monitor", this);
        // if the requested agent is active build driver and sequencer
        if (get_is_active()) begin
            rst_sequencer = afvip_reset_sequencer::type_id::create("rst_sequencer", this);
            `uvm_info(get_name(), "is an active agent", UVM_LOW);
            rst_driver = afvip_reset_driver::type_id::create("rst_driver", this);
            `uvm_info(get_name(), "is an active agent", UVM_LOW);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        // if the agent is active, connect the driver to the sequencer
        if(get_is_active())
            rst_driver.seq_item_port.connect(rst_sequencer.seq_item_export);  
    endfunction

    /*
    virtual task pre_reset_phase (uvm_phase phase);
        if (rst_sequencer && rst_driver) begin
            rst_sequencer.stop_sequences();
            ->rst_driver.reset_driver;
        end
    endtask
    */
endclass

