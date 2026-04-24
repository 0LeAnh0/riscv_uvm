//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
`include "uvm_tb_defines.sv"
`timescale 1ns/1ps
import uvm_pkg::*;
import udf_pkg::*;
import risc_v_test_pkg::*;

module top;
   
  // Local wires for DUT connections
  wire clk;
  wire rst;
  wire [31:0] pc_reg;
  wire [31:0] instr;
   
  // Clock generation
  logic clk_gen = 0;
  initial forever #`HALF_CLK clk_gen = ~clk_gen;
  assign clk = clk_gen;

  // Interface instances
  clk_rst_if clk_rst_if0();
  risc_v_if risc_v_if0();
  
  // Connect interfaces to top-level wires
  assign clk_rst_if0.clk = clk;
  assign rst = clk_rst_if0.rst;
  
  assign risc_v_if0.clk = clk;
  assign risc_v_if0.rst = rst;
  assign risc_v_if0.pc_reg = pc_reg;
  assign risc_v_if0.instr = instr;

  // Connect internal signals for coverage
  assign risc_v_if0.alu_sel   = dut0.risc_v_instance.AluSel;
  assign risc_v_if0.alu_out   = dut0.risc_v_instance.ALU_OUT_EX_Mem;
  assign risc_v_if0.rs1_data  = dut0.risc_v_instance.REG_DATA1_ID_EX;
  assign risc_v_if0.rs2_data  = dut0.risc_v_instance.REG_DATA2_ID_EX;
  assign risc_v_if0.imm       = dut0.risc_v_instance.IMM_ID_EX;
  assign risc_v_if0.reg_write = dut0.risc_v_instance.RegWrite_Ctrl_ID;
  assign risc_v_if0.mem_read  = dut0.risc_v_instance.MemRead_Ctrl_Mem;
  assign risc_v_if0.mem_write = dut0.risc_v_instance.MemWrite_Ctrl_Mem;
  assign risc_v_if0.pc_sel    = dut0.risc_v_instance.PC_Sel;
  assign risc_v_if0.br_eq     = dut0.risc_v_instance.BrEq;
  assign risc_v_if0.br_lt     = dut0.risc_v_instance.BrLT;
  assign risc_v_if0.wb_sel    = dut0.risc_v_instance.WB_Sel;
  assign risc_v_if0.wb_data   = dut0.risc_v_instance.ALU_DATA_WB_ID;
  assign risc_v_if0.mem_rdata  = dut0.risc_v_instance.Read_data_Mem_Mux;
  assign risc_v_if0.alu_in_a   = dut0.risc_v_instance.ex_unit.ALU_1.A_in;
  assign risc_v_if0.alu_in_b   = dut0.risc_v_instance.ex_unit.ALU_1.B_in;

  // DUT instantiation
  tresemi_wrapper dut0(
    .clk(clk), 
    .rst(rst), 
    .pc_reg(pc_reg), 
    .instr(instr)
  ); 

  // UVM setup and run
  initial begin
    $display("DEBUG: TOP Level Simulation Starting at %0t", $time);
    // Initialize reset
    clk_rst_if0.rst = 0;
    
    // Set interfaces in config_db
    uvm_config_db #(virtual clk_rst_if)::set(null, "*", "clk_rst_vif", clk_rst_if0);
    uvm_config_db #(virtual risc_v_if)::set(null, "*", "risc_v_vif", risc_v_if0);
    
    // Launch test
    run_test();
  end

endmodule
