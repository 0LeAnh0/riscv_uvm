
class risc_v_alu_tlm extends uvm_sequence_item;
  `uvm_object_utils(risc_v_alu_tlm)
  
  logic [3:0] alu_sel;
  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] alu_in_a;
  logic [31:0] alu_in_b;
  logic [31:0] alu_out;

  function new(string name = "risc_v_alu_tlm");
    super.new(name);
  endfunction
endclass
