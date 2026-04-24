//***************************************************************************************************************
// Author: Van Le
//
// This is the configuration file for the risc_in demo sequence
//***************************************************************************************************************
class risc_v_master_seq_cfg extends uvm_object;

  `uvm_object_utils(risc_v_master_seq_cfg)
  
  string  my_name;
  uvm_table_printer printer;
  
  rand integer    drain_time;
  rand integer    num_write;
  
  function new(string name = "");
    super.new(name);
    printer = new;
  endfunction
  
  function void do_print(uvm_printer printer);
    printer.print_field("drain time",drain_time,$bits(drain_time));
  endfunction
  
  // todo: create a constraint block to constrain drain_time to `DRAIN_TIME
  constraint drain_time_c {
    drain_time inside {`DRAIN_TIME};
  }
endclass
