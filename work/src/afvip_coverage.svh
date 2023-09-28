class afvip_coverage extends uvm_subscriber #(afvip_apb_sequence_item);
    
    `uvm_component_utils (afvip_coverage)

    // Variables
    afvip_apb_sequence_item apb_data_object;
    logic [31:0] _temppaddr, _temppwdata, _temprdata;

    // Covergroup for functional coverage
    covergroup apb_cg;
        /*
        psel: coverpoint apb_data_object.psel { bins psel = {1}; 
                                                illegal bins il_psel = {0};}
        pwrite: coverpoint apb_data_object.pwrite { bins pwrite[] = {0,1}; }
        pwdata: coverpoint apb_data_object.pwdata { bins pwdata[16] = {[0:32'hffffffff]}; }
        paddr: coverpoint apb_data_object.paddr { bins paddr[] = {[0:32'h0000001f]};
                                                  illegal bins il_paddr = default; }
        pready: coverpoint apb_data_object.pready { bins pready = {1};
                                                    illegal bins il_pready = {0}; }
        prdata: coverpoint _temprdata { bins prdata[16] = {[0:32'hffffffff]}; }
        pslverr: coverpoint apb_data_object.pslverr { bins pslverr[] = {0,1}; }
        pselxpwrite: cross psel, pwrite { ignore_bins ig_bins = binsof(psel) intersect {0}; }
        pselxpwritexpaddr: cross psel, pwrite, paddr { ignore_bins ig_bins = binsof(psel) intersect{0}; }
        */
    endgroup
    
    function void coverage_sample;
        for(int j = 0; j < 32; j++) begin
            _temprdata = apb_data_object.prdata[j];
            _temppwdata = apb_data_object.pwdata[j];
            _temppaddr = apb_data_object.paddr[j];
            apb_cg.sample();
        end
    endfunction : coverage_sample

    function new(string name, uvm_component parent);
        super.new(name, parent);
        apb_cg = new();
    endfunction : new

    function void write (T t);
        apb_data_object = t;
        coverage_sample();
    endfunction

    function void build_phase(uvm_phase phase);
        apb_data_object = new("coverage_apb_data_object");
    endfunction : build_phase
endclass