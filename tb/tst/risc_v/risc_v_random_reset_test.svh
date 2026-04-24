class risc_v_random_reset_test extends risc_v_base_test;

    `uvm_component_utils(risc_v_random_reset_test)

    string my_name;

    typedef risc_v_random_reset_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_rand_reset_seq_t;
    risc_v_master_rand_reset_seq_t risc_v_master_rand_reset_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        my_name = "risc_v_random_reset_test";
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_report_info(my_name, "random reset test build phase");

        // Instantiate the sequence
        risc_v_master_rand_reset_seq = risc_v_master_rand_reset_seq_t::type_id::create("risc_v_master_rand_reset_seq", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
  
    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_report_info(my_name, "Running ...");

        uvm_test_done.set_drain_time(this, `DRAIN_TIME);
        phase.raise_objection(this, "Objection raised by risc_v_random_reset_test");
        
        // Start the sequence
        risc_v_master_rand_reset_seq.start(env_h.risc_v_master_agent_0.sequencer, null);

        phase.drop_objection(this, "Objection dropped by risc_v_random_reset_test");
    endtask

endclass
