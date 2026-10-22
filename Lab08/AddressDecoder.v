`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Picks one device from address[9:8] and enables it only for the access it supports.

module AddressDecoder (
    input wire [31:0] addr,
    input wire readEnable,
    input wire writeEnable,
    output wire DataMemWrite,
    output wire DataMemRead,
    output wire LEDWrite,
    output wire SwitchReadEnable
);

    localparam SEL_DM = 2'b00;
    localparam SEL_LED = 2'b01;
    localparam SEL_SW = 2'b10;

    wire [1:0] Selector = addr[9:8];

    assign DataMemWrite = (Selector == SEL_DM) & writeEnable;
    assign DataMemRead = (Selector == SEL_DM) & readEnable;
    // LEDs are write only, switches are read only
    assign LEDWrite = (Selector == SEL_LED) & writeEnable;
    assign SwitchReadEnable = (Selector == SEL_SW) & readEnable;

endmodule
