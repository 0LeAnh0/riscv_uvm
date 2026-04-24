//***************************************************************************************************************
// Author: Antigravity AI
// Description: Monitor for RISC-V interface to capture PC and other signals
//***************************************************************************************************************
class risc_v_master_monitor #(type REQ = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(risc_v_master_monitor #(REQ))

  virtual interface risc_v_if vif;
  uvm_analysis_port #(REQ) act_port;

  string my_name;

  // Functional Coverage for ISA and Blocks
  covergroup risc_v_cg;
    option.name = "risc_v_detailed_coverage";
    
    // 1. ISA Coverage (Opcode + Funct3)
    opcode_cp: coverpoint vif.instr[6:0] {
      bins load    = {7'b0000011};
      bins store   = {7'b0100011};
      bins alu_imm = {7'b0010011};
      bins alu_reg = {7'b0110011};
      bins branch  = {7'b1100011};
      bins jal     = {7'b1101111};
      bins jalr    = {7'b1100111};
      bins lui     = {7'b0110111};
      bins auipc   = {7'b0010111};
    }
    
    alu_funct3_cp: coverpoint vif.instr[14:12];
    
    cross_op_funct3: cross opcode_cp, alu_funct3_cp {
      ignore_bins illegal_loads = binsof(opcode_cp.load) intersect {3, 6, 7};
      ignore_bins illegal_stores = binsof(opcode_cp.store) intersect {3, 4, 5, 6, 7};
      ignore_bins illegal_branches = binsof(opcode_cp.branch) intersect {2, 3};
      ignore_bins no_funct3_jal = binsof(opcode_cp.jal);
      ignore_bins no_funct3_lui = binsof(opcode_cp.lui);
      ignore_bins no_funct3_auipc = binsof(opcode_cp.auipc);
    }

    // 2. ALU Coverage (Logically Grouped Operations)
    alu_sel_cp: coverpoint vif.alu_sel {
      bins logic_ops = {4'b0000, 4'b0001, 4'b1010, 4'b0101}; // AND, OR, XOR, NOR
      bins arith_ops = {4'b0010, 4'b0011}; // ADD, SUB
      bins shift_ops = {4'b0111, 4'b1000, 4'b1001}; // SLL, SRL, SRA
      bins comp_ops  = {4'b0100, 4'b0110}; // SLT, EQ
      bins others    = default;
    }

    // 3. Register Access Coverage (Grouped by RISC-V ABI conventions)
    rs1_cp: coverpoint vif.instr[19:15] {
      bins zero_reg  = {0};
      bins arg_regs  = {[10:17]};
      bins temp_regs = {[5:7], [28:31]};
      bins saved_regs= {[8:9], [18:27]};
      bins other_regs = default;
    }
    rs2_cp: coverpoint vif.instr[24:20] {
      bins zero_reg  = {0};
      bins arg_regs  = {[10:17]};
      bins temp_regs = {[5:7], [28:31]};
      bins saved_regs= {[8:9], [18:27]};
      bins other_regs = default;
    }
    rd_cp: coverpoint vif.instr[11:7] iff (vif.reg_write) {
      bins arg_regs  = {[10:17]};
      bins temp_regs = {[5:7], [28:31]};
      bins saved_regs= {[8:9], [18:27]};
      bins other_regs = default;
    }

    // 4. Memory Coverage
    mem_read_cp:  coverpoint vif.mem_read;
    mem_write_cp: coverpoint vif.mem_write;
    
    // 5. Branch Coverage
    pc_sel_cp: coverpoint vif.pc_sel {
      bins taken = {1'b1};
      bins not_taken = {1'b0};
    }
    br_eq_cp: coverpoint vif.br_eq;
    br_lt_cp: coverpoint vif.br_lt;

  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    my_name = name;
    risc_v_cg = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(my_name, "Build phase started", UVM_LOW)
    act_port = new("act_port", this);
    if (!uvm_config_db#(virtual risc_v_if)::get(this, "", "risc_v_vif", vif)) begin
      `uvm_fatal(my_name, "FATAL: Could not get virtual interface handle 'risc_v_vif' in Monitor. Check top.sv!");
    end
    `uvm_info(my_name, "Build phase completed", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    REQ tr;
    forever begin
      @(negedge vif.clk);
      #1ps;
      if (vif.rst === 1'b0) begin // Monitor only when not in reset (stable)
        if ($isunknown(vif.pc_reg)) begin
          `uvm_info(my_name, "Skipping X PC sample", UVM_LOW)
          continue;
        end

        tr = REQ::type_id::create("tr");
        tr.pc_reg = vif.pc_reg;
        tr.instr = vif.instr;
        
        // Sample Internal Signals for Block Verification
        tr.alu_sel   = vif.alu_sel;
        tr.rs1_data  = vif.rs1_data;
        tr.rs2_data  = vif.rs2_data;
        tr.alu_out   = vif.alu_out;
        tr.wb_data   = vif.wb_data;
        tr.mem_rdata = vif.mem_rdata;
        tr.alu_in_a  = vif.alu_in_a;
        tr.alu_in_b  = vif.alu_in_b;
        tr.reg_write = vif.reg_write;
        tr.mem_read  = vif.mem_read;
        tr.mem_write = vif.mem_write;
        tr.br_eq     = vif.br_eq;
        tr.br_lt     = vif.br_lt;
        
        // Sample Coverage
        risc_v_cg.sample();
        
        act_port.write(tr);
        `uvm_info(my_name, $psprintf("Monitored PC: %h, Instr: %h", vif.pc_reg, vif.instr), UVM_LOW)
      end
    end
  endtask

endclass
