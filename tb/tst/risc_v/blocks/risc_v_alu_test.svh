
class risc_v_alu_test extends risc_v_base_test;

    `uvm_component_utils(risc_v_alu_test)

    string my_name;

    typedef risc_v_full_program_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_full_prog_seq_t;
    risc_v_master_full_prog_seq_t risc_v_master_full_prog_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        my_name = "risc_v_alu_test";
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_report_info(my_name, "ALU block test build phase");

        // Instantiate the sequence
        risc_v_master_full_prog_seq = risc_v_master_full_prog_seq_t::type_id::create("risc_v_master_full_prog_seq", this);
        
        // Use the ALU specific hex file
        uvm_config_db#(string)::set(null, "*", "instr_file", "../tests/alu_test.hex");
    endfunction

    task run_phase(uvm_phase phase);
        uvm_report_info(my_name, "Running ALU test...");
        phase.raise_objection(this);
        risc_v_master_full_prog_seq.start(env_h.risc_v_master_agent_0.sequencer, null);
        phase.drop_objection(this);
    endtask

endclass
