//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class uvm_tb_tlm extends uvm_sequence_item;

  `uvm_object_utils(uvm_tb_tlm)
  
   string   my_name;
   
   mem_reg_t     mem_region;
   rand addr_t   addr;
   rand data_t   data;
   rand trans_t  transaction;
   rand integer  unsigned id;
   
   function new(string name = "uvm_tb_tlm");
      super.new(name);
      my_name = name;
      mem_region = MEM_REG_UNKNOWN;
   endfunction
   
   function void do_copy(uvm_object rhs);
      uvm_tb_tlm  der_type;
      super.do_copy(rhs);
      $cast(der_type,rhs);
      addr = der_type.addr;
      data = der_type.data;
      transaction = der_type.transaction;
   endfunction
   
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
      uvm_tb_tlm  der_type;
      do_compare = super.do_compare(rhs,comparer);
      $cast(der_type,rhs);
      do_compare &= comparer.compare_field_int("addr",addr,der_type.addr,`ADDR_WIDTH); 
      do_compare &= comparer.compare_field_int("data",data,der_type.data,`DATA_WIDTH); 
   endfunction
   
   function bit comp(uvm_tb_tlm obj);
      return ((this.addr == obj.addr) &&
         (this.data == obj.data));
         //(this.transaction == obj.transaction));
   endfunction
  
   function string transaction2string(trans_t tr);
      case (tr)
         READ_SINGLE: return "READ_SINGLE";
         WRITE_SINGLE: return "WRITE_SINGLE";
         READ_WRITE: return "READ_WRITE";
         default: return "NOP";
      endcase
   endfunction
   
   function void do_prints(uvm_printer printer);
      printer.print_field("addr",addr,$bits(addr));
      printer.print_field("data",data,$bits(data));
      printer.print_field("addr",addr,$bits(addr));
   endfunction
   
   // This is needed for the built-in in-order comparator
   function string convert2string();
      convert2string = $psprintf("addr=%x data=%x",addr,data);
   endfunction
  
   constraint uvm_tb_tlm_c {
      mem_region == MEM_REG0 -> addr inside {[ADDR_REG0_START:ADDR_REG0_END]};
      mem_region == MEM_REG1 -> addr inside {[ADDR_REG1_START:ADDR_REG1_END]};
      mem_region == MEM_REG2 -> addr inside {[ADDR_REG2_START:ADDR_REG2_END]};
      mem_region == MEM_REG3 -> addr inside {[ADDR_REG3_START:ADDR_REG3_END]};
      mem_region == MEM_REG4 -> addr inside {[ADDR_REG4_START:ADDR_REG4_END]};
      mem_region == MEM_REG5 -> addr inside {[ADDR_REG5_START:ADDR_REG5_END]};
  }
   
endclass
