`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Testbench for MainControl.v and ALUControl.v, one instruction every 10 ns.

module control_tb;

    reg [6:0] opcode = 7'd0;
    reg [2:0] funct3 = 3'd0;
    reg [6:0] funct7 = 7'd0;

    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUCtrl;

    MainControl main_ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    ALUControl alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUCtrl)
    );

    initial begin
        $monitor("%0t opcode=%b funct3=%b funct7=%b | RegWrite=%b ALUSrc=%b MemRead=%b MemWrite=%b MemtoReg=%b Branch=%b ALUOp=%b ALUControl=%b",
                 $time, opcode, funct3, funct7, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp, ALUCtrl);

        #10;
        // ADD
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // SUB
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0100000; #10;
        // SLL
        opcode = 7'b0110011; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        // SRL
        opcode = 7'b0110011; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        // AND
        opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b0000000; #10;
        // OR
        opcode = 7'b0110011; funct3 = 3'b110; funct7 = 7'b0000000; #10;
        // XOR
        opcode = 7'b0110011; funct3 = 3'b100; funct7 = 7'b0000000; #10;
        // ADDI
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // ADDI with immediate 1024, still has to add
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0100000; #10;
        // LW
        opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000; #10;
        // LH
        opcode = 7'b0000011; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        // LB
        opcode = 7'b0000011; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // SW
        opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000; #10;
        // SH
        opcode = 7'b0100011; funct3 = 3'b001; funct7 = 7'b0000000; #10;
        // SB
        opcode = 7'b0100011; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // BEQ
        opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000; #10;
        // unknown opcode, all signals should be 0
        opcode = 7'b1111111; funct3 = 3'b000; funct7 = 7'b0000000; #10;

        $finish;
    end

endmodule
