`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Testbench for top_control_system.v. sw[10] = funct7[5], sw[9:7] = funct3, sw[6:0] = opcode.

module tb_top_control_system;

    reg clk = 1'b0;
    reg pbin = 1'b0;
    reg [15:0] physical_sw = 16'd0;
    wire [15:0] physical_leds;

    top_control_system dut (
        .clk(clk),
        .pbin(pbin),
        .physical_sw(physical_sw),
        .physical_leds(physical_leds)
    );

    always #5 clk = ~clk;

    initial begin
        $monitor("%0t rst=%b sw=%b leds=%b", $time, pbin, physical_sw, physical_leds);

        // reset first, leds stay off
        pbin = 1'b1;
        physical_sw = 16'b00000_0_000_0110011;
        #40;
        pbin = 1'b0;

        // ADD
        physical_sw = 16'b00000_0_000_0110011; #100;
        // SUB
        physical_sw = 16'b00000_1_000_0110011; #100;
        // SLL
        physical_sw = 16'b00000_0_001_0110011; #100;
        // SRL
        physical_sw = 16'b00000_0_101_0110011; #100;
        // AND
        physical_sw = 16'b00000_0_111_0110011; #100;
        // OR
        physical_sw = 16'b00000_0_110_0110011; #100;
        // XOR
        physical_sw = 16'b00000_0_100_0110011; #100;
        // ADDI
        physical_sw = 16'b00000_0_000_0010011; #100;
        // LW
        physical_sw = 16'b00000_0_010_0000011; #100;
        // LH
        physical_sw = 16'b00000_0_001_0000011; #100;
        // LB
        physical_sw = 16'b00000_0_000_0000011; #100;
        // SW
        physical_sw = 16'b00000_0_010_0100011; #100;
        // SH
        physical_sw = 16'b00000_0_001_0100011; #100;
        // SB
        physical_sw = 16'b00000_0_000_0100011; #100;
        // BEQ
        physical_sw = 16'b00000_0_000_1100011; #100;

        // reset in the middle clears the leds
        pbin = 1'b1; #40;
        pbin = 1'b0; #100;

        $finish;
    end

endmodule
