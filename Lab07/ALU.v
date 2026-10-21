`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// 32-bit ALU for the single-cycle RISC-V processor.

module ALU (
    input wire [31:0] A,
    input wire [31:0] B,
    input wire [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output wire Zero
);

    // rf_alu_fsm.v uses the same constants, change both together
    localparam OP_AND = 4'b0000;
    localparam OP_OR = 4'b0001;
    localparam OP_ADD = 4'b0010;
    localparam OP_XOR = 4'b0011;
    localparam OP_SLL = 4'b0100;
    localparam OP_SRL = 4'b0101;
    localparam OP_SUB = 4'b0110;

    always @(*) begin
        case (ALUControl)
            OP_AND : ALUResult = A & B;
            OP_OR : ALUResult = A | B;
            OP_ADD : ALUResult = A + B;
            OP_XOR : ALUResult = A ^ B;
            // RISC-V takes the shift amount from the low 5 bits of the second operand
            OP_SLL : ALUResult = A << B[4:0];
            OP_SRL : ALUResult = A >> B[4:0];
            OP_SUB : ALUResult = A - B;
            default : ALUResult = 32'd0;
        endcase
    end

    assign Zero = (ALUResult == 32'd0);

endmodule
