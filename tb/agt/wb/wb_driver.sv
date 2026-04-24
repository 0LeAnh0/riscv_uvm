//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class wb_driver #(type REQ = uvm_sequence_item, type RSP = uvm_sequence_item) extends wb_driver_base #(REQ,RSP);

   `uvm_component_param_utils(wb_driver #(REQ,RSP))

   string   my_name;
   
   virtual interface wb_if vif;
  
   function new(string name, uvm_component parent);
      super.new(name,parent);
   endfunction
   
   virtual function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction
  
   virtual task reset_dut();
      repeat (1) @(posedge vif.clk);
      vif.rst <= 1;
      vif.driver_cb.tb_wb_stb <= 0;
      vif.driver_cb.tb_wb_cyc <= 0;
      vif.driver_cb.tb_wb_sel <= 1;
      repeat (`RESET_LENGTH) @(posedge vif.clk);
      vif.rst <= 0;
   endtask
      
   virtual task run_phase(uvm_phase phase);
      uvm_report_info(my_name,"Running ...",UVM_MEDIUM);
      fork
         get_and_drive();
         reset_dut();
      join
   endtask
   
   task get_and_drive;
      string   msg;
      REQ req_pkt;
      RSP rsp_pkt;
   endtask
   
   // This task performs a single write
   virtual task write_data(input REQ w_obj);
   endtask
   
   // This task performs a single read
   virtual task read_data(ref REQ r_obj);
   endtask

endclass
   
