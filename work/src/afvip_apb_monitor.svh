class afvip_apb_monitor extends uvm_monitor;

    /* Declare virtual interface handle
    Actual interface object is later obtained by doing a get() call on uvm_config_db */
    virtual afvip_apb_if apb_vif;

    // Control checking in monitor and interface
    logic checks_enable = 1;  

    // Control coverage in monitor and interface
    logic coverage_enable = 1;

    // declare port through which monitor data gets to scoreboard
    uvm_analysis_port #(afvip_apb_sequence_item) apb_item_collected_port;

    event cov_transaction; 

    // apb_data_object is the signals/bus data from the DUT to be sent to other components
    afvip_apb_sequence_item apb_data_object;

    `uvm_component_utils_begin(afvip_apb_monitor)
        `uvm_field_int(checks_enable, UVM_ALL_ON)
        `uvm_field_int(coverage_enable, UVM_ALL_ON)
    `uvm_component_utils_end

    covergroup cov_trans @cov_transaction;
        // option.per_instance = 1;
        // Coverage bins definition
    endgroup : cov_trans

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cov_trans = new();
        cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
        apb_data_object = new();
        apb_item_collected_port = new("apb_item_collected_port", this);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Get virtual interface handle from the configuration DB
        if (! uvm_config_db #(virtual afvip_apb_if) :: get (this, "", "apb_vif", apb_vif)) begin
                `uvm_error (get_type_name (), "DUT apb interface not found")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        collect_transactions(); // collector task
    endtask : run_phase

    virtual protected task collect_transactions();
        /*
        wait(apb_vif.rst_n === 1);
        @(negedge apb_vif.rst_n);
        */
        forever begin
            @(posedge apb_vif.clk);
            // Collect data from the bus into apb_data_object
            apb_data_object.psel = apb_vif.psel;
            apb_data_object.penable = apb_vif.penable;
            apb_data_object.paddr = apb_vif.paddr;
            apb_data_object.pwrite = apb_vif.pwrite;
            apb_data_object.pwdata = apb_vif.pwdata;
            apb_data_object.pready = apb_vif.pready;
            apb_data_object.prdata = apb_vif.prdata;
            apb_data_object.pslverr = apb_vif.pslverr;

            if (checks_enable)
                perform_transfer_checks();
            if (coverage_enable)
                perform_transfer_coverage();
        
            assert(apb_data_object.randomize());

        // Send data object through the analysis port when data is available
        apb_item_collected_port.write(apb_data_object);
        `uvm_info(get_name(), $sformatf("Send value = %0h", apb_data_object.value), UVM_NONE);
        end 
    endtask : collect_transactions

    virtual protected function void perform_transfer_coverage();
        -> cov_transaction;
    endfunction : perform_transfer_coverage

    virtual protected function void perform_transfer_checks();
        // Perform data checks on the data collected (apb_data_object)
    endfunction : perform_transfer_checks

    // Function to check basic protocol specs
    virtual function void check_protocol();
        // If protocol checker is enabled, perform checks
        if (checks_enable)
        check_protocol();
    endfunction : check_protocol
  
endclass : afvip_apb_monitor