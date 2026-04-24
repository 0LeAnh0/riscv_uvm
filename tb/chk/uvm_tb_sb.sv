//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uvm_tb_sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

   `uvm_component_param_utils(uvm_tb_sb #(REQ))
   
   typedef uvm_in_order_class_comparator #(REQ) comp_t; // Need this for the type_id::create call below
   typedef uvm_tb_ap_queue #(REQ) uvm_tb_ap_queue_t;
  
   string   my_name;
   
   comp_t comparer;
   uvm_analysis_port #(REQ) in_order_ref_port;
   uvm_analysis_port #(REQ) in_order_act_port;
   
   uvm_tb_ap_queue_t ref_queue; // Queue to store reference data
   uvm_tb_ap_queue_t act_queue; // Queue to store actual data
  
   uvm_tb_cfg   sb_cfg;
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
  endfunction
   
   task run_phase(uvm_phase phase);
   endtask
   
endclass
