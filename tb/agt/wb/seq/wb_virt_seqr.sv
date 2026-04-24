//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This is a virtual sequencer
//***************************************************************************************************************
class wb_virt_seqr #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequencer #(REQ,RSP);

   `uvm_component_param_utils(wb_virt_seqr #(REQ,RSP))
  
   // This is the handle to a real sequencer. We need to assign this handle in a test
   uvm_sequencer #(REQ,RSP) wb_sequencer0_h;
   
   function new(string name="", uvm_component parent = null);
      super.new(name,parent);
   endfunction
   
endclass
