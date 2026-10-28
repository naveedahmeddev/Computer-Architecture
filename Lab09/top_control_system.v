`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// Basys 3 top level: FSM reads the instruction fields from the switches and shows the control signals on the LEDs.
// sw[6:0] = opcode, sw[9:7] = funct3, sw[10] = funct7[5]. Only funct7[5] matters (ADD/SUB), so the other funct7 bits are 0.
// led[3:0] = ALUControl, led[5:4] = ALUOp, led[6] = Branch, led[7] = MemtoReg,
// led[8] = MemWrite, led[9] = MemRead, led[10] = ALUSrc, led[11] = RegWrite.

module top_control_system(
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    localparam S_IDLE = 2'd0;
    localparam S_READ = 2'd1;
    localparam S_DECODE = 2'd2;
    localparam S_WRITE = 2'd3;

    wire rst_clean;
    wire [31:0] switch_data;
    wire sw_read_en;
    wire led_write_en;

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

    reg [11:0] ctrl_reg = 12'd0;

    // Lab 5 module "switches" is the one that drives the LEDs
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData({20'd0, ctrl_reg}),
        .writeEnable(led_write_en),
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(),
        .leds(physical_leds)
    );

    reg [1:0] state = S_IDLE;
    reg [1:0] next_state;
    reg [15:0] sw_reg = 16'd0;

    wire [6:0] opcode = sw_reg[6:0];
    wire [2:0] funct3 = sw_reg[9:7];
    wire [6:0] funct7 = {1'b0, sw_reg[10], 5'd0};

    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp;
    wire [3:0] ALUCtrl;

    MainControl main_ctrl (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    ALUControl alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControl(ALUCtrl)
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
            S_READ : next_state = S_DECODE;
            S_DECODE : next_state = S_WRITE;
            S_WRITE : next_state = S_READ;
            default : next_state = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (rst_clean) begin
            sw_reg <= 16'd0;
            ctrl_reg <= 12'd0;
        end
        else begin
            case (state)
                S_READ : sw_reg <= switch_data[15:0];
                S_DECODE : ctrl_reg <= {RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, ALUOp, ALUCtrl};
            endcase
        end
    end

    assign sw_read_en = (state == S_READ);
    assign led_write_en = (state == S_WRITE);

endmodule
