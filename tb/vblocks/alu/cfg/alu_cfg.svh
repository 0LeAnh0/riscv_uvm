
class alu_cfg extends uvm_object;
  `uvm_object_utils(alu_cfg)
  bit is_active = 0; // Passive by default
  function new(string name = "alu_cfg");
    super.new(name);
  endfunction
endclass
