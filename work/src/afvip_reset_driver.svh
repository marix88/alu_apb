class afvip_reset_driver extends uvm_driver #(afvip_reset_sequence_item);

    // Declare item
    afvip_reset_sequence_item req_reset_item;

    // Declare virtual handle
    virtual afvip_reset_if virtual_reset_interface;

    // UVM automation macros for general components
    `uvm_component_utils(afvip_reset_driver)
   

    // event begin_record, end_record;

    function new(string name = "afvip_reset_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    // Actual interface object is obtained by doing a get() call on uvm_config_db
    virtual function void build_phase(uvm_phase phase);
        string inst_name;
        super.build_phase(phase);
        if(! uvm_config_db #(virtual afvip_reset_if)::get(this, "", 
            "virtual_reset_interface", virtual_reset_interface)) 
            `uvm_fatal("NOVIF", 
                        {"Virtual interface must be set for: ", 
                        get_full_name(), ".vif"});
    endfunction : build_phase

    // var: reset_time_ps
    // The length of time, in ps, that reset will stay active
    // rand int reset_time_ps;
    // reset is Asychronous Active LOW   
     task pre_reset_phase (uvm_phase phase); 
        phase.raise_objection(this); 
        // reset active 
        virtual_reset_interface.rst_n = 0; 
        # 10
        // reset inactive
        virtual_reset_interface.rst_n = 1;
        #1;  
        phase.drop_objection(this);  
    endtask: pre_reset_phase  
    
    // Base constraints
    /*
    constraint rst_cnstr { reset_time_ps inside { [1:1000000]}; }
    */

    virtual task reset_phase(uvm_phase phase);  
        phase.raise_objection(this);  
        virtual_reset_interface.rst_n <= 0;  
        virtual_reset_interface.rst_n <= 1;  
        phase.drop_objection(this); 
    endtask: reset_phase 
    
    event reset_driver;
    
    // translate transaction level objects into pin wiggles at the DUT interface
    virtual task run_phase(uvm_phase phase);
        forever begin
            // Get next item from the sequencer through the port (may block)
            seq_item_port.get_next_item(req_reset_item);
            // Execute the item
            // drive_item(req_reset_item);
            // Consume the request
            drive();
            seq_item_port.item_done();
        end
    endtask : run_phase

    task drive();
        if(virtual_apb_interface_cb.rst_n) begin
            @(virtual_apb_interface_cb.cb_driver);
            virtual_apb_interface_cb.cb_driver.rst_n <= req_apb_item.rst_n;
            virtual_apb_interface_cb.cb_driver.rst_n <= 1;
        end
        else begin
            @(virtual_apb_interface_cb.cb_driver);
            for(int i=0; i<=124; i=i+4) begin
                setup();
                @(virtual_apb_interface_cb.cb_driver);
                access();
                wait(virtual_apb_interface_cb.cb_driver.pready == 1);
            end
        end
    endtask : drive
     /*   
        // declare port used to request items from sequencer
        uvm_seq_item_pull_port #(afvip_reset_sequence_item) seq_item_port;
        super.run_phase(phase);
        fork
            reset_signals();
            record_tr();
        join
        
        forever begin
            @(posedge reset_vif.rst_n);

            `uvm_info(get_type_name(), $sformatf("Waiting for data from sequencer"), UVM_MEDIUM)
            
            // get next item from the sequencer through the port
            seq_item_port.get_next_item(req_reset_item);
            $display("%s", req_reset_item.sprint());
            vif.cb_driver.rst_n <= req_item.rst_n;
            fork
                drive_items();
            join_none
        end
        begin
            @(reset_driver);
            disable fork;
            cleanup();
        end
        */
/* task drive_item(input afvip_reset_sequence_item req_reset_item)
    // add logic here
endtask : drive_item */
endclass

   