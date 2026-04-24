module tresemi_wrapper(input clk, input rst, output [31:0] pc_reg, output [31:0] instr);
    
    RISC_V risc_v_instance(
        .clk(clk),
        .rst(rst),
        .pc_reg(pc_reg)
    );

    assign instr = risc_v_instance.INSTRUCTION_IF_ID;

endmodule


