`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Basys 3 top level: the FSM steps once per second through the memory system.

module top_mem_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire slow_clk;

    debouncer rst_db (
        .clk(clk), .pbin(pbin), .pbout(rst_clean)
    );

    clock_divider ticker (
        .clk_in(clk), .rst(rst_clean), .clk_out(slow_clk)
    );

    // slow_clk is used as a one-cycle enable, not as a clock
    reg slow_clk_d = 1'b0;
    always @(posedge clk)
        slow_clk_d <= slow_clk;

    wire tick = slow_clk & ~slow_clk_d;

    wire [31:0] address, writeData, readData;
    wire readEnable, writeEnable;
    wire [2:0] state_out;

    mem_fsm fsm (
        .clk(clk), .rst(rst_clean), .step(tick), .readData(readData),
        .address(address), .readEnable(readEnable), .writeEnable(writeEnable),
        .writeData(writeData), .state_out(state_out)
    );

    addressDecoderTop memsys (
        .clk(clk), .rst(rst_clean), .address(address),
        .readEnable(readEnable), .writeEnable(writeEnable),
        .writeData(writeData), .switches(physical_sw),
        .readData(readData), .leds(physical_leds)
    );

endmodule
