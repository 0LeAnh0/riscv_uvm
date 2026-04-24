
class risc_v_reg_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_reg_sb)
  uvm_analysis_imp #(risc_v_reg_tlm, risc_v_reg_sb) item_export;
  logic [31:0] shadow_regs [32];
  int pass_cnt, fail_cnt;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_export = new("item_export", this);
    for (int i=0; i<32; i++) shadow_regs[i] = 32'h0;
  endfunction
  virtual function void write(risc_v_reg_tlm tr);
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
endclass
