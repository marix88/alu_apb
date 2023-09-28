class afvip_reset_sequence extends uvm_sequence #(afvip_reset_sequence_item);

    `uvm_object_utils(afvip_reset_sequence)

    function new(string name = "afvip_reset_sequence");
        super.new(name);
    endfunction

    // generate and send sequence_item
    virtual task body(); 
        /* `uvm_do macro does the following:
         * 1 - creates instance of declared sequence item
         * 2 - wait for grant 
         * 3 - randomizes item
         * 4 - sends item to driver
         * 5 - wait for item done from driver
           6 - get response from driver */
           afvip_reset_sequence_item reset_sequence_item;
           `uvm_do(reset_sequence_item); 
        /*
        hw_reset_seq afvip_hw_reset_seq;

        // Call the required kind of reset sequence in test scenario
        afvip_hw_reset_seq.start(afvip_reset_sequencer);  
        */    
    endtask 

endclass