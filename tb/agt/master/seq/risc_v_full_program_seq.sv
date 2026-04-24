//***************************************************************************************************************
// Sequence to run the RISC-V processor for a longer duration to execute its full hardcoded program
// and verify it handles all instructions (ALU, Memory, Branches) correctly over time.
//***************************************************************************************************************
class risc_v_full_program_seq #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_sequence #(REQ,RSP);

  `uvm_object_param_utils(risc_v_full_program_seq #(REQ,RSP))
  
  string my_name;
  integer drain_time = `DRAIN_TIME;
  integer num_cycles = 62; // Let the processor run for 62 cycles to finish its program
  
  function new(string name="");
    super.new(name);
  endfunction

  task body;
    REQ req_pkt;
    RSP rsp_pkt; 
    
    my_name = get_name();
    `uvm_info(my_name, $psprintf("Starting full program sequence for %0d cycles...", num_cycles), UVM_LOW)

    // 1. Send initial reset
    req_pkt = REQ::type_id::create("req_pkt_initial_reset");
    req_pkt.to_reset = 1;
    wait_for_grant();
    send_request(req_pkt);
    get_response(rsp_pkt);
    `uvm_info(my_name, "Initial reset applied", UVM_LOW)

    // 2. Loop to provide clock cycles for the RISC-V to execute the program
    for (int ii=0; ii<num_cycles; ii++) begin
      req_pkt = REQ::type_id::create($psprintf("req_pkt_idle_%0d", ii));
      req_pkt.to_reset = 0;

      wait_for_grant();
      send_request(req_pkt);
      get_response(rsp_pkt);
    end
    
    `uvm_info(my_name, "Full program sequence completed.", UVM_LOW)
        
  endtask
   
endclass
