`timescale 1ns / 1ps


module data_memory
(
    input clk,       
    input mem_read,
    input mem_write,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] data_out
);
    reg [31:0] memory [0:524288];

    integer i;
    initial begin
        for (i = 0; i < 524288; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end

    always@(posedge clk)begin
        if (mem_write)
        begin
            memory[address] <= write_data;
        end
    end
    
    always @ (negedge clk) begin
        if (mem_read)
        begin
        data_out = memory[address];
        end
    end
endmodule
