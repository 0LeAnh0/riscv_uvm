//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class wb_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

   `uvm_component_param_utils(wb_monitor #(PKT))
   
   string   my_name;
   
   virtual interface wb_if       vif;
   tb_mem_t    tb_memory;
  
   // The monitor continually monitors the bus for activities. If there is a read transaction on the bus,
   // the monitor performs two steps. In the first step, the monitor gets the address then performs a look
   // up in tb_mem to get reference data. Then, the monitor creates a reference packet that includes the 
   // address and the data. In the second step, the monitor grabs the address and the data on the bus and 
   // creates an actual data packet. Both are sent to the scoreboard for comparison.
   uvm_analysis_port #(PKT)  act_port;
   uvm_analysis_port #(PKT)  ref_port;  // Move this ref port from the driver.

   uvm_tb_cfg   monitor_cfg;
  
   integer pkt_count; 
   bit [3:0] st;
   parameter 
      RESET = 0,
      RD_CMD = 1,
      RD_CMD_WAIT = 2,
      RD_CMD_DATA = 3,
      BUS_IDLE = 4;     
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   function void connect_phase(uvm_phase phase);
   endfunction
  
   function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
   endfunction
   
   function void assign_vif(virtual interface wb_if if0);
      vif = if0;
   endfunction
   
   task monitoring;
   endtask
   
   task run_phase(uvm_phase phase);
      monitoring();
   endtask
   
endclass
