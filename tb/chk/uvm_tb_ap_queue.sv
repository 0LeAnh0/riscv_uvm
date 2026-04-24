//***************************************************************************************************************
// Author: Van Le
//
// This is a queue that extends uvm_subscriber to utilize the built-in FIFOs.
//***************************************************************************************************************
class uvm_tb_ap_queue #(type REQ = uvm_sequence_item) extends uvm_subscriber #(REQ);

  `uvm_component_param_utils(uvm_tb_ap_queue #(REQ))
   
  string   my_name;
  
  REQ     q[$];
  event trigger_e;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function integer get_size;
  	return q.size();
  endfunction
  	
  function bool_t has_data;
    if (q.size() == 0)
      has_data = IS_FALSE;
    else
      has_data = IS_TRUE;
  endfunction
  
  function REQ get_next_tlm();
    if (q.size() == 0)
      get_next_tlm = null;
    else
      get_next_tlm = q.pop_back();
  endfunction
  
  function void write(input REQ t);
    q.push_front(t);
    ->trigger_e;
  endfunction
   
endclass
