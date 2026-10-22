`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Moves a value from the switches into data memory and back out to the LEDs.

module mem_fsm (
    input wire clk,
    input wire rst,
    input wire step,
    input wire [31:0] readData,

    output reg [31:0] address,
    output reg readEnable,
    output reg writeEnable,
    output reg [31:0] writeData,
    output wire [2:0] state_out
);

    localparam S_RESET = 3'd0;
    localparam S_READ_SW = 3'd1;
    localparam S_WRITE_MEM = 3'd2;
    localparam S_READ_MEM = 3'd3;
    localparam S_WRITE_LED = 3'd4;
    localparam S_DONE = 3'd5;

    localparam [31:0] DM_ADDR = 32'h004;
    localparam [31:0] LED_ADDR = 32'h100;
    localparam [31:0] SW_ADDR = 32'h200;

    reg [2:0] state = S_RESET;
    reg [31:0] held = 32'd0;
    assign state_out = state;

    always @(posedge clk) begin
        if (rst)
            state <= S_RESET;
        else if (step)
            state <= (state == S_DONE) ? S_DONE : state + 1'b1;
    end

    // grab what was read at the end of each read state, while readData is still valid
    always @(posedge clk) begin
        if (rst)
            held <= 32'd0;
        else if (step && (state == S_READ_SW || state == S_READ_MEM))
            held <= readData;
    end

    always @(*) begin
        address = 32'd0;
        readEnable = 1'b0;
        writeEnable = 1'b0;
        writeData = held;

        case (state)
            S_READ_SW : begin address = SW_ADDR; readEnable = 1'b1; end
            S_WRITE_MEM : begin address = DM_ADDR; writeEnable = 1'b1; end
            S_READ_MEM : begin address = DM_ADDR; readEnable = 1'b1; end
            S_WRITE_LED : begin address = LED_ADDR; writeEnable = 1'b1; end
        endcase
    end

endmodule
