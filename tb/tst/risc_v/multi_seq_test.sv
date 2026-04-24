//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// Configuration: The test is responsible for setting up the configuration parameters of the sequences that it
// is invoking. For a test that invokes a virtual sequence, the virtual sequence has no knowledge about 
// configuration. So there may be multiple layers of virtual sequences.
//***************************************************************************************************************
class multi_seq_test extends base_test;

   `uvm_component_utils(multi_seq_test)
   
   string   my_name;
   
   // This is a handle to a virtual sequencer
   typedef wb_virt_seqr #(uvm_tb_tlm,uvm_tb_tlm) wb_virt_seqr_t;
   wb_virt_seqr_t   virt_seqr_h;
  
   // This is a handle to a virtual sequence
   typedef wb_multi_seq #(uvm_tb_tlm,uvm_tb_tlm) wb_multi_seq_t;
   wb_multi_seq_t multi_seq_h;
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build;
   endfunction
   
   function void connect;  
   endfunction
  
   task run;
   endtask
   
endclass
