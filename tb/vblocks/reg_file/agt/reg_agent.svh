
class risc_v_reg_monitor extends uvm_monitor;
  `uvm_component_utils(risc_v_reg_monitor)
  virtual risc_v_if vif;
  uvm_analysis_port #(risc_v_reg_tlm) item_collected_port;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual risc_v_if)::get(this, "", "risc_v_vif", vif))
      `uvm_fatal("REG_MON", "Could not get vif")
  endfunction
  task run_phase(uvm_phase phase);
    forever begin
      @(negedge vif.clk);
      #1ps;
      if (vif.rst === 0) begin
        risc_v_reg_tlm tr = risc_v_reg_tlm::type_id::create("tr");
        tr.instr = vif.instr;
        tr.rs1_data = vif.rs1_data;
        tr.rs2_data = vif.rs2_data;
        tr.wb_data = vif.wb_data;
        tr.reg_write = vif.reg_write;
        item_collected_port.write(tr);
      end
    end
  endtask
endclass

class risc_v_reg_agent extends uvm_agent;
  `uvm_component_utils(risc_v_reg_agent)
  risc_v_reg_monitor monitor;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = risc_v_reg_monitor::type_id::create("monitor", this);
  endfunction
endclass
