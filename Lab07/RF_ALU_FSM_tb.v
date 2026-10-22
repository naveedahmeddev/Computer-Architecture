`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Integrated testbench: Register File + ALU driven by rf_alu_fsm.

module RF_ALU_FSM_tb;

    reg clk = 1'b0;
    reg rst = 1'b0;

    wire [4:0] rs1, rs2, rd;
    wire [31:0] WriteData, ReadData1, ReadData2, ALUResult;
    wire WriteEnable, rf_rst, Zero;
    wire [3:0] ALUControl;
    wire [4:0] state_out;

    reg [31:0] errors = 0;

    localparam S_DONE = 5'd16;

    // step tied high so the whole sequence runs in a few hundred nanoseconds
    rf_alu_fsm fsm (
        .clk(clk), .rst(rst), .step(1'b1),
        .hold_manual(1'b0), .manual_op(4'b0010),
        .manual_rd(5'd0), .manual_we(1'b0),
        .ALUResult(ALUResult), .Zero(Zero),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteData), .WriteEnable(WriteEnable),
        .rf_rst(rf_rst), .ALUControl(ALUControl), .state_out(state_out)
    );

    RegisterFile rf (
        .clk(clk), .rst(rf_rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU alu (
        .A(ReadData1), .B(ReadData2), .ALUControl(ALUControl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    always #5 clk = ~clk;

    initial begin
        $display("--- Register File + ALU integrated test ---");
        $display("constants: x1 = 0x10101010, x2 = 0x01010101, x3 = 5");

        rst = 1'b1; repeat (2) @(posedge clk); #1; rst = 1'b0;

        wait (state_out == S_DONE);
        @(posedge clk); #1;

        if (rf.regs[0] === 32'h00000000) $display("PASS : x0  hardwired zero = 0x%08h", rf.regs[0]);
        else begin $display("FAIL : x0  hardwired zero = 0x%08h, expected 0x%08h", rf.regs[0], 32'h00000000); errors = errors + 1; end
        if (rf.regs[1] === 32'h10101010) $display("PASS : x1  constant = 0x%08h", rf.regs[1]);
        else begin $display("FAIL : x1  constant = 0x%08h, expected 0x%08h", rf.regs[1], 32'h10101010); errors = errors + 1; end
        if (rf.regs[2] === 32'h01010101) $display("PASS : x2  constant = 0x%08h", rf.regs[2]);
        else begin $display("FAIL : x2  constant = 0x%08h, expected 0x%08h", rf.regs[2], 32'h01010101); errors = errors + 1; end
        if (rf.regs[3] === 32'h00000005) $display("PASS : x3  shift amount = 0x%08h", rf.regs[3]);
        else begin $display("FAIL : x3  shift amount = 0x%08h, expected 0x%08h", rf.regs[3], 32'h00000005); errors = errors + 1; end
        if (rf.regs[4] === 32'h11111111) $display("PASS : x4  ADD  x1+x2 = 0x%08h", rf.regs[4]);
        else begin $display("FAIL : x4  ADD  x1+x2 = 0x%08h, expected 0x%08h", rf.regs[4], 32'h11111111); errors = errors + 1; end
        if (rf.regs[5] === 32'h0F0F0F0F) $display("PASS : x5  SUB  x1-x2 = 0x%08h", rf.regs[5]);
        else begin $display("FAIL : x5  SUB  x1-x2 = 0x%08h, expected 0x%08h", rf.regs[5], 32'h0F0F0F0F); errors = errors + 1; end
        if (rf.regs[6] === 32'h00000000) $display("PASS : x6  AND  x1&x2 = 0x%08h", rf.regs[6]);
        else begin $display("FAIL : x6  AND  x1&x2 = 0x%08h, expected 0x%08h", rf.regs[6], 32'h00000000); errors = errors + 1; end
        if (rf.regs[7] === 32'h11111111) $display("PASS : x7  OR   x1|x2 = 0x%08h", rf.regs[7]);
        else begin $display("FAIL : x7  OR   x1|x2 = 0x%08h, expected 0x%08h", rf.regs[7], 32'h11111111); errors = errors + 1; end
        if (rf.regs[8] === 32'h11111111) $display("PASS : x8  XOR  x1^x2 = 0x%08h", rf.regs[8]);
        else begin $display("FAIL : x8  XOR  x1^x2 = 0x%08h, expected 0x%08h", rf.regs[8], 32'h11111111); errors = errors + 1; end
        if (rf.regs[9] === 32'h02020200) $display("PASS : x9  SLL  x1<<5 = 0x%08h", rf.regs[9]);
        else begin $display("FAIL : x9  SLL  x1<<5 = 0x%08h, expected 0x%08h", rf.regs[9], 32'h02020200); errors = errors + 1; end
        if (rf.regs[10] === 32'h00808080) $display("PASS : x10 SRL  x1>>5 = 0x%08h", rf.regs[10]);
        else begin $display("FAIL : x10 SRL  x1>>5 = 0x%08h, expected 0x%08h", rf.regs[10], 32'h00808080); errors = errors + 1; end
        // written only by the BEQ state where the operands matched
        if (rf.regs[11] === 32'h00000001) $display("PASS : x11 BEQ flag = 0x%08h", rf.regs[11]);
        else begin $display("FAIL : x11 BEQ flag = 0x%08h, expected 0x%08h", rf.regs[11], 32'h00000001); errors = errors + 1; end
        if (rf.regs[12] === 32'hCAFEBABE) $display("PASS : x12 read-after-write = 0x%08h", rf.regs[12]);
        else begin $display("FAIL : x12 read-after-write = 0x%08h, expected 0x%08h", rf.regs[12], 32'hCAFEBABE); errors = errors + 1; end

        if (errors == 0) $display("--- All integrated tests PASSED ---");
        else $display("--- %0d integrated test(s) FAILED ---", errors);
        $finish;
    end

endmodule
