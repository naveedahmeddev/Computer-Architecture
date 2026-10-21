`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Basys 3 top level: FSM steps the Register File and ALU once per second.

module top_rf_alu (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    wire rst_clean;
    wire [31:0] switch_data;
    reg [31:0] led_write_data = 32'd0;
    wire slow_clk;

    debouncer rst_db (
        .clk(clk), .pbin(pbin), .pbout(rst_clean)
    );

    // Lab 5 module "leds" is the one that reads the switches
    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0), .writeData(32'd0), .writeEnable(1'b0),
        .readEnable(1'b1), .memAddress(30'd0),
        .switches(physical_sw), .readData(switch_data)
    );

    // Lab 5 module "switches" is the one that drives the LEDs
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data), .writeEnable(1'b1),
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(), .leds(physical_leds)
    );

    clock_divider ticker (
        .clk_in(clk), .rst(rst_clean), .clk_out(slow_clk)
    );

    // slow_clk is used as a one-cycle enable, not as a clock
    reg slow_clk_d = 1'b0;
    always @(posedge clk)
        slow_clk_d <= slow_clk;

    wire tick = slow_clk & ~slow_clk_d;

    wire [15:0] sw = switch_data[15:0];

    wire [4:0] rs1, rs2, rd;
    wire [31:0] WriteData, ReadData1, ReadData2, ALUResult;
    wire WriteEnable, rf_rst, Zero;
    wire [3:0] ALUControl;
    wire [4:0] state_out;

    rf_alu_fsm fsm (
        .clk(clk), .rst(rst_clean), .step(tick),
        .hold_manual(sw[15]), .manual_op(sw[3:0]),
        .manual_rd(sw[8:4]), .manual_we(sw[14]),
        .ALUResult(ALUResult), .Zero(Zero),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .WriteData(WriteData), .WriteEnable(WriteEnable),
        .rf_rst(rf_rst), .ALUControl(ALUControl), .state_out(state_out)
    );

    RegisterFile rf (
        .clk(clk), .rst(rf_rst), .WriteEnable(WriteEnable),
        .rs1(rs1), .rs2(rs2), .rd(rd), .WriteData(WriteData),
        .ReadData1(ReadData1), .ReadData2(ReadData2)
    );

    ALU alu (
        .A(ReadData1), .B(ReadData2), .ALUControl(ALUControl),
        .ALUResult(ALUResult), .Zero(Zero)
    );

    // sw[13:12] picks which 11 bits of the result the LEDs show
    reg [10:0] result_window;
    always @(*) begin
        case (sw[13:12])
            2'b00 : result_window = ALUResult[10:0];
            2'b01 : result_window = ALUResult[21:11];
            default : result_window = ALUResult[31:21];
        endcase
    end

    // state on the top five LEDs, result window on the rest
    always @(*)
        led_write_data = {16'd0, state_out, result_window};

endmodule
