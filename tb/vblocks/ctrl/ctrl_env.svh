
class risc_v_ctrl_env extends uvm_env;
  `uvm_component_utils(risc_v_ctrl_env)
  risc_v_ctrl_sb sb;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sb = risc_v_ctrl_sb::type_id::create("sb", this);
  endfunction
endclass
