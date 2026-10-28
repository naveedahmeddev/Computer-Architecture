`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Main control unit of the single-cycle RISC-V processor, decodes the opcode.

module MainControl(
    input wire [6:0] opcode,
    output reg RegWrite,
    output reg [1:0] ALUOp,
    output reg MemRead,
    output reg MemWrite,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg Branch
);

    localparam OP_R = 7'b0110011; // ADD SUB SLL SRL AND OR XOR
    localparam OP_I = 7'b0010011; // ADDI
    localparam OP_LOAD = 7'b0000011; // LW LH LB
    localparam OP_STORE = 7'b0100011; // SW SH SB
    localparam OP_BRANCH = 7'b1100011; // BEQ

    // Don't cares are set to 0. Unknown opcodes write nothing.
    always @(*) begin
        RegWrite = 1'b0;
        ALUOp = 2'b00;
        MemRead = 1'b0;
        MemWrite = 1'b0;
        ALUSrc = 1'b0;
        MemtoReg = 1'b0;
        Branch = 1'b0;
        case (opcode)
            OP_R : begin
                RegWrite = 1'b1;
                ALUOp = 2'b10;
            end
            OP_I : begin
                RegWrite = 1'b1;
                ALUSrc = 1'b1;
            end
            OP_LOAD : begin
                RegWrite = 1'b1;
                MemRead = 1'b1;
                ALUSrc = 1'b1;
                MemtoReg = 1'b1;
            end
            OP_STORE : begin
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
            end
            OP_BRANCH : begin
                ALUOp = 2'b01;
                Branch = 1'b1;
            end
        endcase
    end

endmodule
