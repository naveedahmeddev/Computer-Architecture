`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Self-checking testbench for ALU.v. Set op_name to ASCII radix in the waveform.

module ALU_tb;

    localparam ALU_AND = 4'b0000;
    localparam ALU_OR = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;

    reg [31:0] A = 32'd0;
    reg [31:0] B = 32'd0;
    reg [3:0] ALUControl = 4'd0;
    wire [31:0] ALUResult;
    wire Zero;

    reg [31:0] op_name = "----";
    reg [31:0] exp_result = 32'd0;
    reg exp_zero = 1'b0;

    reg [31:0] pass_count = 0;
    reg [31:0] fail_count = 0;
    reg [31:0] seed = 2026;
    reg [5:0] i;

    ALU dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);

        #10;

        // the lab's fixed operands
        op_name = "ADD "; ALUControl = ALU_ADD; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h11111111; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SUB "; ALUControl = ALU_SUB; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h0F0F0F0F; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SLL "; ALUControl = ALU_SLL; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h20202020; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SRL "; ALUControl = ALU_SRL; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h08080808; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "AND "; ALUControl = ALU_AND; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "OR  "; ALUControl = ALU_OR; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h11111111; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "XOR "; ALUControl = ALU_XOR; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h11111111; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "BEQ "; ALUControl = ALU_SUB; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h0F0F0F0F; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "BEQ "; ALUControl = ALU_SUB; A = 32'h10101010; B = 32'h10101010; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // ADD: carries, carry out and overflow wrap-around
        op_name = "ADD "; ALUControl = ALU_ADD; A = 32'h00000000; B = 32'h00000000; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "ADD "; ALUControl = ALU_ADD; A = 32'hFFFFFFFF; B = 32'h00000001; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "ADD "; ALUControl = ALU_ADD; A = 32'h7FFFFFFF; B = 32'h00000001; exp_result = 32'h80000000; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "ADD "; ALUControl = ALU_ADD; A = 32'h12345678; B = 32'h9ABCDEF0; exp_result = 32'hACF13568; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // SUB
        op_name = "SUB "; ALUControl = ALU_SUB; A = 32'h00000005; B = 32'h00000003; exp_result = 32'h00000002; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SUB "; ALUControl = ALU_SUB; A = 32'h00000003; B = 32'h00000005; exp_result = 32'hFFFFFFFE; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SUB "; ALUControl = ALU_SUB; A = 32'h00000000; B = 32'h00000001; exp_result = 32'hFFFFFFFF; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SUB "; ALUControl = ALU_SUB; A = 32'h80000000; B = 32'h00000001; exp_result = 32'h7FFFFFFF; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SUB "; ALUControl = ALU_SUB; A = 32'h12345678; B = 32'h12345678; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // logic
        op_name = "AND "; ALUControl = ALU_AND; A = 32'hFFFFFFFF; B = 32'h12345678; exp_result = 32'h12345678; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "AND "; ALUControl = ALU_AND; A = 32'hDEADBEEF; B = 32'hFFFF0000; exp_result = 32'hDEAD0000; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "AND "; ALUControl = ALU_AND; A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "OR  "; ALUControl = ALU_OR; A = 32'h12340000; B = 32'h00005678; exp_result = 32'h12345678; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "OR  "; ALUControl = ALU_OR; A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; exp_result = 32'hFFFFFFFF; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "OR  "; ALUControl = ALU_OR; A = 32'h00000000; B = 32'h00000000; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "XOR "; ALUControl = ALU_XOR; A = 32'hAAAAAAAA; B = 32'h55555555; exp_result = 32'hFFFFFFFF; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "XOR "; ALUControl = ALU_XOR; A = 32'hDEADBEEF; B = 32'hFFFFFFFF; exp_result = 32'h21524110; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "XOR "; ALUControl = ALU_XOR; A = 32'hCAFEF00D; B = 32'hCAFEF00D; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // shifts: only B[4:0] is used as the shift amount
        op_name = "SLL "; ALUControl = ALU_SLL; A = 32'h00000001; B = 32'h00000000; exp_result = 32'h00000001; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SLL "; ALUControl = ALU_SLL; A = 32'h00000001; B = 32'h0000001F; exp_result = 32'h80000000; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SLL "; ALUControl = ALU_SLL; A = 32'h00000001; B = 32'h00000021; exp_result = 32'h00000002; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SLL "; ALUControl = ALU_SLL; A = 32'hFFFFFFFF; B = 32'h00000004; exp_result = 32'hFFFFFFF0; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SLL "; ALUControl = ALU_SLL; A = 32'h80000000; B = 32'h00000001; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SRL "; ALUControl = ALU_SRL; A = 32'h80000000; B = 32'h0000001F; exp_result = 32'h00000001; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SRL "; ALUControl = ALU_SRL; A = 32'hFFFFFFFF; B = 32'h00000004; exp_result = 32'h0FFFFFFF; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SRL "; ALUControl = ALU_SRL; A = 32'h80000000; B = 32'hFFFFFFE4; exp_result = 32'h08000000; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SRL "; ALUControl = ALU_SRL; A = 32'h12345678; B = 32'h00000000; exp_result = 32'h12345678; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "SRL "; ALUControl = ALU_SRL; A = 32'h00000001; B = 32'h00000001; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // BEQ = SUB, branch taken when Zero = 1
        op_name = "BEQ "; ALUControl = ALU_SUB; A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "BEQ "; ALUControl = ALU_SUB; A = 32'h00000000; B = 32'h80000000; exp_result = 32'h80000000; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "BEQ "; ALUControl = ALU_SUB; A = 32'h00000001; B = 32'h00000002; exp_result = 32'hFFFFFFFF; exp_zero = 1'b0;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // unused codes give 0
        op_name = "----"; ALUControl = 4'b0111; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "----"; ALUControl = 4'b1000; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        op_name = "----"; ALUControl = 4'b1111; A = 32'h10101010; B = 32'h01010101; exp_result = 32'h00000000; exp_zero = 1'b1;
        #10;
        if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end

        // random operands, 4 per operation
        for (i = 0; i < 28; i = i + 1) begin
            case (i % 7)
                0 : begin ALUControl = ALU_ADD; op_name = "ADD "; end
                1 : begin ALUControl = ALU_SUB; op_name = "SUB "; end
                2 : begin ALUControl = ALU_SLL; op_name = "SLL "; end
                3 : begin ALUControl = ALU_SRL; op_name = "SRL "; end
                4 : begin ALUControl = ALU_AND; op_name = "AND "; end
                5 : begin ALUControl = ALU_OR; op_name = "OR  "; end
                default : begin ALUControl = ALU_XOR; op_name = "XOR "; end
            endcase
            A = $random(seed);
            B = $random(seed);
            // expected value from plain operators, not the ALU's A + ~B + 1
            case (ALUControl)
                ALU_AND : exp_result = A & B;
                ALU_OR : exp_result = A | B;
                ALU_ADD : exp_result = A + B;
                ALU_XOR : exp_result = A ^ B;
                ALU_SLL : exp_result = A << B[4:0];
                ALU_SRL : exp_result = A >> B[4:0];
                ALU_SUB : exp_result = A - B;
                default : exp_result = 32'd0;
            endcase
            exp_zero = (exp_result == 32'd0);
            #10;
            if (ALUResult === exp_result && Zero === exp_zero) begin pass_count = pass_count + 1; $display("PASS  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b", op_name, ALUControl, A, B, ALUResult, Zero); end
            else begin fail_count = fail_count + 1; $display("FAIL  %s ctrl=%b  A=%h  B=%h  ->  ALUResult=%h  Zero=%b   (expected %h  Zero=%b)", op_name, ALUControl, A, B, ALUResult, Zero, exp_result, exp_zero); end
        end

        $display("--------------------------------------------------------------------------");
        $display("ALU_tb finished: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");

        #100
        $finish;
    end

endmodule
