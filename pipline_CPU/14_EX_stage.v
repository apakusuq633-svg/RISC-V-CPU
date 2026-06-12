module EX_stage(
    input wire clk,
    input wire rst,
    input wire [31:0] RD1,
    input wire [31:0] RD2,
    input wire [31:0] imm,
    input wire [31:0] PC,
    input wire [2:0] ALUControl,
    input wire ALUSrc,
    input wire [1:0] ForwardAE,
    input wire [1:0] ForwardBE,
    input wire [31:0] ALU_result_M,
    input wire [31:0] write_data_W,
    
    output wire [31:0] ALU_result,
    output wire zero_flag,
    output wire [31:0] branch_target
);
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] SrcB_nomux;
    
    // 转发逻辑：选择ALU的第一个操作数
    mux_3to1 #(.WIDTH(32)) mux_A(
        .in0(RD1),
        .in1(write_data_W),
        .in2(ALU_result_M),
        .sel(ForwardAE),
        .out(SrcA)
    );
    
    // 转发逻辑：选择ALU的第二个操作数
    mux_3to1 #(.WIDTH(32)) mux_B(
        .in0(RD2),
        .in1(write_data_W),
        .in2(ALU_result_M),
        .sel(ForwardBE),
        .out(SrcB_nomux)
    );
    
    // ALUSrc选择立即数或寄存器
    assign SrcB = ALUSrc ? imm : SrcB_nomux;
    
    // 计算分支目标地址
    assign branch_target = PC + (imm << 2);
    
    // 执行ALU操作
    alu alu_unit(
        .clk(clk),
        .rst(rst),
        .SrcAE(SrcA),
        .SrcBE(SrcB),
        .ALUControlE(ALUControl),
        .ALUResultE(ALU_result)
    );
    
    // 生成zero标志
    assign zero_flag = (ALU_result == 32'b0) ? 1'b1 : 1'b0;
endmodule
