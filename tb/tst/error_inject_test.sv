//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class error_inject_test extends base_test;

   `uvm_component_utils(error_inject_test)
   
   string   my_name;
   
   typedef wb_demo_seq #(uvm_tb_tlm,uvm_tb_tlm) wb_demo_seq_t;
   wb_demo_seq_t demo_seq;
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build;
   endfunction
  
   function void connect;
      super.connect();
   endfunction
  
   function void start_of_simulation;
      super.start_of_simulation();
   endfunction
   
   task run;
   endtask
   
endclass
