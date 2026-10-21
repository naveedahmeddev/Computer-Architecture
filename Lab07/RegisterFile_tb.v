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

    integer errors = 0;

    RegisterFile dut (
        .clk(clk), .rst(rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    always #5 clk = ~clk;

    task check;
        input [255:0] name;
        input [31:0] got;
        input [31:0] expected;
        begin
            if (got === expected)
                $display("PASS : %0s = 0x%08h", name, got);
            else begin
                $display("FAIL : %0s = 0x%08h, expected 0x%08h", name, got, expected);
                errors = errors + 1;
            end
        end
    endtask

    task write_reg;
        input [4:0] addr;
        input [31:0] data;
        begin
            rd = addr; WriteData = data; WriteEnable = 1'b1;
            @(posedge clk); #1;
            WriteEnable = 1'b0;
        end
    endtask

    initial begin
        $display("--- RegisterFile tests ---");

        // reset clears every register
        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;
        rs1 = 5'd5; rs2 = 5'd6; #1;
        check("after reset x5", ReadData1, 32'd0);
        check("after reset x6", ReadData2, 32'd0);

        // write a value and read it back
        write_reg(5'd5, 32'hDEADBEEF);
        rs1 = 5'd5; #1;
        check("x5 after write", ReadData1, 32'hDEADBEEF);

        // writes to x0 are ignored
        write_reg(5'd0, 32'hFFFFFFFF);
        rs1 = 5'd0; #1;
        check("x0 stays zero", ReadData1, 32'd0);

        // both read ports work at the same time
        write_reg(5'd6, 32'h12345678);
        rs1 = 5'd5; rs2 = 5'd6; #1;
        check("port 1 reads x5", ReadData1, 32'hDEADBEEF);
        check("port 2 reads x6", ReadData2, 32'h12345678);

        rs1 = 5'd6; rs2 = 5'd6; #1;
        check("both ports read x6", ReadData1, 32'h12345678);

        // overwrite replaces the old value
        write_reg(5'd5, 32'hA5A5A5A5);
        rs1 = 5'd5; #1;
        check("x5 overwritten", ReadData1, 32'hA5A5A5A5);

        // nothing is written while WriteEnable is low
        rd = 5'd5; WriteData = 32'h00000000; WriteEnable = 1'b0;
        @(posedge clk); #1;
        rs1 = 5'd5; #1;
        check("x5 held with WriteEnable low", ReadData1, 32'hA5A5A5A5);

        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;
        rs1 = 5'd5; #1;
        check("x5 cleared by second reset", ReadData1, 32'd0);

        if (errors == 0) $display("--- All RegisterFile tests PASSED ---");
        else $display("--- %0d RegisterFile test(s) FAILED ---", errors);
        $finish;
    end

endmodule
