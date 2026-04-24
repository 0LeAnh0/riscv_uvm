//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// This is the base test layer. It instantiates the environment.
//***************************************************************************************************************
class base_test extends uvm_test;

   `uvm_component_utils(base_test)
   
   string         my_name;
  
   typedef uvm_tb_env #(uvm_tb_tlm,uvm_tb_tlm) uvm_tb_env_t;
   uvm_tb_env_t   env0;
   uvm_tb_cfg     default_cfg;
   uvm_tb_cfg     tb_cfg;
   
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   function void start_of_simulation_phase(uvm_phase phase);
   endfunction
   
endclass
