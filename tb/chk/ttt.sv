class test_case_1_seq (...) extends uvm_sequence;

task body;
  vif.reset_dut(5);



class test_case_2_seq (... ) extends ....
task body;
  vif.reset_dut(5);



class base_seq (...) extends uvm_sequence;

	task init;
	  vif.reset_dut(5);
		init_mem();
	endtask

  task body;
	  init_dut();


class test_case_1_seq ... extends base_seq;
  task body;
		super.body();
		....

