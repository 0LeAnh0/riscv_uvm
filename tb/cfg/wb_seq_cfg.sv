//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class wb_seq_cfg extends uvm_object;

  `uvm_object_utils(wb_seq_cfg)
  
  string  my_name;
  uvm_table_printer printer;
  
  mem_reg_t       mem_region;
  trans_t         trans_type;
  string          filename;
  bool_t          use_file_io;
  rand integer    num_trans;
  rand integer    num_write;
  rand integer    drain_time;
  
  function new(string name = "");
    super.new(name);
    printer = new;
  endfunction
  
  function void do_print(uvm_printer printer);
    printer.print_field("mem_region",mem_region,$bits(mem_region));
    printer.print_field("trans_type",trans_type,$bits(trans_type));
  endfunction
  
  constraint default_config_c {
    num_write == `NUM_WRITE;
    num_trans == `NUM_TRANS;
    drain_time == `DRAIN_TIME;
  }
  
endclass
