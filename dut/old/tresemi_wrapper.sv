module tresemi_wrapper(wire clk, wire rst, wire [31:0] pc_reg);
    
    RISC_V risc_v_instance(
        .clk(clk),
        .rst(rst),
        .pc_reg(pc_reg)
    );

endmodule


