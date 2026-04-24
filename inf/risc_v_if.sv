//***************************************************************************************************************
// Author: Van Le
//
// This interface provides access to the DUT input signals
//***************************************************************************************************************
`include "uvm_tb_defines.sv"
`timescale 1ns/1ps

interface risc_v_if;
  logic clk, rst;
  logic [31:0] pc_reg;
  logic [31:0] instr;
  
  // Internal signals for coverage
  logic [3:0] alu_sel;
  logic [31:0] alu_out;
  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] imm;
  logic reg_write;
  logic mem_read;
  logic mem_write;
  logic pc_sel;
  logic br_eq;
  logic br_lt;
  logic [1:0] wb_sel;
  logic [31:0] wb_data;
  logic [31:0] mem_rdata;
  logic [31:0] alu_in_a;
  logic [31:0] alu_in_b;

  // SVA: PC must always be 4-byte aligned
  property p_pc_aligned;
    @(posedge clk) disable iff (rst !== 1'b0 || $isunknown(pc_reg))
    pc_reg[1:0] == 2'b00;
  endproperty
  
  a_pc_aligned: assert property (p_pc_aligned) else 
    $error("PC Alignment Error: PC = %h is not 4-byte aligned!", pc_reg);

endinterface
