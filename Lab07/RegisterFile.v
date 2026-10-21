`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// 32 x 32-bit RV32I register file: two async read ports, one sync write port.

module RegisterFile (
    input wire clk,
    input wire rst,
    input wire WriteEnable,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rd,
    input wire [31:0] WriteData,
    output wire [31:0] ReadData1,
    output wire [31:0] ReadData2
);

    reg [31:0] regs [0:31];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'd0;
        end
        // rd != 0 is what makes writes to x0 disappear
        else if (WriteEnable && rd != 5'd0) begin
            regs[rd] <= WriteData;
        end
    end

    // the address-0 test means x0 reads as zero even before any reset
    assign ReadData1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign ReadData2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

endmodule
