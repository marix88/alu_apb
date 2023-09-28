class afvip_base_apb_sequence extends uvm_sequence;

    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_base_apb_sequence)

    // constructor
    function new(string name = "afvip_base_apb_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
    endtask

endclass : afvip_base_apb_sequence

// Write all registers, read all registers
class afvip_apb_sequence_write_all_read_all extends afvip_base_apb_sequence;

    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_sequence_write_all_read_all)

    // constructor
    function new(string name = "afvip_apb_sequence_write_all_read_all");
        super.new(name);
    endfunction
    
    virtual task body();
        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");
        
        // i is the internal address that I multiply by 4 to get the APB address

        // Write all work registers
        for (int i = 0; i < 32; i++) begin  
            start_item(apb_sequence_item);      
                apb_sequence_item.paddr = i * 4;
                apb_sequence_item.pwrite = 1; 
                apb_sequence_item.pwdata = 32'd3;        
                `uvm_info ("apb_sequence_item", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
            finish_item(apb_sequence_item);
        end    

        // Read all work registers
        for (int i = 0; i < 32; i++) begin
            start_item(apb_sequence_item);
                apb_sequence_item.paddr = i * 4;    // Internal address -> APB address
                apb_sequence_item.pwrite = 0;       // Read access
                apb_sequence_item.pwdata = 0;       // No pwdata
                `uvm_info ("apb_sequence_item", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
            finish_item(apb_sequence_item);         // Item sent to the driver via sequencer
        end
    endtask
endclass : afvip_apb_sequence_write_all_read_all

// Write one register, read all registers
class afvip_apb_sequence_write_one_read_all extends afvip_base_apb_sequence;
    
    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_sequence_write_one_read_all)

    // constructor
    function new(string name = "afvip_apb_sequence_write_one_read_all");
        super.new(name);
    endfunction : new
    
    // Drive the stimulus to the driver
    virtual task body();
        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");

        // Write one register
        start_item(apb_sequence_item);              // Initiate operation to send item to the driver 
            apb_sequence_item.paddr  = 16'h18;      // APB address
            apb_sequence_item.pwrite = 1;           // Write access  
            apb_sequence_item.pwdata = 32'd12;      // Write 12 
            `uvm_info ("apb_sequence_item", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
        finish_item(apb_sequence_item);             // Item sent to the driver via sequencer

        // Read all work registers
        for (int i = 0; i < 32; i++) begin
            start_item(apb_sequence_item);          // Initiate operation of an item, send item to the driver 
                apb_sequence_item.paddr = i * 4;    // Internal address -> APB address    
                apb_sequence_item.pwrite = 0;       // Read access
                apb_sequence_item.pwdata = 0;       // No pwdata
                `uvm_info ("apb_sequence_item", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
            finish_item(apb_sequence_item);         // Finished the instruction execution
        end
    endtask

endclass : afvip_apb_sequence_write_one_read_all

// Calculate operation opcode0, write and read result in dst
class afvip_apb_seq_opcode_0 extends afvip_base_apb_sequence;

    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_seq_opcode_0)

    // constructor
    function new(string name = "afvip_apb_seq_opcode_0");
        super.new(name);
    endfunction
    
    virtual task body();
        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");

        // Configure reg[00], rs0
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h00;         // rs0 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd4;         // Write 4
        finish_item(apb_sequence_item);

        // Configure reg[01], rs1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h04;         // rs1 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd3;         // Write 5
        finish_item(apb_sequence_item);

        // Instruction for opcode0 configuration
        start_item(apb_sequence_item);
            apb_sequence_item.paddr  = 16'h80;        // APB address, h80 - Configuration instruction
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata [2:0] = 3'd0;    // opcode0: dst = rs0+imm
            apb_sequence_item.pwdata [7:3] = 32'd0;   // rs0 reg name
            apb_sequence_item.pwdata [12:8] = 32'd1;  // rs1 reg name
            apb_sequence_item.pwdata [20:16] = 32'd2; // dst reg name
            apb_sequence_item.pwdata [31:24] = 32'd3; // imm reg value
            `uvm_info ("apb_sequence_item_opcode0", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
        finish_item(apb_sequence_item);

        // Sequence of steps after instruction configuration:
        // 1) Instruction start; 
        // 2) Read interrupt status; 
        // 3) Clear interrupt.
        
        // Instruction 0 start
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h8C;         // APB address, h8C - Control Register
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd1;         // Write 1
        finish_item(apb_sequence_item);

        // APB address: 0x0084, name: Interrupt status, APB access: Read only.
        // Interrupt happens when:
        // 1) the module finished the instruction execution OR
        // 2) the module is wrong configured (unsupported opcode).
        
        // Read interrupt status
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h84;         // APB address, Interrupt status, read only access
            apb_sequence_item.pwrite = 0;             // Read interrupt status
        finish_item(apb_sequence_item);

        // Interrupt clear status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h88;         // APB address, Interrupt Clear
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Finished instruction & interruption
        finish_item(apb_sequence_item);

        // Read dst, reg[02]
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h08;         // dst APB address
            apb_sequence_item.pwrite = 0;             // Read operation result. Expected result: 7.
        finish_item(apb_sequence_item);
    endtask
endclass : afvip_apb_seq_opcode_0   

class afvip_apb_seq_opcode_1 extends afvip_base_apb_sequence;
    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_seq_opcode_1)

    // constructor
    function new(string name = "afvip_apb_seq_opcode_1");
        super.new(name);
    endfunction
    
    virtual task body();

        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");

        // reg[03], rs0
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h0C;         // rs0 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd4;         // Write 4
        finish_item(apb_sequence_item);

        // reg[04], rs1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h10;         // rs1 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd5;         // Write 3
        finish_item(apb_sequence_item);

        // Instruction 1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr  = 16'h80;        // APB address, Configuration instruction
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata [2:0] = 3'd1;    // opcode1: dst = rs0*imm
            apb_sequence_item.pwdata [7:3] = 32'd3;   // rs0 reg name
            apb_sequence_item.pwdata [12:8] = 32'd4;  // rs1 reg name
            apb_sequence_item.pwdata [20:16] = 32'd5; // dst reg name
            apb_sequence_item.pwdata [31:24] = 32'd6; // imm reg value
            `uvm_info ("apb_sequence_item_opcode1", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
        finish_item(apb_sequence_item);
    
        // Instruction start 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h8C;         // APB address, Control Register
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd1;         // Write 1
        finish_item(apb_sequence_item);

        // Interrupt status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h84;         // APB address, Interrupt status
            apb_sequence_item.pwrite = 0;             // Read Interrupt status
        finish_item(apb_sequence_item);

        // Interrupt clear status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h88;         // APB address, Interrupt Clear
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Finished instruction & interruption
        finish_item(apb_sequence_item);

        // Read dst, reg[05]
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h14;         // dst APB address
            apb_sequence_item.pwrite = 0;             // Read operation result. Expected result: 0x0018.
        finish_item(apb_sequence_item);
    endtask 

endclass : afvip_apb_seq_opcode_1  

class afvip_apb_seq_opcode_2 extends afvip_base_apb_sequence;
    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_seq_opcode_2)

    // constructor
    function new(string name = "afvip_apb_seq_opcode_2");
        super.new(name);
    endfunction
    
    virtual task body();

        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");

        // reg[06], rs0
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h18;         // rs0 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd3;         // Write 3
        finish_item(apb_sequence_item);

        // reg[07], rs1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h1C;         // rs1 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd4;         // Write 4
        finish_item(apb_sequence_item);

        // Instruction 1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr  = 16'h80;        // APB address, Configuration instruction
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata [2:0] = 3'd2;    // opcode2: dst = rs0+rs1
            apb_sequence_item.pwdata [7:3] = 32'd6;   // rs0 reg name
            apb_sequence_item.pwdata [12:8] = 32'd7;  // rs1 reg name
            apb_sequence_item.pwdata [20:16] = 32'd8; // dst reg name
            apb_sequence_item.pwdata [31:24] = 32'd5; // imm reg value
            `uvm_info ("apb_sequence_item_opcode2", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
        finish_item(apb_sequence_item);
    
        // Instruction start 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h8C;         // APB address, Control Register
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd1;         // Write 1
        finish_item(apb_sequence_item);

        // Interrupt status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h84;         // APB address, Interrupt status
            apb_sequence_item.pwrite = 0;             // Read Interrupt status
        finish_item(apb_sequence_item);

        // Interrupt clear status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h88;         // APB address, Interrupt Clear
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Finished instruction & interruption
        finish_item(apb_sequence_item);

        // Read dst, reg[08]
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h20;         // dst APB address
            apb_sequence_item.pwrite = 0;             // Read operation result. Expected result: 3.
        finish_item(apb_sequence_item);
    endtask 

endclass : afvip_apb_seq_opcode_2 

class afvip_apb_seq_opcode_3 extends afvip_base_apb_sequence;
    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_seq_opcode_3)

    // constructor
    function new(string name = "afvip_apb_seq_opcode_3");
        super.new(name);
    endfunction
    
    virtual task body();

        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");

        // reg[09], rs0
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h24;         // rs0 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd4;         // Write 4
        finish_item(apb_sequence_item);

        // reg[10], rs1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h28;         // rs1 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Write 2
        finish_item(apb_sequence_item);

        // Instruction 1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr  = 16'h80;        // APB address, Configuration instruction
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata [2:0] = 3'd3;    // opcode3: dst = rs0*rs1
            apb_sequence_item.pwdata [7:3] = 32'd9;   // rs0 reg name
            apb_sequence_item.pwdata [12:8] = 32'd10;  // rs1 reg name
            apb_sequence_item.pwdata [20:16] = 32'd11; // dst reg name
            apb_sequence_item.pwdata [31:24] = 32'd5; // imm reg value
            `uvm_info ("apb_sequence_item_opcode3", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
        finish_item(apb_sequence_item);
    
        // Instruction start 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h8C;         // APB address, Control Register
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd1;         // Write 1
        finish_item(apb_sequence_item);

        // Interrupt status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h84;         // APB address, Interrupt status
            apb_sequence_item.pwrite = 0;             // Read Interrupt status
        finish_item(apb_sequence_item);

        // Interrupt clear status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h88;         // APB address, Interrupt Clear
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Finished instruction & interruption
        finish_item(apb_sequence_item);

        // Read dst, reg[11]
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h2C;         // dst APB address
            apb_sequence_item.pwrite = 0;             // Read operation result. Expected result: 8.
        finish_item(apb_sequence_item);
    endtask 

endclass : afvip_apb_seq_opcode_3  

class afvip_apb_seq_opcode_4 extends afvip_base_apb_sequence;
    // Register with the factory using object_utils because it's a transaction item
    `uvm_object_utils(afvip_apb_seq_opcode_4)

    // constructor
    function new(string name = "afvip_apb_seq_opcode_4");
        super.new(name);
    endfunction
    
    virtual task body();

        afvip_apb_sequence_item apb_sequence_item;
        apb_sequence_item = afvip_apb_sequence_item::type_id::create("apb_sequence_item");

        // reg[12], rs0
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h30;         // rs0 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd4;         // Write 4
        finish_item(apb_sequence_item);

        // reg[13], rs1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h34;         // rs1 APB address
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Write 2
        finish_item(apb_sequence_item);

        // Instruction 1
        start_item(apb_sequence_item);
            apb_sequence_item.paddr  = 16'h80;        // APB address, Configuration instruction
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata [2:0] = 3'd4;    // opcode4: dst = (rs0*rs1)+imm
            apb_sequence_item.pwdata [7:3] = 32'd12;   // rs0 reg name
            apb_sequence_item.pwdata [12:8] = 32'd13;  // rs1 reg name
            apb_sequence_item.pwdata [20:16] = 32'd14; // dst reg name
            apb_sequence_item.pwdata [31:24] = 32'd1; // imm reg value
            `uvm_info ("apb_sequence_item_opcode4", $sformatf ("Starting body of %s", this.get_name()), UVM_MEDIUM) 
        finish_item(apb_sequence_item);
    
        // Instruction start 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h8C;         // APB address, Control Register
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd1;         // Write 1
        finish_item(apb_sequence_item);

        // Interrupt status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h84;         // APB address, Interrupt status
            apb_sequence_item.pwrite = 0;             // Read Interrupt status
        finish_item(apb_sequence_item);

        // Interrupt clear status 
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h88;         // APB address, Interrupt Clear
            apb_sequence_item.pwrite = 1;             // Write access
            apb_sequence_item.pwdata = 32'd2;         // Finished instruction & interruption
        finish_item(apb_sequence_item);

        // Read dst, reg[14]
        start_item(apb_sequence_item);
            apb_sequence_item.paddr = 16'h38;         // dst APB address
            apb_sequence_item.pwrite = 0;             // Read operation result. Expected result: 9.
        finish_item(apb_sequence_item);
    endtask 
endclass : afvip_apb_seq_opcode_4  

