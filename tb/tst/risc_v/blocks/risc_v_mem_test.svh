
class risc_v_mem_test extends risc_v_base_test;
    `uvm_component_utils(risc_v_mem_test)
    string my_name;
    typedef risc_v_full_program_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_full_prog_seq_t;
    risc_v_master_full_prog_seq_t risc_v_master_full_prog_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        my_name = "risc_v_mem_test";
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        risc_v_master_full_prog_seq = risc_v_master_full_prog_seq_t::type_id::create("risc_v_master_full_prog_seq", this);
        uvm_config_db#(string)::set(null, "*", "instr_file", "../tests/mem_test.hex");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        risc_v_master_full_prog_seq.start(env_h.risc_v_master_agent_0.sequencer, null);
        phase.drop_objection(this);
    endtask
endclass
