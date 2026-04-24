//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This sequence generates read transactions only
//***************************************************************************************************************
class wb_read_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

   string my_name;
   
   //
   // These are loop control variables. These are configured from the test level by way of the
   // sequencer which uses the get_config_int() function to get the actual values during run time.
   //
   integer  num_write = 0;
   integer  num_trans = 0;
   integer drain_time = `DRAIN_TIME;
   mem_reg_t mem_region = MEM_REG0;
  
   uvm_tb_cfg     tb_cfg;   // testbench config object
   wb_seq_cfg     seq_cfg;  // sequence config object
  
   //
   // Register the sequence with the factory
   //
   `uvm_object_param_utils(wb_read_seq #(REQ,RSP))
   
   function new(string name = "");
      super.new(name);
   endfunction
   
   task body;
   endtask
   
endclass
