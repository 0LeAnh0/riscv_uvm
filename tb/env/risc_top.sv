//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Top level module. It is responsible for instantiating the dut and the interface modules. It also passes the
// interface handle using set_config_object.
//***************************************************************************************************************
`timescale 1ns/1ps
import uvm_pkg::*;
import udf_pkg::*;
//import risc_test_pkg::*;

module top;
   
  wire clk;
  wire rst;
	wire [31:0] pc_reg;
   
  //
  // Interface declaration here
  //
  clk_rst_if clk_rst_if0(.clk(clk),.rst(rst));
  risc_v_if risc_v_if0(.clk(clk), .rst(rst), .pc_reg(pc_reg));
   
  tresemi_wrapper dut0(.clk(clk), .rst(rst), .pc_reg(pc_reg));
  
  initial begin
    uvm_config_db #(virtual clk_rst_if)::set(null,"*","clk_rst_vif",clk_rst_if0);
    uvm_config_db #(virtual risc_v_if)::set(null,"*","risc_v_vif",risc_v_if0);
    run_test();
  end

endmodule
