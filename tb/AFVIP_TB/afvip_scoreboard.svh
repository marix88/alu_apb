// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_scoreboard
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Compare and check result
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_interrupt)
`uvm_analysis_imp_decl(_reset)

// Check data integrity
class afvip_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(afvip_scoreboard)

  function new(string name = "afvip_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new
    
    afvip_apb_sequence_item apb_sequence_item;
    afvip_interrupt_sequence_item interrupt_sequence_item;
    afvip_reset_sequence_item reset_sequence_item;

    // Declare variables
    bit [2:0] opcode;           // Operation code
    bit [4:0] rs0;              // Source register 0
    bit [4:0] rs1;              // Source register 1
    bit [7:0] imm;              // Immediate value
    bit [4:0] dst;              // Destination reg where the item's pwdata op result is stored
    bit [31:0] mem_read [64];   // [size] var_name [depth] 
    bit [31:0] mem_write [64];  // [size] var_name [depth]

    // Declare and create actual TLM Analysis Ports to receive data objects from DUT
    uvm_analysis_imp_apb #(afvip_apb_sequence_item, afvip_scoreboard) apb_item_collected_export; 
    uvm_analysis_imp_interrupt #(afvip_interrupt_sequence_item, afvip_scoreboard) interrupt_item_collected_export;
    uvm_analysis_imp_reset #(afvip_reset_sequence_item, afvip_scoreboard) reset_item_collected_export;

    // Instantiate analysis ports
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      apb_item_collected_export = new("apb_item_collected_export", this);
      interrupt_item_collected_export = new("interrupt_item_collected_export", this);
      reset_item_collected_export = new("reset_item_collected_export", this);     
    endfunction : build_phase

  // Get items and define the action to be taken when items are received via the declared ports
  // Run checker and predict result
  virtual function void write_apb (afvip_apb_sequence_item apb_sequence_item);
    if (apb_sequence_item.paddr == 16'h80) begin
    // Assign values to declared variables, map pwdata registers
    opcode = apb_sequence_item.pwdata [2:0];    // Operation code
    rs0    = apb_sequence_item.pwdata [7:3];    // Source register 0
    rs1    = apb_sequence_item.pwdata [12:8];   // Source register 1
    imm    = apb_sequence_item.pwdata [31:24];  // Immediate value
    dst    = apb_sequence_item.pwdata [20:16];  // Reg where the item's pwdata op result is stored
    
    // Control register -> start instructions and save result to mem_write
    if(opcode == 0) begin 
      dst = rs0 + imm;
      mem_write[apb_sequence_item.paddr/4] = apb_sequence_item.pwdata;
      `uvm_info ("opcode0_dst", $sformatf("Expected result opcode0: %0d", dst), UVM_MEDIUM)
      `uvm_info ("opcode0_mem_write", $sformatf("Received result opcode0: %0d", mem_write[apb_sequence_item.paddr/4]), UVM_MEDIUM)
    end  
    
    if(opcode == 1) begin 
        dst = rs0 * imm;
        mem_write[apb_sequence_item.paddr/4] = apb_sequence_item.pwdata;
        `uvm_info ("opcode1_dst", $sformatf("Expected result opcode1: %0d", dst), UVM_MEDIUM)
        `uvm_info ("opcode1_mem_write", $sformatf("Received result opcode1: %0d", mem_write[apb_sequence_item.paddr/4]), UVM_MEDIUM)
      end
      if(opcode == 2) begin 
        dst = rs0 + rs1;
        mem_write[apb_sequence_item.paddr/4] = apb_sequence_item.pwdata;
        `uvm_info ("opcode2_dst", $sformatf("Expected result opcode2: %0d", dst), UVM_MEDIUM)
        `uvm_info ("opcode2_mem_write", $sformatf("Received result opcode2: %0d", mem_write[apb_sequence_item.paddr/4]), UVM_MEDIUM)
      end
      if(opcode == 3) begin 
        dst = rs0 * rs1;
        mem_write[apb_sequence_item.paddr/4] = apb_sequence_item.pwdata;
        `uvm_info ("opcode3_dst", $sformatf("Expected result opcode3: %0d", dst), UVM_MEDIUM)
        `uvm_info ("opcode3_mem_write", $sformatf("Received result opcode3: %0d", mem_write[apb_sequence_item.paddr/4]), UVM_MEDIUM)
      end
      if(opcode == 4) begin 
        dst = (rs0 * rs1) + imm;
        mem_write[apb_sequence_item.paddr/4] = apb_sequence_item.pwdata;
        `uvm_info ("opcode4_dst", $sformatf("Expected result opcode4: %0d", dst), UVM_MEDIUM)
        `uvm_info ("opcode4_mem_write", $sformatf("Received result opcode4: %0d", mem_write[apb_sequence_item.paddr/4]), UVM_MEDIUM)
      end 
    end

    // When data is written and paddr matches a working register
    if((apb_sequence_item.pwrite == 1) && (apb_sequence_item.paddr <= 124)) begin   
      // Save item's pwdata to scoreboard's mem
      mem_write[apb_sequence_item.paddr/4] = apb_sequence_item.pwdata;  
      `uvm_info ("mem_write", $sformatf("mem_write saved to mem: %0d", mem_write[apb_sequence_item.paddr/4]), UVM_MEDIUM)
    end

    // Save item's prdata to scoreboard's internal mem
    
    mem_read[apb_sequence_item.paddr/4] = apb_sequence_item.prdata; 
    
    if((apb_sequence_item.pwrite == 0) && (apb_sequence_item.paddr == 8)) begin
      apb_sequence_item.print();
    end

    /*
    // Read data in the working registers and save read data to mem
    if((apb_sequence_item.pwrite == 0) && (apb_sequence_item.paddr <= 124)) begin
      // Go through the 32 working registers
      // for(int i=0; i < 32; i++) begin
        // Save read data to mem
        mem_read[apb_sequence_item.paddr/4] = apb_sequence_item.prdata;
        `uvm_info ("mem_read", $sformatf("mem_read: %h", mem_read[apb_sequence_item.paddr/4]), UVM_MEDIUM)
      end
    */
    // Compare expected data to received data
    if(apb_sequence_item.pwrite == 0) begin
      if((mem_read[apb_sequence_item.paddr/4] == apb_sequence_item.prdata))
        `uvm_info(get_type_name(), $sformatf("Expected result is the received result"), UVM_MEDIUM)
        apb_sequence_item.print();
      end
  endfunction : write_apb

  virtual function void write_interrupt(afvip_interrupt_sequence_item interrupt_sequence_item);
    // `uvm_info ("write_interrupt", $sformatf("Interrupt data received: %0d", interrupt_sequence_item), UVM_MEDIUM)
  endfunction : write_interrupt


  virtual function void write_reset(afvip_reset_sequence_item reset_sequence_item);
      // `uvm_info ("write_reset", $sformatf("Reset data received: %0d", reset_sequence_item), UVM_MEDIUM)
  endfunction : write_reset

  // Let it empty
  virtual task run_phase(uvm_phase phase);

  endtask 

endclass : afvip_scoreboard

