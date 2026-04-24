//***************************************************************************************************************
// Author: Van Le
//***************************************************************************************************************
class risc_v_master_agent #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_agent;

   `uvm_component_param_utils(risc_v_master_agent #(REQ,RSP))
   
   typedef risc_v_master_driver #(REQ,RSP) risc_v_master_driver_t;
   typedef risc_v_master_monitor #(REQ) risc_v_master_monitor_t;
   typedef uvm_sequencer #(REQ,RSP) risc_v_master_sequencer_t;
   
   string   my_name;
   
   risc_v_master_sequencer_t  sequencer;
   risc_v_master_driver_t      driver ;
   risc_v_master_monitor_t     monitor;
  
   uvm_analysis_port #(REQ) ref_port;  // This port is used to send reference data to the scoreboard
   uvm_analysis_port #(REQ) act_port;  // This port is used to send actual data to the scoreboard
  
   uvm_analysis_port #(REQ) cov_port;  // This port is used to send coverage data
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
      my_name = get_name();
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sequencer = risc_v_master_sequencer_t::type_id::create("risc_v_master_sequencer",this);
      driver = risc_v_master_driver_t::type_id::create("risc_v_master_driver",this);
      monitor = risc_v_master_monitor_t::type_id::create("risc_v_master_monitor",this);
      // ref_port = new($psprintf("%s_ref_port",my_name),this);
      act_port = new($psprintf("%s_act_port",my_name),this);
      cov_port = new($psprintf("%s_cov_port",my_name),this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      // Connect the sequencer to the driver so sequence items can flow.
      driver.seq_item_port.connect(sequencer.seq_item_export);
   endfunction
   
   task run;
    
   endtask
   
endclass
