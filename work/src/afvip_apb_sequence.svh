class afvip_apb_sequence extends uvm_sequence #(afvip_apb_sequence_item);

    `uvm_object_utils(afvip_apb_sequence)

    // constructor
    function new(string name = "afvip_apb_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        afvip_apb_sequence_item apb_sequence_item;
        /* `uvm_do macro does the following:
         * 1 - creates instance of declared sequence item
         * 2 - wait for grant 
         * 3 - randomizes item
         * 4 - sends item to driver
         * 5 - wait for item done from driver
           6 - get response from driver */
        `uvm_do(apb_sequence_item); 
    endtask
endclass