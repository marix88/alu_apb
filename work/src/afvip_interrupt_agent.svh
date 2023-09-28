class afvip_interrupt_agent extends uvm_agent;

    `uvm_component_utils (afvip_interrupt_agent)

    afvip_interrupt_monitor interrupt_monitor;

    function new(string name = "afvip_interrupt_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase (uvm_phase phase);
        interrupt_monitor = afvip_interrupt_monitor::type_id::create("interrupt_monitor", this);
    endfunction

endclass