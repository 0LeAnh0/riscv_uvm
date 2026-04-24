
class risc_v_branch_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_branch_sb)
  uvm_analysis_imp #(risc_v_tlm, risc_v_branch_sb) item_export;
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_tlm tr);
    if (tr.instr[6:0] == 7'b1100011) begin
      bit exp_br_eq = (tr.rs1_data == tr.rs2_data);
      bit exp_br_lt = ($signed(tr.rs1_data) < $signed(tr.rs2_data));
      if (tr.br_eq === exp_br_eq && tr.br_lt === exp_br_lt) pass_cnt++;
      else begin
        fail_cnt++;
        `uvm_error("BRANCH_SB", $psprintf("FAIL: RS1=%h RS2=%h ExpEq=%b ActEq=%b ExpLt=%b ActLt=%b", 
                   tr.rs1_data, tr.rs2_data, exp_br_eq, tr.br_eq, exp_br_lt, tr.br_lt))
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("BRANCH_SB_REPORT", $psprintf("Branch Scoreboard: PASS=%0d, FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass

class risc_v_branch_test extends risc_v_base_test;
    `uvm_component_utils(risc_v_branch_test)
    typedef risc_v_full_program_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_full_prog_seq_t;
    risc_v_master_full_prog_seq_t risc_v_master_full_prog_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        risc_v_master_full_prog_seq = risc_v_master_full_prog_seq_t::type_id::create("risc_v_master_full_prog_seq", this);
        uvm_config_db#(string)::set(null, "*", "instr_file", "../tests/branch_test.hex");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        risc_v_master_full_prog_seq.start(env_h.risc_v_master_agent_0.sequencer, null);
        phase.drop_objection(this);
    endtask
endclass
