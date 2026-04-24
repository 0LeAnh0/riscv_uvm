
class risc_v_reg_env extends uvm_env;
  `uvm_component_utils(risc_v_reg_env)
  risc_v_reg_agent agt;
  risc_v_reg_sb    sb;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = risc_v_reg_agent::type_id::create("agt", this);
    sb  = risc_v_reg_sb::type_id::create("sb", this);
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.monitor.item_collected_port.connect(sb.item_export);
  endfunction
endclass
