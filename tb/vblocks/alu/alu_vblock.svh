
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
      4'b0000: expected_out = tr.rs1_data & tr.rs2_data;
      4'b0001: expected_out = tr.rs1_data | tr.rs2_data;
      4'b0010: expected_out = tr.rs1_data + tr.rs2_data;
      4'b0011: expected_out = $signed(tr.rs1_data) - $signed(tr.rs2_data);
      4'b0100: expected_out = ($signed(tr.rs1_data) < $signed(tr.rs2_data)) ? 32'd1 : 32'd0;
      4'b0101: expected_out = ~(tr.rs1_data | tr.rs2_data);
      4'b0110: expected_out = (tr.rs1_data == tr.rs2_data) ? 32'd1 : 32'd0;
      4'b0111: expected_out = tr.rs1_data << tr.rs2_data[4:0];
      4'b1000: expected_out = tr.rs1_data >> tr.rs2_data[4:0];
      4'b1001: expected_out = $signed(tr.rs1_data) >>> tr.rs2_data[4:0];
      4'b1010: expected_out = tr.rs1_data ^ tr.rs2_data;
      4'b1011: expected_out = tr.rs2_data << 12;
      default: ignore = 1;
    endcase
    if (!ignore) begin
      if (tr.alu_out === expected_out) pass_cnt++;
      else begin
        fail_cnt++;
        `uvm_error("ALU_SB", $psprintf("FAIL: Op=%b A=%h B=%h Exp=%h Act=%h", tr.alu_sel, tr.rs1_data, tr.rs2_data, expected_out, tr.alu_out))
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("ALU_SB_REPORT", $psprintf("ALU Scoreboard: PASS=%0d, FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass

class risc_v_alu_test extends risc_v_base_test;
    `uvm_component_utils(risc_v_alu_test)
    typedef risc_v_full_program_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_full_prog_seq_t;
    risc_v_master_full_prog_seq_t risc_v_master_full_prog_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        risc_v_master_full_prog_seq = risc_v_master_full_prog_seq_t::type_id::create("risc_v_master_full_prog_seq", this);
        uvm_config_db#(string)::set(null, "*", "instr_file", "../tests/alu_test.hex");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        risc_v_master_full_prog_seq.start(env_h.risc_v_master_agent_0.sequencer, null);
        phase.drop_objection(this);
    endtask
endclass
