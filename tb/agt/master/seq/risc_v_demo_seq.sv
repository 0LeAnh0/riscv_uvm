//***************************************************************************************************************
// Author: Van Le
//***************************************************************************************************************
class risc_v_demo_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(risc_v_demo_seq #(REQ,RSP))
  
  string my_name;
   
  integer drain_time = `DRAIN_TIME;
  integer num_write = 10;
  
  function new(string name="");
    super.new(name);
  endfunction

  // virtual task init_dut;
  //   REQ reset_pkt;
  //   RSP rsp_pkt;

  //   reset_pkt = REQ::type_id::create($psprintf("reset_pkt"));
  //   reset_pkt.to_reset = 1;
  //   wait_for_grant();
  //   send_request(reset_pkt);
  //   uvm_report_info(my_name, $psprintf("Sending reset packet"));
  //   get_response(rsp_pkt);
  //   uvm_report_info(my_name, $psprintf("Received response packet"));
  // endtask
   
  task body;
    REQ req_pkt;
    RSP   rsp_pkt; 
    
    my_name = get_name();
    
    `uvm_info("risc_v_demo_seq: ",$psprintf("num_write = %d, drain_time=%d",num_write,drain_time),UVM_MEDIUM)
    
    for (int ii=0; ii<num_write; ii++) begin
      req_pkt = REQ::type_id::create($psprintf("req_pkt_id_%d",ii));
      req_pkt.to_reset = (ii == 0 || ii == 30);
      wait_for_grant();
      send_request(req_pkt);
      get_response(rsp_pkt);
      uvm_report_info(my_name,$psprintf("Received reponse packet"));
    end
        
  endtask
   
endclass
