
class risc_v_mem_sb extends uvm_scoreboard;
  `uvm_component_utils(risc_v_mem_sb)
  uvm_analysis_imp #(risc_v_tlm, risc_v_mem_sb) item_export;
  logic [7:0] shadow_mem [int];
  int pass_cnt, fail_cnt;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
  endfunction

  virtual function void write(risc_v_tlm tr);
    logic [31:0] addr = tr.alu_out;
    if (tr.mem_write) begin
      shadow_mem[addr]   = tr.rs2_data[7:0];
      shadow_mem[addr+1] = tr.rs2_data[15:8];
      shadow_mem[addr+2] = tr.rs2_data[23:16];
      shadow_mem[addr+3] = tr.rs2_data[31:24];
    end
    if (tr.mem_read) begin
      logic [31:0] exp_data;
      exp_data[7:0]   = shadow_mem.exists(addr)   ? shadow_mem[addr]   : 8'h0;
      exp_data[15:8]  = shadow_mem.exists(addr+1) ? shadow_mem[addr+1] : 8'h0;
      exp_data[23:16] = shadow_mem.exists(addr+2) ? shadow_mem[addr+2] : 8'h0;
      exp_data[31:24] = shadow_mem.exists(addr+3) ? shadow_mem[addr+3] : 8'h0;
      if (tr.mem_rdata === exp_data) pass_cnt++;
      else begin
        fail_cnt++;
        `uvm_error("MEM_SB", $psprintf("Memory READ FAIL: Addr=%h Exp=%h Act=%h", addr, exp_data, tr.mem_rdata))
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("MEM_SB_REPORT", $psprintf("Memory Scoreboard: PASS=%0d, FAIL=%0d", pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass

class risc_v_mem_test extends risc_v_base_test;
    `uvm_component_utils(risc_v_mem_test)
    typedef risc_v_full_program_seq #(risc_v_tlm, risc_v_tlm) risc_v_master_full_prog_seq_t;
    risc_v_master_full_prog_seq_t risc_v_master_full_prog_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        risc_v_master_full_prog_seq = risc_v_master_full_prog_seq_t::type_id::create("risc_v_master_full_prog_seq", this);
        uvm_config_db#(string)::set(null, "*", "instr_file", "../tests/mem_test.hex");
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        risc_v_master_full_prog_seq.start(env_h.risc_v_master_agent_0.sequencer, null);
        phase.drop_objection(this);
    endtask
endclass
