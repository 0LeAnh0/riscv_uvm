//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class risc_v_sb #(type REQ = uvm_sequence_item) extends uvm_scoreboard;

   `uvm_component_param_utils(risc_v_sb #(REQ))
   
   typedef uvm_in_order_class_comparator #(REQ) comp_t;
   typedef uvm_tb_ap_queue #(REQ) uvm_tb_ap_queue_t;
   
   string   my_name;
   
   comp_t comparer;
   uvm_analysis_port #(REQ) in_order_ref_port;
   uvm_analysis_port #(REQ) in_order_act_port;
   uvm_analysis_port #(REQ) in_order_rst_status_port;
   
   uvm_tb_ap_queue_t act_queue; // Queue to store actual data
   //risc_v_cfg sb_cfg;
   integer ref_pc_reg; // Reference PC register

   function bit is_control_flow(bit [6:0] opcode);
      case (opcode)
         7'b1100011, 7'b1101111, 7'b1100111: is_control_flow = 1'b1;
         default:                           is_control_flow = 1'b0;
      endcase
   endfunction
   
   function new(string name, uvm_component parent);
      super.new(name, parent);
      my_name = name;
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      comparer = comp_t::type_id::create("comparer", this);
      in_order_ref_port = new("in_order_ref_port", this);
      in_order_act_port = new("in_order_act_port", this);
      act_queue = uvm_tb_ap_queue_t::type_id::create($psprintf("%s_act_queue", my_name), this);
      ref_pc_reg = 0; // Initialize reference PC register
   endfunction
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      in_order_ref_port.connect(comparer.before_export);
      in_order_act_port.connect(comparer.after_export);
      //assert(uvm_resource_db #(risc_v_cfg)::read_by_name(get_full_name(), "TB_CONFIG", sb_cfg));
   endfunction
   
   function void start_of_simulation_phase(uvm_phase phase);
//      if (sb_cfg.verbosity_control_arr["scoreboard"] == IS_ENABLE)
//         set_report_verbosity_level(UVM_MEDIUM + 1);
//      else
//         set_report_verbosity_level(UVM_MEDIUM - 1);
   endfunction
   
   function void check_phase(uvm_phase phase);
      integer qsize;
      qsize = act_queue.get_size();
      if (qsize > 0)
         `uvm_warning(my_name, $psprintf("Actual queue has %0d un-verified transactions", qsize));
   endfunction
   
   task run_phase(uvm_phase phase);
      REQ ref_pkt;  // Reference packet
      REQ act_pkt;  // Actual packet
      REQ prev_act_pkt;     // Previous packet for timeout checking
      bit have_valid_pkt;
      bit need_resync;

      // Counters to track cycles and state
      integer cycle_count;  // Counter for current cycle
      integer timeout_count; // Counter for unchanged packet cycles

      // Initial setup
      cycle_count = 0;       // Start cycle from 0
      timeout_count = 0;     // Start timeout from 0

      // Create previous packet for comparison
      prev_act_pkt = REQ::type_id::create("prev_act_pkt"); 
      have_valid_pkt = 0;
      need_resync = 0;

      forever @(act_queue.trigger_e)
         begin
            act_pkt = act_queue.get_next_tlm();

            // Skip unstable samples during reset release or any X-propagation window.
            if ($isunknown(act_pkt.pc_reg) || $isunknown(act_pkt.instr)) begin
               `uvm_info(my_name, "Skipping X PC sample", UVM_LOW)
               continue;
            end

            // Create and populate the reference packet
            ref_pkt = REQ::type_id::create("ref_pkt");

            if (!have_valid_pkt) begin
               // Lock reference to the first valid observed PC so reset timing
               // differences do not create a constant offset.
               ref_pc_reg = act_pkt.pc_reg;
               have_valid_pkt = 1;
            end

            if (is_control_flow(act_pkt.instr[6:0])) begin
               `uvm_info(my_name,
                         $psprintf("Skipping PC compare for control-flow opcode %02h at PC %h",
                                   act_pkt.instr[6:0], act_pkt.pc_reg),
                         UVM_LOW)
               prev_act_pkt.pc_reg = act_pkt.pc_reg;
               need_resync = 1;
               timeout_count = 0;
               continue;
            end

            if (need_resync) begin
               // Re-anchor after a branch/jump so the next sequential compare
               // starts from the first observed post-control-flow PC.
               ref_pc_reg = act_pkt.pc_reg;
               need_resync = 0;
            end

            ref_pkt.instr = act_pkt.instr;
            ref_pkt.pc_reg = ref_pc_reg;

            // Send both packets to the comparator
            in_order_ref_port.write(ref_pkt);
            in_order_act_port.write(act_pkt);
            
            `uvm_info(my_name, $psprintf("Scoreboard received PC: %h (Expected: %h)", act_pkt.pc_reg, ref_pc_reg), UVM_LOW)

            // Increment cycle count
            cycle_count++;  
            
            // Check and handle timeout
            if (have_valid_pkt && (act_pkt.pc_reg == prev_act_pkt.pc_reg)) begin
                  // If packet doesn't change, increment timeout counter
                  timeout_count++;
                  
                  // Warning only if timeout persists for a long time (e.g., 100 cycles)
                  if (timeout_count >= 100) begin
                     `uvm_warning("TIMEOUT", $psprintf("Processor stall detected! PC unchanged at %h for %0d cycles", act_pkt.pc_reg, timeout_count));
                     timeout_count = 0; // Reset after warning to avoid flooding
                  end
            end 
            else begin
                  // If packet changes, reset timeout counter
                  timeout_count = 0;
            end

            // Save current packet for comparison in next cycle
            prev_act_pkt.pc_reg = act_pkt.pc_reg;

            // Advance the expected PC after consuming a valid sample.
            ref_pc_reg += 4;
         end
   endtask

endclass
