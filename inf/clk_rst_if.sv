//***************************************************************************************************************
// Author: Van Le
//
// This interface block provides clock and reset support to the testbench
//***************************************************************************************************************
`include "uvm_tb_defines.sv"
`timescale 1ns/1ps

interface clk_rst_if;
    logic clk;
    logic rst = 0;

	task do_reset (integer reset_length); 
		rst = 1;
		repeat (5) @(posedge clk);
		rst = 0;
	endtask
	
	/*
	initial begin
		$display("DEBUG: Clock generator started at time %0t", $time);
		#1;
		clk = 1;
		rst = 0;
		forever begin
			#`HALF_CLK clk = ~clk;
		end
	end
	*/

endinterface
