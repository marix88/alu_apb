class afvip_interrupt_monitor extends uvm_monitor;
    `uvm_component_utils(afvip_interrupt_monitor)
    // Declare virtual interface handle
    virtual afvip_interrupt_if interrupt_vif;

    // Control checking in monitor and interface
    bit checks_enable = 1;

    // declare port through which monitor data gets to scoreboard
    uvm_analysis_port #(afvip_interrupt_sequence_item) interrupt_item_collected_port;

    // interrupt_data_object is the signals/bus data to be sent to other components
    //afvip_interrupt_sequence_item interrupt_data_object;

    function new(string name = "afvip_interrupt_monitor", uvm_component parent = null);
        super.new(name, parent);
        //interrupt_data_object = new();
        // Create an instance of the declared analysis port
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        interrupt_item_collected_port = new("interrupt_item_collected_port", this);
        // Get virtual interface handle from the configuration DB
        if (!uvm_config_db #(virtual afvip_interrupt_if) :: get (this, "", "interrupt_vif", interrupt_vif)) 
                `uvm_error (get_type_name (), "DUT interrupt interface not found")
    endfunction

    virtual task run_phase(uvm_phase phase);
        // placeholder to capture transaction info
        afvip_interrupt_sequence_item interrupt_data_object = afvip_interrupt_sequence_item::type_id::create("interrupt_data_object", this);
        forever begin
            @(posedge interrupt_vif.clk);
            interrupt_data_object.afvip_intr = interrupt_vif.afvip_intr;
            if (checks_enable)
                perform_transfer_checks();
            assert(interrupt_data_object.randomize());
            // Define the action to be taken when a packet is received via the declared port 
            interrupt_item_collected_port.write(interrupt_data_object);
            `uvm_info(get_name(), $sformatf("Send value = %0h", interrupt_data_object.value), UVM_NONE);
        end 
    endtask : run_phase

    /* virtual task collect_transactions();
        
    endtask : collect_transactions */

    virtual protected function void perform_transfer_checks();
        // Perform data checks on the data collected (apb_data_object)
    endfunction : perform_transfer_checks

    // Function to check basic protocol specs
    virtual function void check_protocol();
        // If protocol checker is enabled, perform checks
        if (checks_enable)
        check_protocol();
    endfunction : check_protocol
endclass