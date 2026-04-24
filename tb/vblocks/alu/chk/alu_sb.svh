
class risc_v_alu_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_alu_sb)
  uvm_analysis_imp #(risc_v_alu_tlm, risc_v_alu_sb) item_export;
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_alu_tlm tr);
    logic [31:0] expected_out;
    bit ignore = 0;
    case(tr.alu_sel)
      4'b0000: expected_out = tr.alu_in_a & tr.alu_in_b;
      4'b0001: expected_out = tr.alu_in_a | tr.alu_in_b;
      4'b0010: expected_out = tr.alu_in_a + tr.alu_in_b;
      4'b0011: expected_out = $signed(tr.alu_in_a) - $signed(tr.alu_in_b);
      4'b0100: expected_out = ($signed(tr.alu_in_a) < $signed(tr.alu_in_b)) ? 32'd1 : 32'd0;
      4'b0101: expected_out = ~(tr.alu_in_a | tr.alu_in_b);
      4'b0110: expected_out = (tr.alu_in_a == tr.alu_in_b) ? 32'd1 : 32'd0;
      4'b0111: expected_out = tr.alu_in_a << tr.alu_in_b[4:0];
      4'b1000: expected_out = tr.alu_in_a >> tr.alu_in_b[4:0];
      4'b1001: expected_out = $signed(tr.alu_in_a) >>> tr.alu_in_b[4:0];
      4'b1010: expected_out = tr.alu_in_a ^ tr.alu_in_b;
      4'b1011: expected_out = tr.alu_in_b << 12;
      default: ignore = 1;
    endcase
    if (!ignore) begin
      if (tr.alu_out === expected_out) pass_cnt++;
      else begin
        fail_cnt++;
        `uvm_error("ALU_SB", $psprintf("FAIL: Op=%b A=%h B=%h Exp=%h Act=%h", tr.alu_sel, tr.alu_in_a, tr.alu_in_b, expected_out, tr.alu_out))
      end
    end
  endfunction
endclass
