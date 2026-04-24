
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
    // Only check if it's a branch instruction (Opcode 1100011)
    if (tr.instr[6:0] == 7'b1100011) begin
      bit exp_br_eq = (tr.rs1_data == tr.rs2_data);
      bit exp_br_lt = ($signed(tr.rs1_data) < $signed(tr.rs2_data));
      
      if (tr.br_eq === exp_br_eq && tr.br_lt === exp_br_lt) begin
        pass_cnt++;
      end else begin
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
