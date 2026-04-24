
class risc_v_alu_env extends uvm_env;
  `uvm_component_utils(risc_v_alu_env)
  
  risc_v_alu_agent agt;
  risc_v_alu_sb    sb;
  alu_cfg   cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = risc_v_alu_agent::type_id::create("agt", this);
    sb  = risc_v_alu_sb::type_id::create("sb", this);
    if (!uvm_config_db#(alu_cfg)::get(this, "", "cfg", cfg))
      cfg = alu_cfg::type_id::create("cfg");
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.monitor.item_collected_port.connect(sb.item_export);
  endfunction
endclass
