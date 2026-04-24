//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class wb_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(wb_agent #(REQ,RSP))
   
   typedef wb_driver #(REQ,RSP) wb_driver_t;
   typedef wb_monitor #(REQ) wb_monitor_t;
   typedef uvm_sequencer #(REQ,RSP) wb_sequencer_t;
   
   string   my_name;
   
   wb_sequencer_t  sequencer;
   wb_driver_t      driver ;
   wb_monitor_t    monitor;
  
   uvm_analysis_port #(REQ) ref_port;  // This port is used to send reference data to the scoreboard
   uvm_analysis_port #(REQ) act_port;  // This port is used to send actual data to the scoreboard
  
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name();
   endfunction
   
   function void connect;
   endfunction
   
   task run;
   endtask
   
endclass
