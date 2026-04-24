
class risc_v_alu_monitor extends uvm_monitor;
  `uvm_component_utils(risc_v_alu_monitor)
  
  virtual risc_v_if vif;
  uvm_analysis_port #(risc_v_alu_tlm) item_collected_port;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual risc_v_if)::get(this, "", "risc_v_vif", vif))
      `uvm_fatal("ALU_MON", "Could not get vif")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(negedge vif.clk);
      #1ps;
      if (vif.rst === 0) begin
        risc_v_alu_tlm tr = risc_v_alu_tlm::type_id::create("tr");
        tr.alu_sel  = vif.alu_sel;
        tr.rs1_data = vif.rs1_data;
        tr.rs2_data = vif.rs2_data;
        tr.alu_in_a = vif.alu_in_a;
        tr.alu_in_b = vif.alu_in_b;
        tr.alu_out  = vif.alu_out;
        item_collected_port.write(tr);
      end
    end
  endtask
endclass

class risc_v_alu_agent extends uvm_agent;
  `uvm_component_utils(risc_v_alu_agent)
  
  risc_v_alu_monitor monitor;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = risc_v_alu_monitor::type_id::create("monitor", this);
  endfunction
endclass
