`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Self-checking testbench for top_alu_system.v. Run is ~5 us, so press Run All.

module tb_top_alu_system;

    localparam STEP = 20;

    localparam ALU_AND = 4'b0000;
    localparam ALU_OR = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;

    localparam V_LOW = 2'b00;
    localparam V_HIGH = 2'b01;
    localparam V_STATUS = 2'b10;

    reg clk = 1'b0;
    reg pbin = 1'b0;
    reg [15:0] physical_sw = 16'd0;
    wire [15:0] physical_leds;
    wire [15:0] leds_halves;

    reg [31:0] op_name = "----";
    reg [15:0] exp_main = 16'd0;
    reg [15:0] exp_halves = 16'd0;
    reg [31:0] n = 0;

    reg [31:0] pass_count = 0;
    reg [31:0] fail_count = 0;

    top_alu_system #(
        .STEP_CYCLES(STEP)
    ) dut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );

    // Second copy with operands whose halves differ, so the half-select is really tested
    top_alu_system #(
        .OPERAND_A(32'hABCD1234),
        .OPERAND_B(32'h00000004),
        .STEP_CYCLES(STEP)
    ) dut_halves (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(leds_halves)
    );

    always #5 clk = ~clk;

    // physical_sw = {auto mode, view, B = A, 8'd0, ALUControl}
    initial begin
        $dumpfile("tb_top_alu_system.vcd");
        $dumpvars(0, tb_top_alu_system);

        pbin = 1'b1;
        repeat (4) @(posedge clk);
        #1;
        if (physical_leds === 16'd0 && leds_halves === 16'd0) begin
            pass_count = pass_count + 1;
            $display("PASS  RST  leds are dark while reset is held");
        end
        else begin
            fail_count = fail_count + 1;
            $display("FAIL  RST  leds=%h leds_halves=%h while reset is held", physical_leds, leds_halves);
        end
        pbin = 1'b0;

        // manual mode, low half of ALUResult
        op_name = "ADD "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_ADD}; exp_main = 16'h1111; exp_halves = 16'h1238;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SUB "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_SUB}; exp_main = 16'h0F0F; exp_halves = 16'h1230;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SLL "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_SLL}; exp_main = 16'h2020; exp_halves = 16'h2340;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SRL "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_SRL}; exp_main = 16'h0808; exp_halves = 16'hD123;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "AND "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_AND}; exp_main = 16'h0000; exp_halves = 16'h0004;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "OR  "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_OR}; exp_main = 16'h1111; exp_halves = 16'h1234;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "XOR "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_XOR}; exp_main = 16'h1111; exp_halves = 16'h1230;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "----"; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, 4'b0111}; exp_main = 16'h0000; exp_halves = 16'h0000;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end

        // manual mode, high half of ALUResult
        op_name = "ADD "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_ADD}; exp_main = 16'h1111; exp_halves = 16'hABCD;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SUB "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_SUB}; exp_main = 16'h0F0F; exp_halves = 16'hABCD;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SLL "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_SLL}; exp_main = 16'h2020; exp_halves = 16'hBCD1;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SRL "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_SRL}; exp_main = 16'h0808; exp_halves = 16'h0ABC;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "AND "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_AND}; exp_main = 16'h0000; exp_halves = 16'h0000;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "OR  "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_OR}; exp_main = 16'h1111; exp_halves = 16'hABCD;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "XOR "; physical_sw = {1'b0, V_HIGH, 1'b0, 8'd0, ALU_XOR}; exp_main = 16'h1111; exp_halves = 16'hABCD;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end

        // manual mode, status view {Zero, 0, step, ALUControl}
        op_name = "ADD "; physical_sw = {1'b0, V_STATUS, 1'b0, 8'd0, ALU_ADD}; exp_main = 16'h0002; exp_halves = 16'h0002;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "AND "; physical_sw = {1'b0, V_STATUS, 1'b0, 8'd0, ALU_AND}; exp_main = 16'h8000; exp_halves = 16'h0000;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "BEQ "; physical_sw = {1'b0, V_STATUS, 1'b0, 8'd0, ALU_SUB}; exp_main = 16'h0006; exp_halves = 16'h0006;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "----"; physical_sw = {1'b0, V_STATUS, 1'b0, 8'd0, 4'b0111}; exp_main = 16'h8007; exp_halves = 16'h8007;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end

        // B = A, so BEQ is taken
        op_name = "BEQ "; physical_sw = {1'b0, V_STATUS, 1'b1, 8'd0, ALU_SUB}; exp_main = 16'h8006; exp_halves = 16'h8006;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "BEQ "; physical_sw = {1'b0, 2'b11, 1'b1, 8'd0, ALU_SUB}; exp_main = 16'h8006; exp_halves = 16'h8006;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SUB "; physical_sw = {1'b0, V_LOW, 1'b1, 8'd0, ALU_SUB}; exp_main = 16'h0000; exp_halves = 16'h0000;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "ADD "; physical_sw = {1'b0, V_LOW, 1'b1, 8'd0, ALU_ADD}; exp_main = 16'h2020; exp_halves = 16'h2468;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "ADD "; physical_sw = {1'b0, V_HIGH, 1'b1, 8'd0, ALU_ADD}; exp_main = 16'h2020; exp_halves = 16'h579A;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "XOR "; physical_sw = {1'b0, V_LOW, 1'b1, 8'd0, ALU_XOR}; exp_main = 16'h0000; exp_halves = 16'h0000;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end

        // auto mode, status view. sw[3:0] = 1111 on purpose: it must be ignored
        physical_sw = {1'b1, V_STATUS, 1'b0, 8'd0, 4'b1111};
        // the wait limit is shorter than one full round, so a skipped step fails
        op_name = "ADD "; exp_main = 16'h0002; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "SUB "; exp_main = 16'h0016; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "SLL "; exp_main = 16'h0024; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "SRL "; exp_main = 16'h0035; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "AND "; exp_main = 16'h8040; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "OR  "; exp_main = 16'h0051; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "XOR "; exp_main = 16'h0063; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "BEQ "; exp_main = 16'h0076; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "ADD "; exp_main = 16'h0002; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end

        // reset in the middle of auto mode
        op_name = "SUB "; exp_main = 16'h0016; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        pbin = 1'b1;
        repeat (3) @(posedge clk);
        #1;
        if (physical_leds === 16'd0) begin
            pass_count = pass_count + 1;
            $display("PASS  RST  leds cleared by reset during auto mode");
        end
        else begin
            fail_count = fail_count + 1;
            $display("FAIL  RST  leds=%h, reset during auto mode did not clear them", physical_leds);
        end
        pbin = 1'b0;
        op_name = "ADD "; exp_main = 16'h0002; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end

        // back to manual mode: the step field goes back to 0
        op_name = "SUB "; exp_main = 16'h0016; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "ADD "; physical_sw = {1'b0, V_STATUS, 1'b0, 8'd0, ALU_ADD}; exp_main = 16'h0002; exp_halves = 16'h0002;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end
        op_name = "SRL "; physical_sw = {1'b0, V_LOW, 1'b0, 8'd0, ALU_SRL}; exp_main = 16'h0808; exp_halves = 16'hD123;
        repeat (10) @(posedge clk); #1;
        if (physical_leds === exp_main && leds_halves === exp_halves) begin pass_count = pass_count + 1; $display("PASS  %s sw=%b  leds=%h  leds_halves=%h", op_name, physical_sw, physical_leds, leds_halves); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s sw=%b  leds=%h  leds_halves=%h   (expected %h / %h)", op_name, physical_sw, physical_leds, leds_halves, exp_main, exp_halves); end

        // auto mode again: starts from ADD, not from where it stopped
        physical_sw = {1'b1, V_STATUS, 1'b0, 8'd0, 4'b0000};
        op_name = "ADD "; exp_main = 16'h0002; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end
        op_name = "SUB "; exp_main = 16'h0016; n = 0;
        while (physical_leds !== exp_main && n < 2*STEP + 10) begin @(posedge clk); n = n + 1; end
        #1;
        if (physical_leds === exp_main) begin pass_count = pass_count + 1; $display("PASS  %s auto step  leds=%h  (after %0d clocks)", op_name, physical_leds, n); end
        else begin fail_count = fail_count + 1; $display("FAIL  %s auto step  leds=%h   (expected %h)", op_name, physical_leds, exp_main); end

        $display("--------------------------------------------------------------------------");
        $display("tb_top_alu_system finished: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");
        $finish;
    end

endmodule
