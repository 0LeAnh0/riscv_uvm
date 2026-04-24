class risc_v_demo_test extends risc_v_base_test;

    `uvm_component_utils(risc_v_demo_test)

    string my_name;



    typedef risc_v_demo_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_demo_seq_t;
    risc_v_master_demo_seq_t risc_v_master_demo_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        my_name = "risc_v_demo_test";
    endfunction

    function void build_phase(uvm_phase phase);
    //risc__v_cfg test_cfg;
    string demo_seq_name;
    //risc_v_master_seq_cfg risc_in_demo_seq_cfg_h;
    integer cmd_num_write;
    
    super.build_phase(phase);
    uvm_report_info(my_name,"demo build phase");

    demo_seq_name = "risc_v_master_demo_seq_name";
    
    // Instantiate the sequence
    risc_v_master_demo_seq = risc_v_master_demo_seq_t::type_id::create(demo_seq_name, this);

    //
    // Need to pass in the number of writes (num_write) to the sequence.
    // First, need to get a handle to the TB_CONFIG 
    //
    //if (!uvm_config_db#(risc_cfg)::get(this,"","TB_CONFIG", test_cfg))
      //`uvm_error("get_config_db error","risc_base_test")
    
    //
    // Optionally set up test verbosity configuration
    //
    //test_cfg.verbosity_control_arr["monitor"] = IS_ENABLE;
    //test_cfg.verbosity_control_arr["driver"] = IS_ENABLE;
    //test_cfg.verbosity_control_arr["uvm_top"] = IS_ENABLE;

    //
    // Next, create a sequence config and assign the num_write in the sequence config to
    // the desired value. Then save the sequence config in the sequence config array in
    // the TB_CONFIG
    //
    //risc_v_master_demo_seq_cfg_h = risc_in_seq_cfg::type_id::create("risc_in_demo_sequence_cfg");
    //assert(risc_in_demo_seq_cfg_h.randomize());
    //if ($value$plusargs("NUM_WRITE=%d", cmd_num_write))
    //    risc_in_demo_seq_cfg_h.num_write = cmd_num_write;
    //else
    //    risc_in_demo_seq_cfg_h.num_write = 4;    
    //test_cfg.risc_in_seq_cfg_arr[demo_seq_name] = risc_in_demo_seq_cfg_h;

endfunction


 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction

    task run_phase(uvm_phase phase);
    uvm_report_info(my_name,"Running ...");

    uvm_test_done.set_drain_time(this, `DRAIN_TIME);
    phase.raise_objection(this,"Objection raised by risc_v_demo_test");
    
    // Start the sequence
    risc_v_master_demo_seq.start(env_h.risc_v_master_agent_0.sequencer,null);

    phase.drop_objection(this,"Objection dropped by risc_v_demo_test");
endtask


endclass
