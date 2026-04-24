//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// The test package provides a test layer between the top module and the environment. More than
// one test can be included here.
//***************************************************************************************************************
package uvm_tb_test_pkg;

   import uvm_pkg::*;
   import uvm_tb_udf_pkg::*;
   import wb_udf_pkg::*;
   import uvm_tb_env_pkg::*;
   import uvm_tb_tlm_pkg::*;
   import wb_seq_pkg::*;
   import uvm_tb_cfg_pkg::*;
   import wb_agent_pkg::*;
   
   `include "uvm_macros.svh"  
   `include "uvm_tb_defines.sv"
   `include "base_test.sv"
   //
   // All new tests must derive from base_test and must be listed here.
   // Each test is saved as one file
   //
   `include "demo_test.sv"       // single sequence test
   //`include "multi_seq_test.sv"  // two-sequence test
   //`include "error_inject_test.sv"   // test with error injections
endpackage
