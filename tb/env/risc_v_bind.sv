
module risc_v_bind;

  bind top.risc_v_if0 risc_v_if_monitor monitor_inst (
    .clk(top.clk),
    .rst(top.rst),
    .pc_reg(top.dut0.pc_reg),
    .instr(top.dut0.instr),
    .alu_sel(top.dut0.risc_v_instance.AluSel),
    .alu_out(top.dut0.risc_v_instance.ALU_OUT_EX_Mem),
    .rs1_data(top.dut0.risc_v_instance.REG_DATA1_ID_EX),
    .rs2_data(top.dut0.risc_v_instance.REG_DATA2_ID_EX),
    .imm(top.dut0.risc_v_instance.IMM_ID_EX),
    .reg_write(top.dut0.risc_v_instance.RegWrite_Ctrl_ID),
    .mem_read(top.dut0.risc_v_instance.MemRead_Ctrl_Mem),
    .mem_write(top.dut0.risc_v_instance.MemWrite_Ctrl_Mem),
    .pc_sel(top.dut0.risc_v_instance.PC_Sel),
    .br_eq(top.dut0.risc_v_instance.BrEq),
    .br_lt(top.dut0.risc_v_instance.BrLT),
    .wb_sel(top.dut0.risc_v_instance.WB_Sel)
  );

endmodule
