//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// The test package provides a test layer between the top module and the environment. More than
// one test can be included here.
//***************************************************************************************************************
package risc_v_test_pkg;

   import uvm_pkg::*;
   import udf_pkg::*;
   import risc_v_udf_pkg::*;
   import risc_v_env_pkg::*;
   import risc_v_tlm_pkg::*;
   import risc_v_seq_pkg::*;
   //import risc_v_cfg_pkg::*;
   import risc_v_master_agent_pkg::*;
   import vblocks_pkg::*;
   
   `include "uvm_macros.svh"  
   `include "uvm_tb_defines.sv"
   `include "risc_v_base_test.sv"
   //
   // All new tests must derive from base_test and must be listed here.
   // Each test is saved as one file
   //
   `include "risc_v_demo_test.svh"       // single sequence test
   `include "risc_v_random_reset_test.svh" // random reset test
   `include "risc_v_full_program_test.svh" // full program execution test
   `include "../../vblocks/alu/alu_test.svh"
   `include "../../vblocks/reg_file/reg_test.svh"
   `include "../../vblocks/branch_comp/branch_test.svh"
   `include "../../vblocks/mem/mem_test.svh"
   //`include "multi_seq_test.sv"  // two-sequence test
   //`include "error_inject_test.sv"   // test with error injections
endpackage
