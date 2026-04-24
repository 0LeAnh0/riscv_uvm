//***************************************************************************************************************
// Author: Van Le
//***************************************************************************************************************
class risc_v_env #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends uvm_env;

   `uvm_component_param_utils(risc_v_env #(REQ,RSP))
   
   string my_name;
   
   typedef risc_v_master_agent  #(REQ,RSP) risc_v_master_agent_t;
   risc_v_master_agent_t risc_v_master_agent_0;
   typedef risc_v_master_agent  #(REQ,RSP) risc_v_slave_agent_t;
   risc_v_slave_agent_t risc_v_slave_agent_0;
   
   typedef risc_v_sb #(REQ) risc_v_sb_t;
   risc_v_sb_t    sb;
   
   // Modular Block Environments
   risc_v_alu_env    alu_block_env;
   risc_v_reg_env    reg_block_env;
   risc_v_branch_env branch_block_env;
   risc_v_mem_env    mem_block_env;
   risc_v_ctrl_env   ctrl_block_env;

   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      my_name = get_name();
      risc_v_master_agent_0 = risc_v_master_agent_t::type_id::create("risc_v_master_agent_0",this);
      sb = risc_v_sb_t::type_id::create("Scoreboard",this);
      
      // Instantiate block environments
      alu_block_env    = risc_v_alu_env::type_id::create("alu_block_env", this);
      reg_block_env    = risc_v_reg_env::type_id::create("reg_block_env", this);
      branch_block_env = risc_v_branch_env::type_id::create("branch_block_env", this);
      mem_block_env    = risc_v_mem_env::type_id::create("mem_block_env", this);
      ctrl_block_env   = risc_v_ctrl_env::type_id::create("ctrl_block_env", this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);

      // Connect top-level scoreboard
      risc_v_master_agent_0.monitor.act_port.connect(sb.act_queue.analysis_export);
      
      // Connect block-level scoreboards to the main monitor 
      // (Note: ALU and REG use their own internal monitors inside their envs)
      risc_v_master_agent_0.monitor.act_port.connect(branch_block_env.sb.item_export);
      risc_v_master_agent_0.monitor.act_port.connect(mem_block_env.sb.item_export);
      risc_v_master_agent_0.monitor.act_port.connect(ctrl_block_env.sb.item_export);
   endfunction
   
   task run_phase(uvm_phase phase);
      `uvm_info(my_name,"Running env ...",UVM_MEDIUM);
   endtask
   
endclass
