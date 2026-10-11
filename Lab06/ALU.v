`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia 
// Engineer: ZaiNaveed

// 32-bit ALU for the single-cycle RISC-V processor.

module ALU(
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output wire Zero
);

    localparam ALU_AND = 4'b0000;
    localparam ALU_OR = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;   // BEQ uses this code too, the answer is on Zero

    // A - B = A + ~B + 1, so one adder does both ADD and SUB
    wire sub = (ALUControl == ALU_SUB);
    wire [31:0] b_mux = sub ? ~B : B;
    wire [31:0] sum = A + b_mux + {31'd0, sub};

    wire [31:0] and_out = A & B;
    wire [31:0] or_out = A | B;
    wire [31:0] xor_out = A ^ B;

    // RV32I shifts use only the low 5 bits of the second operand
    wire [4:0] shamt = B[4:0];
    wire [31:0] sll_out = A << shamt;
    wire [31:0] srl_out = A >> shamt;

    always @(*) begin
        case (ALUControl)
            ALU_AND : ALUResult = and_out;
            ALU_OR : ALUResult = or_out;
            ALU_ADD : ALUResult = sum;
            ALU_XOR : ALUResult = xor_out;
            ALU_SLL : ALUResult = sll_out;
            ALU_SRL : ALUResult = srl_out;
            ALU_SUB : ALUResult = sum;
            default : ALUResult = 32'd0;
        endcase
    end

    assign Zero = (ALUResult == 32'd0);

endmodule
