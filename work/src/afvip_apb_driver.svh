class afvip_apb_driver extends uvm_driver #(afvip_apb_sequence_item);

    // UVM automation macros for general components
    `uvm_component_utils(afvip_apb_driver)

    // Declare virtual interface, pointer to RTL instance
    virtual afvip_apb_if virtual_apb_interface;

    // default constructor for driver sequence
    function new(string name = "afvip_apb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // Actual interface object is obtained by doing a get() call on uvm_config_db
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual afvip_apb_if)::get(this, "", 
            "virtual_apb_interface", virtual_apb_interface)) 
                `uvm_fatal("NOVIF", 
                            {"Virtual interface must be set for: ", 
                            get_full_name(), ".virtual_apb_interface"});
    endfunction : build_phase
    

    // translate transaction level objects into pin wiggles at the DUT interface
    virtual task run_phase(uvm_phase phase);
        // item requested from sequencer
        afvip_apb_sequence_item req_apb_item;
        super.run_phase(phase);    
        forever begin
            /* get next item from the sequencer. If none exists, then wait until
            next item is available -> this is blocking in nature */
            `uvm_info(get_type_name(), $sformatf("Waiting for data from sequencer"), UVM_MEDIUM);
            seq_item_port.get_next_item(req_apb_item);
            $display("%s", req_apb_item.sprint());
            // virtual_apb_interface.cb_driver.request <= 1;
            fork
                reset_signals(); // idle state                
                get_and_drive(); // move to access state             

            join
            // Finished driving given sequence item. Ready to request next item.
            seq_item_port.item_done();
        end 
    endtask : run_phase

    virtual protected task reset_signals(); 
        forever begin
            virtual_apb_interface.cb_driver.data <= 0;
            virtual_apb_interface.cb_driver.addr <= 0;
            virtual_apb_interface.cb_driver.psel <= 0;
            virtual_apb_interface.cb_driver.penable <= 0;
            virtual_apb_interface.cb_driver.pwrite <= 0;
            virtual_apb_interface.cb_driver.paddr <= 0;
            virtual_apb_interface.cb_driver.pwdata <= 0;
        end
    endtask

    virtual task get_and_drive();
        // read item 
        if (!req_apb_item.pwrite)
            begin
                virtual_apb_interface.psel <= 1;
                @ (virtual_apb_interface.cb_driver); // wait one clock cycle
                virtual_apb_interface.penable <= 1;
                    @(posedge virtual_apb_interface.clk iff (
                        (req_apb_item.psel) && (!req_apb_item.penable) && (req_apb_item.pready)));
                        begin
                            req_apb_item.paddr = virtual_apb_interface.paddr; // output
                            req_apb_item.prdata = virtual_apb_interface.prdata; // input
                            req_apb_item.pslverr = virtual_apb_interface.pslverr; // input
                        end
            end
        // write item 
        else if(req_apb_item.pwrite)
             begin
                virtual_apb_interface.psel <= 1;
                @(virtual_apb_interface.cb_driver); // wait one clock cycle
                virtual_apb_interface.penable <= 1;
                // write transfer process
                @(posedge virtual_apb_interface.clk iff (
                    (virtual_apb_interface.psel) && (virtual_apb_interface.penable) && (!virtual_apb_interface.pready)));      
                    begin
                        // signals remain unchanged while pready is low
                        virtual_apb_interface.paddr = req_apb_item.paddr;
                        virtual_apb_interface.pwrite <= 1;
                        virtual_apb_interface.psel <= 1;
                        virtual_apb_interface.penable <= 1;
                        virtual_apb_interface.pwdata = req_apb_item.pwdata;
                        virtual_apb_interface.pslverr = req_apb_item.pslverr;
                    end
                // end of transfer 
                @(posedge virtual_apb_interface.clk iff (
                    (virtual_apb_interface.psel) && (virtual_apb_interface.penable) && (virtual_apb_interface.pready)));        
                    begin
                        virtual_apb_interface.penable <= 0; // deassert penable
                        virtual_apb_interface.psel <= 0; // deassert psel
                    end
            end
        else 
            uvm_report_info(get_type_name(), $sformatf("No read or write using APB protocol"), UVM_MEDIUM);
    endtask

endclass
