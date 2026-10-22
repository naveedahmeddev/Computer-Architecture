`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Basys 3 top level: FSM reads the switches, runs the ALU and drives the LEDs.

module top_alu_system #(
    parameter [31:0] OPERAND_A = 32'h10101010,
    parameter [31:0] OPERAND_B = 32'h01010101,
    parameter STEP_CYCLES = 200_000_000
)(
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // ALU codes, must match ALU.v
    localparam ALU_AND = 4'b0000;
    localparam ALU_OR = 4'b0001;
    localparam ALU_ADD = 4'b0010;
    localparam ALU_XOR = 4'b0011;
    localparam ALU_SLL = 4'b0100;
    localparam ALU_SRL = 4'b0101;
    localparam ALU_SUB = 4'b0110;

    localparam S_IDLE = 2'd0;
    localparam S_READ = 2'd1;
    localparam S_EXEC = 2'd2;
    localparam S_WRITE = 2'd3;

    wire rst_clean;
    wire [31:0] switch_data;
    wire sw_read_en;
    wire led_write_en;
    reg [31:0] led_write_data;

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean)
    );

    // Lab 5 module "leds" is the one that reads the switches
    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0),
        .writeData(32'd0),
        .writeEnable(1'b0),
        .readEnable(sw_read_en),
        .memAddress(30'd0),
        .switches(physical_sw),
        .readData(switch_data)
    );

    // Lab 5 module "switches" is the one that drives the LEDs
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(led_write_en),
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

    reg [1:0] state = S_IDLE;
    reg [1:0] next_state;

    reg [15:0] sw_reg = 16'd0;
    reg [31:0] result_reg = 32'd0;
    reg zero_reg = 1'b0;
    reg [3:0] ctrl_reg = 4'd0;
    reg [2:0] step_reg = 3'd0;

    reg [31:0] step_timer = 32'd0;
    reg [2:0] step = 3'd0;

    wire [3:0] sw_alu_ctrl = sw_reg[3:0];
    wire sw_b_eq_a = sw_reg[12];
    wire [1:0] sw_view = sw_reg[14:13];
    wire sw_auto = sw_reg[15];

    wire step_tick = (step_timer == STEP_CYCLES - 1);

    // In manual mode the timer and the step stay at 0, so auto mode always starts at ADD
    always @(posedge clk) begin
        if (rst_clean || !sw_auto || step_tick)
            step_timer <= 32'd0;
        else
            step_timer <= step_timer + 1'b1;
    end

    always @(posedge clk) begin
        if (rst_clean || !sw_auto)
            step <= 3'd0;
        else if (step_tick)
            step <= step + 1'b1;
    end

    reg [3:0] auto_ctrl;
    always @(*) begin
        case (step)
            3'd0 : auto_ctrl = ALU_ADD;
            3'd1 : auto_ctrl = ALU_SUB;
            3'd2 : auto_ctrl = ALU_SLL;
            3'd3 : auto_ctrl = ALU_SRL;
            3'd4 : auto_ctrl = ALU_AND;
            3'd5 : auto_ctrl = ALU_OR;
            3'd6 : auto_ctrl = ALU_XOR;
            default : auto_ctrl = ALU_SUB;   // 7: BEQ is SUB, the answer is on Zero
        endcase
    end

    wire [3:0] alu_ctrl = sw_auto ? auto_ctrl : sw_alu_ctrl;
    wire [31:0] alu_b = sw_b_eq_a ? OPERAND_A : OPERAND_B;
    wire [31:0] alu_result;
    wire alu_zero;

    ALU alu_unit (
        .A(OPERAND_A),
        .B(alu_b),
        .ALUControl(alu_ctrl),
        .ALUResult(alu_result),
        .Zero(alu_zero)
    );

    always @(posedge clk) begin
        if (rst_clean)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S_IDLE : next_state = S_READ;
            S_READ : next_state = S_EXEC;
            S_EXEC : next_state = S_WRITE;
            S_WRITE : next_state = S_READ;
            default : next_state = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (rst_clean) begin
            sw_reg <= 16'd0;
            result_reg <= 32'd0;
            zero_reg <= 1'b0;
            ctrl_reg <= 4'd0;
            step_reg <= 3'd0;
        end
        else begin
            case (state)
                S_READ : sw_reg <= switch_data[15:0];
                S_EXEC : begin
                    result_reg <= alu_result;
                    zero_reg <= alu_zero;
                    ctrl_reg <= alu_ctrl;
                    step_reg <= step;
                end
            endcase
        end
    end

    assign sw_read_en = (state == S_READ);
    assign led_write_en = (state == S_WRITE);

    always @(*) begin
        case (sw_view)
            2'b00 : led_write_data = {16'd0, result_reg[15:0]};
            2'b01 : led_write_data = {16'd0, result_reg[31:16]};
            default : led_write_data = {16'd0, zero_reg, 8'd0, step_reg, ctrl_reg};
        endcase
    end

endmodule
