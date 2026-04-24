//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
//***************************************************************************************************************
// A demo test case.
//***************************************************************************************************************
class demo_test extends base_test;

	`uvm_component_utils(demo_test)
	
	string	my_name;
	
   typedef wb_demo_seq #(uvm_tb_tlm,uvm_tb_tlm) wb_demo_seq_t;
   wb_demo_seq_t demo_seq;
  
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
  
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction
  
   function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
   endfunction
	
	task run_phase(uvm_phase phase);
	endtask
	
endclass
