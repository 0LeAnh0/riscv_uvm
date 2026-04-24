//***************************************************************************************************************
// Author: Van Le
//***************************************************************************************************************
class risc_v_master_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends risc_v_master_driver_base #(REQ,RSP);

  `uvm_component_param_utils(risc_v_master_driver #(REQ,RSP))

  string   my_name;
  
  virtual interface risc_v_if vif;
  virtual interface clk_rst_if clk_rst_vif;
 
  function new(string name, uvm_component parent);
     super.new(name,parent);
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    my_name = get_name();
    `uvm_info(my_name, "Connect phase started", UVM_LOW)
    if( !uvm_config_db #(virtual risc_v_if)::get(this,"","risc_v_vif",vif) ) begin
       `uvm_fatal(my_name, "FATAL: Could not retrieve virtual risc_v_vif in Driver");
    end
    `uvm_info(my_name, "Connect phase completed", UVM_LOW)
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    uvm_report_info(my_name,"Running ...",UVM_MEDIUM);
    if( !uvm_config_db #(virtual clk_rst_if)::get(this,"","clk_rst_vif",clk_rst_vif) ) begin
      `uvm_fatal(my_name, "FATAL: Could not retrieve virtual clk_rst_vif in Driver");
    end     
    get_and_drive();
  endtask
  
  task get_and_drive;
    string   msg;
    REQ req_pkt;
    RSP rsp_pkt;
    
    uvm_report_info(my_name,"Starting get_and_drive");
    forever begin
      seq_item_port.get_next_item(req_pkt); 
      
      @(posedge vif.clk);
      
      if (req_pkt.to_reset == 1) begin
      	`uvm_info(my_name, "Sequence requested Reset...", UVM_MEDIUM)
      	clk_rst_vif.do_reset(5);
      end
      
      rsp_pkt = RSP::type_id::create($psprintf("rsp_pkt_id_%0d", rsp_pkt_cnt));
      rsp_pkt.set_id_info(req_pkt);
      rsp_pkt.copy(req_pkt);

      // Update response count
      rsp_pkt_cnt++;
      
      seq_item_port.item_done(rsp_pkt);
    end
  endtask
  
endclass
  
