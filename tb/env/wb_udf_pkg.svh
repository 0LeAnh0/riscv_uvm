//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
package wb_udf_pkg;
   import uvm_memory_pkg::*;
  
   `include "uvm_tb_defines.sv"

   typedef bit [`ADDR_WIDTH-1:0] addr_t;
   typedef bit [`DATA_WIDTH-1:0] data_t;
    
   typedef enum {
      NOP,
      READ_SINGLE,
      WRITE_SINGLE,
      READ_WRITE
   } trans_t;
    
   typedef enum {
      BYTE_SIZE,
      WORD_SIZE,
      DWORD_SIZE,
      QWORD_SIZE
   } data_size_t;
    
   typedef enum {
      MEM_REG0,
      MEM_REG1,
      MEM_REG2,
      MEM_REG3,
      MEM_REG4,
      MEM_REG5,
      MEM_REG_UNKNOWN
   } mem_reg_t;
    
   parameter   ADDRESS_WIDTH = 16,
               DATA_WIDTH = 8;

   typedef uvm_memory  #(`ADDR_WIDTH) tb_mem_t;

endpackage
