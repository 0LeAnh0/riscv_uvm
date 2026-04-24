
class risc_v_alu_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_alu_sb)

  uvm_analysis_imp #(risc_v_tlm, risc_v_alu_sb) item_export;
  
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_tlm tr);
    logic [31:0] expected_out;
    bit ignore = 0;

    case(tr.alu_sel)
      4'b0000: expected_out = tr.rs1_data & tr.rs2_data; // AND
      4'b0001: expected_out = tr.rs1_data | tr.rs2_data; // OR
      4'b0010: expected_out = tr.rs1_data + tr.rs2_data; // ADD
      4'b0011: expected_out = $signed(tr.rs1_data) - $signed(tr.rs2_data); // SUB
      4'b0100: expected_out = ($signed(tr.rs1_data) < $signed(tr.rs2_data)) ? 32'd1 : 32'd0; // SLT
      4'b0101: expected_out = ~(tr.rs1_data | tr.rs2_data); // NOR
      4'b0110: expected_out = (tr.rs1_data == tr.rs2_data) ? 32'd1 : 32'd0; // EQ
      4'b0111: expected_out = tr.rs1_data << tr.rs2_data[4:0]; // SLL
      4'b1000: expected_out = tr.rs1_data >> tr.rs2_data[4:0]; // SRL
      4'b1001: expected_out = $signed(tr.rs1_data) >>> tr.rs2_data[4:0]; // SRA
      4'b1010: expected_out = tr.rs1_data ^ tr.rs2_data; // XOR
      4'b1011: expected_out = tr.rs2_data << 12; // LUI
      default: ignore = 1;
    endcase

    if (!ignore) begin
      if (tr.alu_out === expected_out) begin
        pass_cnt++;
        `uvm_info("ALU_SB", $psprintf("PASS: Op=%b A=%h B=%h Res=%h", tr.alu_sel, tr.rs1_data, tr.rs2_data, tr.alu_out), UVM_HIGH)
      end else begin
        fail_cnt++;
        `uvm_error("ALU_SB", $psprintf("FAIL: Op=%b A=%h B=%h Exp=%h Act=%h", tr.alu_sel, tr.rs1_data, tr.rs2_data, expected_out, tr.alu_out))
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("ALU_SB_REPORT", $psprintf("ALU Scoreboard: PASS=%0d, FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW)
  endfunction

endclass
