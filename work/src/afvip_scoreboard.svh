`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_interrupt)
`uvm_analysis_imp_decl(_reset)

// check data integrity
class afvip_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(afvip_scoreboard)

    // Associative array to store write data
    // bit[31:0] mem [bit[9:0]];
  int disable_scoreboard;

    // Declare and create actual TLM Analysis Ports to receive data objects from DUT
    uvm_analysis_imp_apb #(afvip_apb_sequence_item, afvip_scoreboard) apb_item_collected_export; 
    uvm_analysis_imp_interrupt #(afvip_interrupt_sequence_item, afvip_scoreboard) interrupt_item_collected_export;
    uvm_analysis_imp_reset #(afvip_reset_sequence_item, afvip_scoreboard) reset_item_collected_export;

    function new(string name = "afvip_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // instantiate the analysis port
    virtual function void build_phase(uvm_phase phase);
      apb_item_collected_export = new("apb_item_collected_export", this);
      interrupt_item_collected_export = new("interrupt_item_collected_export", this);
      reset_item_collected_export = new("reset_item_collected_export", this);     
    endfunction : build_phase


  /* Define other functions and tasks that operate on the data and call them
     This is the main task that consumes simulation time in UVM 
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    forever begin
      // get the declared sequence item
      apb_item_collected_export.get(apb_data_object);
      `uvm_info(get_type_name(), $sformatf("Received value = %0h", apb_data_object), UVM_NONE);
      // process_data(apb_data_object)
      interrupt_item_collected_export.get(interrupt_data_object);
      `uvm_info(get_type_name(), $sformatf("Received value = %0h", interrupt_data_object), UVM_NONE);
      reset_item_collected_export.get(reset_data_object);
      `uvm_info(get_type_name(), $sformatf("Received value = %0h", reset_data_object), UVM_NONE);
    end
    @(end_of_simulation);
    phase.drop_objection(this);
  endtask  
*/
  // Define the action to be taken when a packet is received via the declared port
  virtual function void write_apb(afvip_apb_sequence_item apb_data_object);
    if(!disable_scoreboard)
      memory_verify(apb_data_object); 
      `uvm_info ("write", $sformatf("Data received = 0x%0h", apb_data_object), UVM_MEDIUM);
  endfunction : write_apb

  virtual function void write_interrupt(afvip_interrupt_sequence_item interrupt_data_object);
    if(!disable_scoreboard)
      memory_verify(interrupt_data_object);
      `uvm_info ("write", $sformatf("Data received = 0x%0h", interrupt_data_object), UVM_MEDIUM);
  endfunction : write_interrupt

  virtual function void write_reset(afvip_reset_sequence_item reset_data_object);
    if(!disable_scoreboard)
      memory_verify(reset_data_object);
      `uvm_info ("write", $sformatf("Data received = 0x%0h", reset_data_object), UVM_MEDIUM);
  endfunction : write_reset

  // Clear expected upon reset
  virtual task pre_reset_phase (uvm_phase phase);
    apb_data_object.delete();
    interrupt_data_object.delete();
  endtask
endclass

