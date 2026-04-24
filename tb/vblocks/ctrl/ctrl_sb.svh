
class risc_v_ctrl_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_ctrl_sb)
  uvm_analysis_imp #(risc_v_tlm, risc_v_ctrl_sb) item_export;
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_tlm tr);
    bit exp_reg_write, exp_mem_read, exp_mem_write;
    logic [6:0] opcode = tr.instr[6:0];
    case (opcode)
      7'b0110011: begin exp_reg_write = 1; exp_mem_read = 0; exp_mem_write = 0; end
      7'b0010011: begin exp_reg_write = 1; exp_mem_read = 0; exp_mem_write = 0; end
      7'b0000011: begin exp_reg_write = 1; exp_mem_read = 1; exp_mem_write = 0; end
      7'b0100011: begin exp_reg_write = 0; exp_mem_read = 0; exp_mem_write = 1; end
      7'b1100011: begin exp_reg_write = 0; exp_mem_read = 0; exp_mem_write = 0; end
      default: return;
    endcase
    if (tr.reg_write === exp_reg_write && tr.mem_read === exp_mem_read && tr.mem_write === exp_mem_write) pass_cnt++;
    else begin
      fail_cnt++;
      `uvm_error("CTRL_SB", $psprintf("FAIL: Opcode=%b RegWr=%b/%b MemRd=%b/%b MemWr=%b/%b", 
                 opcode, tr.reg_write, exp_reg_write, tr.mem_read, exp_mem_read, tr.mem_write, exp_mem_write))
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("CTRL_SB_REPORT", $psprintf("Control Scoreboard: PASS=%0d, FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass
