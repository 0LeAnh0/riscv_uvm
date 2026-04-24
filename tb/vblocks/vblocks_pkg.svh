
package vblocks_pkg;
  import uvm_pkg::*;
  import risc_v_udf_pkg::*;
  import risc_v_tlm_pkg::*;
  import risc_v_seq_pkg::*;
  import risc_v_master_agent_pkg::*;

  `include "uvm_macros.svh"
  
  // ALU VBlock
  `include "alu/tlm/alu_tlm.svh"
  `include "alu/cfg/alu_cfg.svh"
  `include "alu/agt/alu_agent.svh"
  `include "alu/chk/alu_sb.svh"
  `include "alu/alu_env.svh"

  // Reg File VBlock
  `include "reg_file/tlm/reg_tlm.svh"
  `include "reg_file/agt/reg_agent.svh"
  `include "reg_file/chk/reg_sb.svh"
  `include "reg_file/reg_env.svh"

  // Branch Comparator VBlock
  `include "branch_comp/branch_sb.svh"
  `include "branch_comp/branch_env.svh"

  // Memory VBlock
  `include "mem/mem_sb.svh"
  `include "mem/mem_env.svh"

  // Control Path VBlock
  `include "ctrl/ctrl_sb.svh"
  `include "ctrl/ctrl_env.svh"

endpackage
