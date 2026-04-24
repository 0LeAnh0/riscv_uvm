
class risc_v_branch_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_branch_sb)
  uvm_analysis_imp #(risc_v_tlm, risc_v_branch_sb) item_export;
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_tlm tr);
    if (tr.instr[6:0] == 7'b1100011) begin
      bit exp_br_eq = (tr.rs1_data == tr.rs2_data);
      bit exp_br_lt;
      if (tr.instr[14:12] == 3'b110 || tr.instr[14:12] == 3'b111)
          exp_br_lt = (tr.rs1_data < tr.rs2_data);
      else
          exp_br_lt = ($signed(tr.rs1_data) < $signed(tr.rs2_data));
      if (tr.br_eq === exp_br_eq && tr.br_lt === exp_br_lt) pass_cnt++;
      else begin
        fail_cnt++;
        `uvm_error("BRANCH_SB", $psprintf("FAIL: RS1=%h RS2=%h ExpEq=%b ActEq=%b ExpLt=%b ActLt=%b", 
                   tr.rs1_data, tr.rs2_data, exp_br_eq, tr.br_eq, exp_br_lt, tr.br_lt))
      end
    end
  endfunction
endclass
