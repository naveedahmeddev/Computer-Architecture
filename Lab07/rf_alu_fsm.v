`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Navidia
// Engineer: ZaiNaveed

// FSM that drives the Register File and ALU through a fixed test sequence.

module rf_alu_fsm (
    input wire clk,
    input wire rst,
    input wire step,
    input wire hold_manual,
    input wire [3:0] manual_op,
    input wire [4:0] manual_rd,
    input wire manual_we,

    input wire [31:0] ALUResult,
    input wire Zero,

    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [4:0] rd,
    output reg [31:0] WriteData,
    output reg WriteEnable,
    output reg rf_rst,
    output reg [3:0] ALUControl,
    output wire [4:0] state_out
);

    localparam S_RESET = 5'd0;
    localparam S_W1 = 5'd1;
    localparam S_W2 = 5'd2;
    localparam S_W3 = 5'd3;
    localparam S_ADD = 5'd4;
    localparam S_SUB = 5'd5;
    localparam S_AND = 5'd6;
    localparam S_OR = 5'd7;
    localparam S_XOR = 5'd8;
    localparam S_SLL = 5'd9;
    localparam S_SRL = 5'd10;
    localparam S_BEQ_NE = 5'd11;
    localparam S_BEQ_EQ = 5'd12;
    localparam S_RAW_W = 5'd13;
    localparam S_RAW_R = 5'd14;
    localparam S_MANUAL = 5'd15;
    localparam S_DONE = 5'd16;

    // must match the encoding in ALU.v
    localparam OP_AND = 4'b0000;
    localparam OP_OR = 4'b0001;
    localparam OP_ADD = 4'b0010;
    localparam OP_XOR = 4'b0011;
    localparam OP_SLL = 4'b0100;
    localparam OP_SRL = 4'b0101;
    localparam OP_SUB = 4'b0110;
    localparam OP_BEQ = 4'b0110;   // BEQ subtracts, the answer is on Zero

    reg [4:0] state = S_RESET;
    assign state_out = state;

    always @(posedge clk) begin
        if (rst)
            state <= S_RESET;
        else if (step) begin
            case (state)
                S_MANUAL : state <= hold_manual ? S_MANUAL : S_DONE;
                S_DONE : state <= S_DONE;
                default : state <= state + 1'b1;
            endcase
        end
    end

    always @(*) begin
        rs1 = 5'd0;
        rs2 = 5'd0;
        rd = 5'd0;
        WriteData = 32'd0;
        WriteEnable = 1'b0;
        rf_rst = 1'b0;
        ALUControl = OP_ADD;

        case (state)
            S_RESET : rf_rst = 1'b1;

            S_W1 : begin rd = 5'd1; WriteData = 32'h10101010; WriteEnable = 1'b1; end
            S_W2 : begin rd = 5'd2; WriteData = 32'h01010101; WriteEnable = 1'b1; end
            S_W3 : begin rd = 5'd3; WriteData = 32'h00000005; WriteEnable = 1'b1; end

            S_ADD : begin rs1=5'd1; rs2=5'd2; ALUControl=OP_ADD; rd=5'd4; WriteData=ALUResult; WriteEnable=1'b1; end
            S_SUB : begin rs1=5'd1; rs2=5'd2; ALUControl=OP_SUB; rd=5'd5; WriteData=ALUResult; WriteEnable=1'b1; end
            S_AND : begin rs1=5'd1; rs2=5'd2; ALUControl=OP_AND; rd=5'd6; WriteData=ALUResult; WriteEnable=1'b1; end
            S_OR : begin rs1=5'd1; rs2=5'd2; ALUControl=OP_OR; rd=5'd7; WriteData=ALUResult; WriteEnable=1'b1; end
            S_XOR : begin rs1=5'd1; rs2=5'd2; ALUControl=OP_XOR; rd=5'd8; WriteData=ALUResult; WriteEnable=1'b1; end

            // x3 holds the shift amount
            S_SLL : begin rs1=5'd1; rs2=5'd3; ALUControl=OP_SLL; rd=5'd9; WriteData=ALUResult; WriteEnable=1'b1; end
            S_SRL : begin rs1=5'd1; rs2=5'd3; ALUControl=OP_SRL; rd=5'd10; WriteData=ALUResult; WriteEnable=1'b1; end

            // conditional write: x11 is written only when Zero is set
            S_BEQ_NE : begin rs1=5'd1; rs2=5'd2; ALUControl=OP_BEQ;
                             rd=5'd11; WriteData=32'd1; WriteEnable=Zero; end
            S_BEQ_EQ : begin rs1=5'd1; rs2=5'd1; ALUControl=OP_BEQ;
                             rd=5'd11; WriteData=32'd1; WriteEnable=Zero; end

            S_RAW_W : begin rd=5'd12; WriteData=32'hCAFEBABE; WriteEnable=1'b1; end
            S_RAW_R : begin rs1=5'd12; rs2=5'd4; end

            // gated with step, otherwise the write would fire on every clock
            S_MANUAL : begin rs1=5'd1; rs2=5'd2; ALUControl=manual_op;
                             rd=manual_rd; WriteData=ALUResult;
                             WriteEnable=manual_we & step; end

            S_DONE : begin rs1=5'd4; rs2=5'd10; end
        endcase
    end

endmodule
