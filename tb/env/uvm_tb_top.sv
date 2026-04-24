//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
//***************************************************************************************************************
import uvm_pkg::*;
import uvm_tb_udf_pkg::*;
import wb_udf_pkg::*;
import uvm_tb_test_pkg::*;
import uvm_memory_pkg::*;

`include "wb_if.sv"

module top;
   
   //
   // Interface declaration here
   //
   wb_if wb_if0();
  
   tb_mem_t tb_mem;

   //
   // DUT declaration here
   //
   wb_slave_model dut0(
      .clk_i(wb_if0.clk),
      .rst_i(wb_if0.rst),
      .dat_o(wb_if0.wb_rdata),
      .dat_i(wb_if0.wb_wdata),
      .adr_i(wb_if0.wb_addr),
      .cyc_i(wb_if0.wb_cyc),
      .stb_i(wb_if0.wb_stb),
      .we_i(wb_if0.wb_we),
      .sel_i(wb_if0.wb_sel),
      .ack_o(wb_if0.wb_ack),
      .err_o(wb_if0.wb_err),
      .rty_o(wb_if0.wb_rty)
   );
   
   function void set_config_memory;
      tb_mem = new("TB Memory");
      //tb_mem = tb_mem_t::type_id::create("TB Memory");
      uvm_resource_db #(tb_mem_t)::set("*","uvm_tb_memory",tb_mem);
   endfunction
  
   //
   // In OVM, all we need to specify is run_test in the top module. Then, we can specify the test name
   // when we invoke vsim. Then the factory will instantiate the test and goes through the phases. A
   // typical command is
   //    vsim -c top +OVM_TESTNAME=demo_test
   //
   // More than one test can be compiled into the testbench. Each test can be run by specifying the test 
   // name at the command line. There is no need to re-compile.
   //
   initial 
      begin
      run_test();
      end

endmodule
