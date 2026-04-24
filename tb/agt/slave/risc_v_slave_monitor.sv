class risc_v_slave_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(risc_v_slave_monitor #(PKT))

  string my_name;

  virtual interface risc_v_if vif;

  uvm_analysis_port #(PKT) act_port;

  risc_v_cfg monitor_cfg;

  logic [31:0] pc_reg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    my_name = name;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    act_port = new($psprintf("%s_act_port", my_name), this);
  endfunction

  function void connect_phase(uvm_phase phase);
     
    assert(uvm_resource_db #(risc_v_cfg)::read_by_name(get_full_name(),"TB_CONFIG",monitor_cfg));
    if (monitor_cfg.inject_error == IS_TRUE)
      uvm_report_info(my_name,"Error injection is true");
    else
      uvm_report_info(my_name,"Error injection is false");
           
    //
    // Getting the interface handle
    //
    if( !uvm_config_db #(virtual risc_v_if)::get(this,"","risc_v_vif",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual risc_v_if");
    end
     
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    if (monitor_cfg.verbosity_control_arr["monitor"] == IS_ENABLE)
      set_report_verbosity_level(UVM_MEDIUM + 1);
    else
      set_report_verbosity_level(UVM_MEDIUM - 1);
  endfunction

  virtual task monitoring;
    integer act_pkt_cnt;
    PKT act_pkt;
    act_pkt_cnt = 0;
    forever @(posedge vif.clk) begin
      if ($isunknown(vif.pc_reg)) begin
        continue;
      end
      
      pc_reg = vif.pc_reg;  
      uvm_report_info(my_name, $psprintf("Value of PC_Reg: %h", pc_reg), UVM_MEDIUM);

      act_pkt_cnt++;
      act_pkt = PKT::type_id::create($psprintf("act_pkt_id_%d", act_pkt_cnt));
      act_pkt.pc_reg = pc_reg;  

      act_port.write(act_pkt);
      // cov_port.write(act_pkt);  
    end
  endtask

  task check_timeout;
    integer cnt;
    bit [31:0] lpc; // last pc_reg value

    cnt = 0;
    lpc = 0;
    forever @(posedge vif.clk) begin
      if(vif.rst == 0) begin
        if (lpc == vif.pc_reg) begin
          // if dont change, inc cnt
          cnt++;
          // if dont change in 4 clocks, issue error
          if (cnt>4) begin
            `uvm_error(my_name,$psprintf("cnt exceeds limit at %0d", cnt))
            break;
          end
        end else begin
        // if change, clear cnt and assign new pc_reg
        cnt = 0;
        lpc = vif.pc_reg;
      end  
      end else begin
      // Init during reset
      cnt = 0;
      lpc = 0;
      end
    end
  endtask

  task run_phase(uvm_phase phase);
    fork
      monitoring();
      check_timeout();
    join
  endtask

endclass
