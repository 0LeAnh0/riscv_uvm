//***************************************************************************************************************
// Author: Auto-generated for industry-style coverage
// Description: Sequence to generate random resets during normal operation
//***************************************************************************************************************
class risc_v_random_reset_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(risc_v_random_reset_seq #(REQ,RSP))
  
  string my_name;
   
  integer drain_time = `DRAIN_TIME;
  integer num_pkts = 200;
  
  function new(string name="");
    super.new(name);
  endfunction

  task body;
    REQ req_pkt;
    RSP rsp_pkt; 
    
    my_name = get_name();
    
    `uvm_info("risc_v_random_reset_seq: ", $psprintf("num_pkts = %d, drain_time=%d", num_pkts, drain_time), UVM_MEDIUM)

    // Initial reset
    req_pkt = REQ::type_id::create("req_pkt_initial");
    req_pkt.to_reset = 1;
    wait_for_grant();
    send_request(req_pkt);
    get_response(rsp_pkt);
    `uvm_info(my_name, "Initial reset applied", UVM_LOW);

    for (int ii=0; ii<num_pkts; ii++) begin
      req_pkt = REQ::type_id::create($psprintf("req_pkt_id_%d", ii));
      // Occasionally inject a reset (roughly every 50 packets)
      if (ii > 0 && ii % 50 == 0) begin
        req_pkt.to_reset = 1;
        `uvm_info(my_name, $psprintf("Injecting random reset at packet %0d", ii), UVM_LOW);
      end else begin
        req_pkt.to_reset = 0;
      end
      
      wait_for_grant();
      send_request(req_pkt);
      get_response(rsp_pkt);
    end
    
    `uvm_info(my_name, "Random reset sequence completed", UVM_LOW);
        
  endtask
   
endclass
