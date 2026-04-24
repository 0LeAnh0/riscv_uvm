//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This is a virtual sequence that is used to invoke two sequences: wb_demo_seq and wb_read_seq. 
// This sequence is used by the test multi_seq_test.sv to demonstrate how a test case can be created that uses
// two sequences.
//***************************************************************************************************************
class wb_multi_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

   //
   // Register the sequence with the factory
   //
   `uvm_object_param_utils(wb_multi_seq #(REQ,RSP))
   
   string my_name;
   
   typedef wb_demo_seq #(REQ,RSP) wb_demo_seq_t;
   wb_demo_seq_t virt_demo_seq_h;
   typedef wb_read_seq #(REQ,RSP) wb_read_seq_t;
   wb_read_seq_t virt_read_seq_h;
   typedef wb_write_seq #(REQ,RSP) wb_write_seq_t;
   wb_write_seq_t     virt_write_seq_h;
  
   function new(string name = "");
      super.new(name);
   endfunction
   
   task body;
   endtask
   
endclass
