`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Checks the decoder sends each access to the right device and nothing else.

module MemorySystem_tb;

    reg clk = 1'b0;
    reg rst = 1'b0;
    reg [31:0] address = 32'd0;
    reg readEnable = 1'b0;
    reg writeEnable = 1'b0;
    reg [31:0] writeData = 32'd0;
    reg [15:0] switches = 16'd0;
    wire [31:0] readData;
    wire [15:0] leds;

    reg [31:0] errors = 0;

    // address[9:8] picks the device
    localparam [31:0] DM_A = 32'h004;
    localparam [31:0] DM_B = 32'h0A0;
    localparam [31:0] LED_A = 32'h100;
    localparam [31:0] SW_A = 32'h200;

    addressDecoderTop dut (
        .clk(clk), .rst(rst), .address(address),
        .readEnable(readEnable), .writeEnable(writeEnable),
        .writeData(writeData), .switches(switches),
        .readData(readData), .leds(leds)
    );

    always #5 clk = ~clk;

    initial begin
        $display("--- Memory system with address decoding ---");

        rst = 1'b1; @(posedge clk); #1; rst = 1'b0;

        // ---- data memory, selector 00 ----
        address = DM_A; writeData = 32'hDEADBEEF; writeEnable = 1'b1; readEnable = 1'b0;
        @(posedge clk); #1; writeEnable = 1'b0;
        address = DM_A; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'hDEADBEEF) $display("PASS : DM 0x004 after write = 0x%08h", readData);
        else begin $display("FAIL : DM 0x004 after write = 0x%08h, expected 0x%08h", readData, 32'hDEADBEEF); errors = errors + 1; end

        address = DM_B; writeData = 32'h12345678; writeEnable = 1'b1; readEnable = 1'b0;
        @(posedge clk); #1; writeEnable = 1'b0;
        address = DM_B; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'h12345678) $display("PASS : DM 0x0A0 after write = 0x%08h", readData);
        else begin $display("FAIL : DM 0x0A0 after write = 0x%08h, expected 0x%08h", readData, 32'h12345678); errors = errors + 1; end

        address = DM_A; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'hDEADBEEF) $display("PASS : DM 0x004 still holds = 0x%08h", readData);
        else begin $display("FAIL : DM 0x004 still holds = 0x%08h, expected 0x%08h", readData, 32'hDEADBEEF); errors = errors + 1; end

        // ---- LEDs, selector 01, write only ----
        address = LED_A; writeData = 32'h0000ABCD; writeEnable = 1'b1; readEnable = 1'b0;
        @(posedge clk); #1; writeEnable = 1'b0;
        if ({16'd0, leds} === 32'h0000ABCD) $display("PASS : LEDs after write = 0x%08h", {16'd0, leds});
        else begin $display("FAIL : LEDs after write = 0x%08h, expected 0x%08h", {16'd0, leds}, 32'h0000ABCD); errors = errors + 1; end

        // a write to the LED range must not reach memory
        address = DM_A; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'hDEADBEEF) $display("PASS : DM 0x004 untouched by LED write = 0x%08h", readData);
        else begin $display("FAIL : DM 0x004 untouched by LED write = 0x%08h, expected 0x%08h", readData, 32'hDEADBEEF); errors = errors + 1; end

        // ---- switches, selector 10, read only ----
        // readEnable stays high after the edge, otherwise a switch read would
        // disappear before it can be checked
        switches = 16'h1234; #1;
        address = SW_A; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'h00001234) $display("PASS : switch read = 0x%08h", readData);
        else begin $display("FAIL : switch read = 0x%08h, expected 0x%08h", readData, 32'h00001234); errors = errors + 1; end

        switches = 16'hF0F0; #1;
        address = SW_A; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'h0000F0F0) $display("PASS : switch read again = 0x%08h", readData);
        else begin $display("FAIL : switch read again = 0x%08h, expected 0x%08h", readData, 32'h0000F0F0); errors = errors + 1; end

        // a read of the switch range must not disturb the LEDs
        if ({16'd0, leds} === 32'h0000ABCD) $display("PASS : LEDs held during switch read = 0x%08h", {16'd0, leds});
        else begin $display("FAIL : LEDs held during switch read = 0x%08h, expected 0x%08h", {16'd0, leds}, 32'h0000ABCD); errors = errors + 1; end

        // ---- a write to a memory address must not reach the LEDs ----
        address = DM_B; writeData = 32'h0000FFFF; writeEnable = 1'b1; readEnable = 1'b0;
        @(posedge clk); #1; writeEnable = 1'b0;
        if ({16'd0, leds} === 32'h0000ABCD) $display("PASS : LEDs untouched by DM write = 0x%08h", {16'd0, leds});
        else begin $display("FAIL : LEDs untouched by DM write = 0x%08h, expected 0x%08h", {16'd0, leds}, 32'h0000ABCD); errors = errors + 1; end

        // ---- the unused range, selector 11 ----
        address = 32'h300; writeData = 32'h0000AAAA; writeEnable = 1'b1; readEnable = 1'b0;
        @(posedge clk); #1; writeEnable = 1'b0;
        if ({16'd0, leds} === 32'h0000ABCD) $display("PASS : LEDs untouched by unused-range write = 0x%08h", {16'd0, leds});
        else begin $display("FAIL : LEDs untouched by unused-range write = 0x%08h, expected 0x%08h", {16'd0, leds}, 32'h0000ABCD); errors = errors + 1; end

        address = DM_B; readEnable = 1'b1; writeEnable = 1'b0;
        @(posedge clk); #1;
        if (readData === 32'h0000FFFF) $display("PASS : DM 0x0A0 holds its own value = 0x%08h", readData);
        else begin $display("FAIL : DM 0x0A0 holds its own value = 0x%08h, expected 0x%08h", readData, 32'h0000FFFF); errors = errors + 1; end

        if (errors == 0) $display("--- All memory system tests PASSED ---");
        else $display("--- %0d memory system test(s) FAILED ---", errors);
        $finish;
    end

endmodule
