
class risc_v_reg_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_reg_sb)
  uvm_analysis_imp #(risc_v_tlm, risc_v_reg_sb) item_export;
  logic [31:0] shadow_regs [32];
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    foreach (shadow_regs[i]) shadow_regs[i] = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_tlm tr);
    int rs1 = tr.instr[19:15];
    int rs2 = tr.instr[24:20];
    int rd  = tr.instr[11:7];
    if (tr.rs1_data !== shadow_regs[rs1]) begin
      `uvm_error("REG_SB", $psprintf("RS1 READ FAIL: Reg x%0d Exp=%h Act=%h", rs1, shadow_regs[rs1], tr.rs1_data))
      fail_cnt++;
    end else pass_cnt++;
    if (tr.rs2_data !== shadow_regs[rs2]) begin
      `uvm_error("REG_SB", $psprintf("RS2 READ FAIL: Reg x%0d Exp=%h Act=%h", rs2, shadow_regs[rs2], tr.rs2_data))
      fail_cnt++;
    end else pass_cnt++;
    if (tr.reg_write && rd != 0) shadow_regs[rd] = tr.wb_data;
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("REG_SB_REPORT", $psprintf("Register Scoreboard: PASS=%0d, FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass

class risc_v_reg_test extends risc_v_base_test;
    `uvm_component_utils(risc_v_reg_test)
    typedef risc_v_full_program_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_full_prog_seq_t;
    risc_v_master_full_prog_seq_t risc_v_master_full_prog_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        risc_v_master_full_prog_seq = risc_v_master_full_prog_seq_t::type_id::create("risc_v_master_full_prog_seq", this);
        uvm_config_db#(string)::set(null, "*", "instr_file", "../tests/reg_test.hex");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        risc_v_master_full_prog_seq.start(env_h.risc_v_master_agent_0.sequencer, null);
        phase.drop_objection(this);
    endtask
endclass
