//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
// This is the base class for the driver. It is to be extended by an actual driver. Note that an actual driver
// can be overridden by the factory. The only element that is of use here is the handle to the global config
// object.
//***************************************************************************************************************
class wb_driver_base #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_driver #(REQ,RSP);

   `uvm_component_param_utils(wb_driver_base #(REQ,RSP))

   string   my_name;  // local name to be used in place of get_name()
   
   uvm_tb_cfg     driver_cfg;
   integer       rsp_pkt_cnt;
   
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
         
   function new(string name, uvm_component parent);
      super.new(name,parent);
      rsp_pkt_cnt = 0;
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction
  
   function void connect_phase(uvm_phase phase);
   endfunction
  
   function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
   endfunction
   
endclass
