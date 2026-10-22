`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Memory system the processor talks to: decoder, data memory, LEDs and switches.

module addressDecoderTop (
    input wire clk,
    input wire rst,
    input wire [31:0] address,
    input wire readEnable,
    input wire writeEnable,
    input wire [31:0] writeData,
    input wire [15:0] switches,
    output reg [31:0] readData,
    output wire [15:0] leds
);

    wire DataMemWrite, DataMemRead, LEDWrite, SwitchReadEnable;
    wire [31:0] datamemout;
    wire [31:0] switch_readData;

    AddressDecoder decoder (
        .addr(address), .readEnable(readEnable), .writeEnable(writeEnable),
        .DataMemWrite(DataMemWrite), .DataMemRead(DataMemRead),
        .LEDWrite(LEDWrite), .SwitchReadEnable(SwitchReadEnable)
    );

    DataMemory dmem (
        .clk(clk), .rst(rst), .memwrite(DataMemWrite),
        .addr(address), .writedata(writeData), .datamemout(datamemout)
    );

    // Lab 5 module "leds" is the one that reads the switches
    leds switch_reader (
        .clk(clk), .rst(rst),
        .btns(16'd0), .writeData(32'd0), .writeEnable(1'b0),
        .readEnable(SwitchReadEnable), .memAddress(address[31:2]),
        .switches(switches), .readData(switch_readData)
    );

    // Lab 5 module "switches" is the one that drives the LEDs
    switches led_writer (
        .clk(clk), .rst(rst),
        .writeData(writeData), .writeEnable(LEDWrite),
        .readEnable(1'b0), .memAddress(address[31:2]),
        .readData(), .leds(leds)
    );

    // the memory answers a cycle late, so remember that a memory read was asked for
    reg dmem_read_d = 1'b0;
    always @(posedge clk)
        dmem_read_d <= rst ? 1'b0 : DataMemRead;

    always @(*) begin
        if (dmem_read_d)
            readData = datamemout;
        else if (SwitchReadEnable)
            readData = switch_readData;
        else
            readData = 32'd0;
    end

endmodule
