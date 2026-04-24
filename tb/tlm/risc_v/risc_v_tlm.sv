class risc_v_tlm extends uvm_sequence_item;

  `uvm_object_utils(risc_v_tlm)
  
   string   my_name;
   
   // rand risc_v_cmd_t   cmd;
   bit [31:0] pc_reg;
   logic [31:0] instr;
   bit to_reset;
   
   // Internal Signals for Verification
   logic [3:0]  alu_sel;
   logic [31:0] rs1_data;
   logic [31:0] rs2_data;
   logic [31:0] alu_out;
   logic [31:0] wb_data;
   logic [31:0] mem_rdata;
   logic [31:0] alu_in_a;
   logic [31:0] alu_in_b;
   logic        reg_write;
   logic        mem_read;
   logic        mem_write;
   logic        br_eq;
   logic        br_lt;
   
   function new(string name = "risc_v_tlm");
      super.new(name);
      my_name = name;
   endfunction
   
   function void do_copy(uvm_object rhs);
      risc_v_tlm  der_type;
      super.do_copy(rhs);
      $cast(der_type,rhs);
      pc_reg = der_type.pc_reg;
      instr = der_type.instr;
      to_reset = der_type.to_reset;
   endfunction
   
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      risc_v_tlm  der_type;
      do_compare = super.do_compare(rhs,comparer);
      $cast(der_type,rhs);
      do_compare &= comparer.compare_field_int("pc_reg",pc_reg,der_type.pc_reg,32); 
      do_compare &= comparer.compare_field_int("instr",instr,der_type.instr,32); 
      do_compare &= comparer.compare_field_int("to_reset",to_reset,der_type.to_reset,1); 
   endfunction
   
   function bit comp(risc_v_tlm obj);
      return (this.pc_reg == obj.pc_reg);
   endfunction
  
    function string transaction2string();
      case (pc_reg)
         0: return "RISC_RESET";
         default: return "WORKING"; 
      endcase
   endfunction
   
   function void do_prints(uvm_printer printer);
    //   printer.print_string("cmd",cmd,transaction2string(cmd));
   endfunction
   
   // This is needed for the built-in in-order comparator
   function string convert2string();
      convert2string = $psprintf("pc=%08h instr=%08h reset=%0d", pc_reg, instr, to_reset);
   endfunction
  
endclass
