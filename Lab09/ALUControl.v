`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// ALU control unit, gives the 4-bit ALUControl code for the Lab 6 ALU.

module ALUControl(
    input wire [1:0] ALUOp,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    output reg [3:0] ALUControl
);

    // ALU codes, must match ALU.v
    localparam ALU_AND = 4'b0000;
    localparam ALU_OR = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;

    // ALUOp 00 = add (loads, stores, ADDI), 01 = sub (BEQ), 10 = R-type
    always @(*) begin
        case (ALUOp)
            2'b00 : ALUControl = ALU_ADD;
            2'b01 : ALUControl = ALU_SUB;
            2'b10 : begin
                case (funct3)
                    3'b000 : ALUControl = funct7[5] ? ALU_SUB : ALU_ADD;
                    3'b001 : ALUControl = ALU_SLL;
                    3'b100 : ALUControl = ALU_XOR;
                    3'b101 : ALUControl = ALU_SRL;
                    3'b110 : ALUControl = ALU_OR;
                    3'b111 : ALUControl = ALU_AND;
                    default : ALUControl = ALU_ADD; // SLT, SLTU not supported
                endcase
            end
            default : ALUControl = ALU_ADD;
        endcase
    end

endmodule
