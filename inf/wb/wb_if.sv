//***************************************************************************************************************
//***************************************************************************************************************
`include "uvm_tb_defines.sv"

interface wb_if;

   wire  [`ADDR_WIDTH-1:0] wb_addr;
   wire  [`DATA_WIDTH-1:0] wb_wdata;
   wire  [`DATA_WIDTH-1:0] wb_rdata;
   wire                    wb_cyc;
   wire                    wb_stb;
   wire                    wb_we;
   wire                    wb_sel;
   wire                    wb_ack;
   wire                    wb_err;
   wire                    wb_rty;
   
   logic clk;
   logic rst;
   
   logic [`ADDR_WIDTH-1:0] tb_wb_addr;
   logic [`DATA_WIDTH-1:0] tb_wb_wdata;
   logic                   tb_wb_cyc;
   logic                   tb_wb_stb;
   logic                   tb_wb_we;
   logic                   tb_wb_sel;  
   
   assign wb_addr  = tb_wb_addr;
   assign wb_wdata = tb_wb_wdata;
   assign wb_cyc   = tb_wb_cyc;
   assign wb_stb   = tb_wb_stb;
   assign wb_we    = tb_wb_we;
   assign wb_sel   = tb_wb_sel;
   
   clocking driver_cb @(posedge clk);
      output tb_wb_addr, tb_wb_cyc, tb_wb_stb, tb_wb_we, tb_wb_sel;
      input  wb_ack, wb_err, wb_rty;
   endclocking
    
   clocking monitor_cb @(posedge clk);
      input wb_addr, wb_cyc, wb_stb, wb_we, wb_sel, wb_ack, wb_err, wb_rty;
   endclocking
    
   initial begin
      #1;
      clk = 0;
      rst = 0;
      forever begin
         #`HALF_PERIOD clk = ~clk;
      end
   end
    
endinterface
