//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// This is the environment class. Its sole purpose is to instantiate one or more agent classes.
//***************************************************************************************************************
class uvm_tb_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(uvm_tb_env #(REQ,RSP))
   
   string my_name;
   
   // typedef wb_agent  #(REQ,RSP) wb_agent_t;
   // wb_agent_t wb_agent_0;
   typedef uvm_tb_sb #(REQ) uvm_tb_sb_t;
   uvm_tb_sb_t    sb;
   typedef uvm_tb_cov #(REQ) uvm_tb_cov_t;
   uvm_tb_cov_t   cov;
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
   
   function void connect_phase(uvm_phase phase);
   endfunction
   
   task run_phase(uvm_phase phase);
      `uvm_info(my_name,"Running env ...",UVM_MEDIUM);
   endtask
   
   function void extract_phase(uvm_phase phase);
      `uvm_info(my_name,"Extract phase is called",UVM_NONE);
   endfunction
   
   function void check_phase(uvm_phase phase);
      `uvm_info(my_name,"Check phase is called",UVM_NONE);
   endfunction
   
endclass
