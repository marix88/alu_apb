/* configure the testbench, initiate the 
testbench components construction process 
and the stimulus driving */

class afvip_test extends uvm_test;

    afvip_environment environment;
    afvip_apb_sequence apb_sequence;
    afvip_reset_sequence reset_sequence;

    `uvm_component_utils(afvip_test)

    function new(string name = "afvip_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // build and instantiate environment
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        environment = afvip_environment::type_id::create("environment", this);
        phase.raise_objection(this);
    endfunction

    // build and instantiate sequence
    virtual task run_phase(uvm_phase phase);
        apb_sequence = afvip_apb_sequence::type_id::create("apb_sequence", this);
        reset_sequence = afvip_reset_sequence::type_id::create("reset_sequence", this);
        phase.raise_objection(this);
        #100;
        phase.drop_objection(this);

        // handle to the sequencer used where the parent sequence starts
        //apb_sequence.start(environment.apb_agent.apb_sequencer);         //trebuie dat start secventelor in phase.raise_objection
        //reset_sequence.start(environment.reset_agent.reset_sequencer);

        `uvm_info(get_type_name (), $sformat("First afvip test"), UVM_NONE);
        phase.drop_objection(this);
    endtask
endclass