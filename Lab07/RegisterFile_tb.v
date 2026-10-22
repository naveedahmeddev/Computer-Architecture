`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Testbench for RegisterFile.v covering the five cases in Lab 7 Task 2(b).

module RegisterFile_tb;

    reg clk = 1'b0;
    reg rst = 1'b0;
    reg WriteEnable = 1'b0;
    reg [4:0] rs1 = 5'd0;
    reg [4:0] rs2 = 5'd0;
    reg [4:0] rd = 5'd0;
    reg [31:0] WriteData = 32'd0;
    wire [31:0] ReadData1, ReadData2;

    reg [31:0] errors = 0;

    RegisterFile dut (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    always #5 clk = ~clk;

    initial begin
        $display("--- RegisterFile tests ---");

        // reset clears every register
        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;
        rs1 = 5'd5; rs2 = 5'd6; #1;
        if (ReadData1 === 32'd0) $display("PASS : after reset x5 = 0x%08h", ReadData1);
        else begin $display("FAIL : after reset x5 = 0x%08h, expected 0x%08h", ReadData1, 32'd0); errors = errors + 1; end
        if (ReadData2 === 32'd0) $display("PASS : after reset x6 = 0x%08h", ReadData2);
        else begin $display("FAIL : after reset x6 = 0x%08h, expected 0x%08h", ReadData2, 32'd0); errors = errors + 1; end

        // write a value and read it back
        rd = 5'd5; WriteData = 32'hDEADBEEF; WriteEnable = 1'b1;
        @(posedge clk); #1; WriteEnable = 1'b0;
        rs1 = 5'd5; #1;
        if (ReadData1 === 32'hDEADBEEF) $display("PASS : x5 after write = 0x%08h", ReadData1);
        else begin $display("FAIL : x5 after write = 0x%08h, expected 0x%08h", ReadData1, 32'hDEADBEEF); errors = errors + 1; end

        // writes to x0 are ignored
        rd = 5'd0; WriteData = 32'hFFFFFFFF; WriteEnable = 1'b1;
        @(posedge clk); #1; WriteEnable = 1'b0;
        rs1 = 5'd0; #1;
        if (ReadData1 === 32'd0) $display("PASS : x0 stays zero = 0x%08h", ReadData1);
        else begin $display("FAIL : x0 stays zero = 0x%08h, expected 0x%08h", ReadData1, 32'd0); errors = errors + 1; end

        // both read ports work at the same time
        rd = 5'd6; WriteData = 32'h12345678; WriteEnable = 1'b1;
        @(posedge clk); #1; WriteEnable = 1'b0;
        rs1 = 5'd5; rs2 = 5'd6; #1;
        if (ReadData1 === 32'hDEADBEEF) $display("PASS : port 1 reads x5 = 0x%08h", ReadData1);
        else begin $display("FAIL : port 1 reads x5 = 0x%08h, expected 0x%08h", ReadData1, 32'hDEADBEEF); errors = errors + 1; end
        if (ReadData2 === 32'h12345678) $display("PASS : port 2 reads x6 = 0x%08h", ReadData2);
        else begin $display("FAIL : port 2 reads x6 = 0x%08h, expected 0x%08h", ReadData2, 32'h12345678); errors = errors + 1; end

        rs1 = 5'd6; rs2 = 5'd6; #1;
        if (ReadData1 === 32'h12345678) $display("PASS : both ports read x6 = 0x%08h", ReadData1);
        else begin $display("FAIL : both ports read x6 = 0x%08h, expected 0x%08h", ReadData1, 32'h12345678); errors = errors + 1; end

        // overwrite replaces the old value
        rd = 5'd5; WriteData = 32'hA5A5A5A5; WriteEnable = 1'b1;
        @(posedge clk); #1; WriteEnable = 1'b0;
        rs1 = 5'd5; #1;
        if (ReadData1 === 32'hA5A5A5A5) $display("PASS : x5 overwritten = 0x%08h", ReadData1);
        else begin $display("FAIL : x5 overwritten = 0x%08h, expected 0x%08h", ReadData1, 32'hA5A5A5A5); errors = errors + 1; end

        // nothing is written while WriteEnable is low
        rd = 5'd5; WriteData = 32'h00000000; WriteEnable = 1'b0;
        @(posedge clk); #1;
        rs1 = 5'd5; #1;
        if (ReadData1 === 32'hA5A5A5A5) $display("PASS : x5 held with WriteEnable low = 0x%08h", ReadData1);
        else begin $display("FAIL : x5 held with WriteEnable low = 0x%08h, expected 0x%08h", ReadData1, 32'hA5A5A5A5); errors = errors + 1; end

        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;
        rs1 = 5'd5; #1;
        if (ReadData1 === 32'd0) $display("PASS : x5 cleared by second reset = 0x%08h", ReadData1);
        else begin $display("FAIL : x5 cleared by second reset = 0x%08h, expected 0x%08h", ReadData1, 32'd0); errors = errors + 1; end

        if (errors == 0) $display("--- All RegisterFile tests PASSED ---");
        else $display("--- %0d RegisterFile test(s) FAILED ---", errors);
        $finish;
    end

endmodule
