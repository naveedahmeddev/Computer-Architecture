`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// 512 x 32 data memory. Write and read both happen on the rising clock edge.

module DataMemory (
    input wire clk,
    input wire rst,
    input wire memwrite,
    input wire [31:0] addr,
    input wire [31:0] writedata,
    output reg [31:0] datamemout
);

    reg [31:0] mem [0:511];

    // read is one cycle late, and a write cycle does not read
    always @(posedge clk) begin
        if (rst)
            datamemout <= 32'b0;
        else if (memwrite)
            mem[addr[8:0]] <= writedata;
        else
            datamemout <= mem[addr[8:0]];
    end

endmodule
