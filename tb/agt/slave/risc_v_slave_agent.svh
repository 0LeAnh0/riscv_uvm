//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class risc_v_slave_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(risc_v_slave_agent #(REQ,RSP))
   
   typedef risc_v_slave_monitor #(REQ) risc_v_slave_monitor_t;
   
   string   my_name;
   
   risc_v_slave_monitor_t    monitor;
  
   uvm_analysis_port #(REQ) act_port;  // This port is used to send actual data to the scoreboard
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      monitor = risc_v_slave_monitor_t::type_id::create("risc_v_slave_monitor",this);
      act_port = new($psprintf("%s_act_port",my_name),this);
   endfunction
   
   function void connect;
      monitor.act_port.connect(act_port);
   endfunction
   
endclass
