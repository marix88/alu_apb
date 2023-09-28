
// ---------------------------------------------------------------------------------------------------------------------
// Module name: afvip_test
// HDL        : UVM
// Author     : Maricela Potoc
// Description: Various tests for the DUT
// Date       : 31 August, 2023
// ---------------------------------------------------------------------------------------------------------------------

/* configure the testbench, initiate the 
testbench components construction process 
and the stimulus driving */
`timescale 1ns/1ps

class afvip_base_test extends uvm_test;
    `uvm_component_utils(afvip_base_test)

    function new(string name = "afvip_base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task main_phase(uvm_phase phase);
    endtask

endclass : afvip_base_test

// Write all registers, read all registers
class afvip_test_write_all_read_all extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_sequence_write_all_read_all apb_sequence_write_all_read_all;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_test_write_all_read_all)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_test_write_all_read_all", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_sequence_write_all_read_all = afvip_apb_sequence_write_all_read_all::type_id::create("apb_sequence_write_all_read_all", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_sequence_write_all_read_all.start(environment.apb_agent.apb_sequencer);         //trebuie dat start secventelor in phase.raise_objection

        `uvm_info(get_type_name (), $sformatf("1st afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_test_write_all_read_all

// Write one register, read all registers
class afvip_test_write_one_read_all extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_sequence_write_one_read_all apb_sequence_write_one_read_all;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_test_write_one_read_all)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_test_write_one_read_all", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_sequence_write_one_read_all = afvip_apb_sequence_write_one_read_all::type_id::create("apb_sequence_write_one_read_all", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_sequence_write_one_read_all.start(environment.apb_agent.apb_sequencer);         //trebuie dat start secventelor in phase.raise_objection

        `uvm_info(get_type_name (), $sformatf("2nd afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_test_write_one_read_all

// Calculate operation opcode0, write and read result in dst
class afvip_apb_opcode0_test extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_seq_opcode_0 apb_seq_opcode_0;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_apb_opcode0_test)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_apb_opcode0_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_seq_opcode_0 =  afvip_apb_seq_opcode_0::type_id::create("apb_seq_opcode_0", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_seq_opcode_0.start(environment.apb_agent.apb_sequencer); 
         `uvm_info(get_type_name (), $sformatf("3rd afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_apb_opcode0_test

class afvip_apb_opcode1_test extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_seq_opcode_1 apb_seq_opcode_1;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_apb_opcode1_test)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_apb_opcode1_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_seq_opcode_1 =  afvip_apb_seq_opcode_1::type_id::create("apb_seq_opcode_1", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_seq_opcode_1.start(environment.apb_agent.apb_sequencer); 
         `uvm_info(get_type_name (), $sformatf("4th afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_apb_opcode1_test

class afvip_apb_opcode2_test extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_seq_opcode_2 apb_seq_opcode_2;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_apb_opcode2_test)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_apb_opcode2_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_seq_opcode_2 =  afvip_apb_seq_opcode_2::type_id::create("apb_seq_opcode_2", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_seq_opcode_2.start(environment.apb_agent.apb_sequencer); 
         `uvm_info(get_type_name (), $sformatf("5th afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_apb_opcode2_test

class afvip_apb_opcode3_test extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_seq_opcode_3 apb_seq_opcode_3;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_apb_opcode3_test)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_apb_opcode3_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_seq_opcode_3 =  afvip_apb_seq_opcode_3::type_id::create("apb_seq_opcode_3", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_seq_opcode_3.start(environment.apb_agent.apb_sequencer); 
         `uvm_info(get_type_name (), $sformatf("6th afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_apb_opcode3_test

class afvip_apb_opcode4_test extends afvip_base_test;

    afvip_environment environment;
    afvip_apb_seq_opcode_4 apb_seq_opcode_4;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_apb_opcode4_test)

    // Virtual interface handles
    virtual afvip_apb_if apb_vif;
    virtual afvip_interrupt_if interrupt_vif;
    virtual afvip_reset_if reset_vif;

    function new(string name = "afvip_apb_opcode4_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Build and instantiate environment
    // Get virtual interfaces from afvip_top
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        if (!uvm_config_db#(virtual afvip_apb_if)::get(this, "", "apb_vif", apb_vif))
        `uvm_fatal("NOVIF", "Virtual apb interface not found")
        if (!uvm_config_db#(virtual afvip_interrupt_if)::get(this, "", "interrupt_vif", interrupt_vif))
        `uvm_fatal("NOVIF", "Virtual interrupt interface not found")
        if (!uvm_config_db#(virtual afvip_reset_if)::get(this, "", "reset_vif", reset_vif))
        `uvm_fatal("NOVIF", "Virtual reset interface not found")
        // phase.raise_objection(this);
    endfunction

    // Main phase
    task main_phase(uvm_phase phase);
        // Set virtual interface in config_db
        uvm_config_db#(virtual afvip_apb_if)::set(this, "*", "apb_vif", apb_vif);
        uvm_config_db#(virtual afvip_interrupt_if)::set(this, "*", "interrupt_vif", interrupt_vif);
        uvm_config_db#(virtual afvip_reset_if)::set(this, "*", "reset_vif", reset_vif);
    endtask

    // Build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_seq_opcode_4 =  afvip_apb_seq_opcode_4::type_id::create("apb_seq_opcode_4", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        // handle to the sequencer used where the parent sequence starts
         reset_sequence.start(environment.reset_agent.reset_sequencer);
         apb_seq_opcode_4.start(environment.apb_agent.apb_sequencer); 
         `uvm_info(get_type_name (), $sformatf("7th afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass : afvip_apb_opcode4_test