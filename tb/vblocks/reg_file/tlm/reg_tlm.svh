
class risc_v_reg_tlm extends uvm_sequence_item;
  `uvm_object_utils(risc_v_reg_tlm)
  logic [31:0] instr;
  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] wb_data;
  logic reg_write;
  function new(string name = "reg_tlm");
    super.new(name);
  endfunction
endclass
