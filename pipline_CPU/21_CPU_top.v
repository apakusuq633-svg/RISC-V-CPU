module CPU_top(
    input wire clk,
    input wire rst
);
    // ===== IF Stage =====
    wire [31:0] PC;
    wire [31:0] next_pc;
    wire [31:0] instruction_IF;
    
    // ===== IF_ID Stage =====
    wire [31:0] PC_ID;
    wire [31:0] instruction_ID;
    wire stall;
    
    // ===== ID Stage =====
    wire [5:0] opcode;
    wire [4:0] rs1, rs2, rt, rd;
    wire [5:0] funct;
    wire [15:0] imm_16;
    wire [25:0] target;
    
    // ID stage outputs
    wire RegWriteD, MemtoRegD, MemWriteD, MemReadD, BranchD, ALUSrcD, RegDstD;
    wire [1:0] ALUOpD;
    
    // Register file outputs
    wire [31:0] RD1, RD2;
    
    // Sign extended immediate
    wire [31:0] imm_extended;
    
    // ===== ID_EX Stage =====
    wire [31:0] RD1_EX, RD2_EX;
    wire [31:0] imm_EX;
    wire [4:0] rs1_EX, rs2_EX, rt_EX, rd_EX;
    wire [5:0] funct_EX;
    wire [31:0] PC_EX;
    wire RegWriteE, MemtoRegE, MemWriteE, MemReadE, BranchE, ALUSrcE, RegDstE;
    wire [1:0] ALUOpE;
    
    // ===== Conflict Unit (Hazard + Forwarding) =====
    wire flush_ID_EX;
    wire [1:0] ForwardAE, ForwardBE;
    
    // ===== ALU Control =====
    wire [2:0] ALUControl;
    
    // ===== EX Stage =====
    wire [31:0] ALU_result_EX;
    wire zero_flag_EX;
    wire [31:0] branch_target_EX;
    
    // ===== EX_MEM Stage =====
    wire [31:0] ALU_result_MEM;
    wire [31:0] RD2_MEM;
    wire [4:0] rd_MEM;
    wire [31:0] branch_target_MEM;
    wire zero_flag_MEM;
    wire RegWriteM, MemtoRegM, MemWriteM, MemReadM, BranchM;
    
    // ===== MEM Stage =====
    wire [31:0] read_data_MEM;
    
    // ===== MEM_WB Stage =====
    wire [31:0] ALU_result_WB;
    wire [31:0] read_data_WB;
    wire [4:0] rd_WB;
    wire RegWriteW, MemtoRegW;
    
    // ===== WB Stage =====
    wire [31:0] write_data;
    
    // ===== Branch Unit =====
    wire branch_taken;
    wire [31:0] branch_next_pc;
    
    // ===== PC Update =====
    wire [31:0] PC_update;
    assign PC_update = branch_taken ? branch_next_pc : (PC + 4);
    
    // ===== IF Stage =====
    PC pc_module(
        .clk(clk),
        .rst(rst),
        .next_pc(PC_update),
        .pc(PC)
    );
    
    IF if_module(
        .clk(clk),
        .rst(rst),
        .pc(PC),
        .we(1'b0),
        .write_data(32'h0000_0000),
        .instruction(instruction_IF)
    );
    
    // ===== IF_ID Latch =====
    IF_ID if_id_latch(
        .clk(clk),
        .rst(rst),
        .PC_in(PC),
        .instruction_in(instruction_IF),
        .stall(stall),
        .PC_out(PC_ID),
        .instruction_out(instruction_ID)
    );
    
    // ===== ID Stage =====
    ID_stage id_decode(
        .instruction(instruction_ID),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rt(rt),
        .rd(rd),
        .funct(funct),
        .imm_16(imm_16),
        .target(target)
    );
    
    control_unit ctrl_unit(
        .opcode(opcode),
        .RegWrite(RegWriteD),
        .MemtoReg(MemtoRegD),
        .MemWrite(MemWriteD),
        .MemRead(MemReadD),
        .ALUOp(ALUOpD),
        .ALUSrc(ALUSrcD),
        .RegDst(RegDstD),
        .Branch(BranchD)
    );
    
    // Register file
    IM reg_file(
        .clk(clk),
        .rst(rst),
        .we3(RegWriteW),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd_WB),
        .write_data(write_data),
        .ForwardingA(1'b0),
        .ForwardingB(1'b0),
        .ALU_result(32'h0000_0000),
        .read_data1(RD1),
        .read_data2(RD2)
    );
    
    // Sign extend immediate
    sign_extend sign_ext(
        .imm_16(imm_16),
        .imm_32(imm_extended)
    );
    
    // ===== Conflict Unit (Hazard + Forwarding) =====
    conflict_unit conflict_ctrl(
        .MemReadE(MemReadE),
        .rd_E(rd_EX),
        .rs1_D(rs1),
        .rs2_D(rs2),
        .rs1_E(rs1_EX),
        .rs2_E(rs2_EX),
        .rd_M(rd_MEM),
        .RegWriteM(RegWriteM),
        .rd_W(rd_WB),
        .RegWriteW(RegWriteW),
        .stall(stall),
        .flush(flush_ID_EX),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );
    
    // ===== ID_EX Latch =====
    ID_EX id_ex_latch(
        .clk(clk),
        .rst(rst),
        .flush(flush_ID_EX),
        .RegWriteD(RegWriteD),
        .MemtoRegD(MemtoRegD),
        .MemWriteD(MemWriteD),
        .MemReadD(MemReadD),
        .ALUOpD(ALUOpD),
        .ALUSrcD(ALUSrcD),
        .RegDstD(RegDstD),
        .BranchD(BranchD),
        .PC_in(PC_ID),
        .RD1(RD1),
        .RD2(RD2),
        .sign_ext_imm(imm_extended),
        .rs1(rs1),
        .rs2(rs2),
        .rt(rt),
        .rd(rd),
        .funct(funct),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .MemReadE(MemReadE),
        .ALUOpE(ALUOpE),
        .ALUSrcE(ALUSrcE),
        .RegDstE(RegDstE),
        .BranchE(BranchE),
        .PC_out(PC_EX),
        .RD1_out(RD1_EX),
        .RD2_out(RD2_EX),
        .imm_out(imm_EX),
        .rs1_out(rs1_EX),
        .rs2_out(rs2_EX),
        .rt_out(rt_EX),
        .rd_out(rd_EX),
        .funct_out(funct_EX)
    );
    
    // ===== ALU Control Unit =====
    alu_control alu_ctrl(
        .ALUOp(ALUOpE),
        .funct(funct_EX),
        .ALUControl(ALUControl)
    );
    
    // ===== EX Stage =====
    EX_stage ex_stage(
        .clk(clk),
        .rst(rst),
        .RD1(RD1_EX),
        .RD2(RD2_EX),
        .imm(imm_EX),
        .PC(PC_EX),
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrcE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .ALU_result_M(ALU_result_MEM),
        .write_data_W(write_data),
        .ALU_result(ALU_result_EX),
        .zero_flag(zero_flag_EX),
        .branch_target(branch_target_EX)
    );
    
    // ===== Destination Register Selection =====
    wire [4:0] rd_to_exec;
    assign rd_to_exec = RegDstE ? rd_EX : rt_EX;
    
    // ===== EX_MEM Latch =====
    EX_MEM ex_mem_latch(
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .MemReadE(MemReadE),
        .BranchE(BranchE),
        .ALU_result(ALU_result_EX),
        .RD2_E(RD2_EX),
        .rd_E(rd_to_exec),
        .branch_target(branch_target_EX),
        .zero_flag(zero_flag_EX),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .MemWriteM(MemWriteM),
        .MemReadM(MemReadM),
        .BranchM(BranchM),
        .ALU_result_out(ALU_result_MEM),
        .RD2_out(RD2_MEM),
        .rd_out(rd_MEM),
        .branch_target_out(branch_target_MEM),
        .zero_flag_out(zero_flag_MEM)
    );
    
    // ===== Branch Unit =====
    branch_unit branch_ctrl(
        .BranchM(BranchM),
        .zero_flag(zero_flag_MEM),
        .branch_target(branch_target_MEM),
        .PC(PC_ID),
        .next_pc(branch_next_pc),
        .branch_taken(branch_taken)
    );
    
    // ===== MEM Stage =====
    MEM_stage mem_stage(
        .clk(clk),
        .rst(rst),
        .MemWriteM(MemWriteM),
        .MemReadM(MemReadM),
        .ALU_result(ALU_result_MEM),
        .RD2(RD2_MEM),
        .read_data(read_data_MEM)
    );
    
    // ===== MEM_WB Latch =====
    MEM_WB mem_wb_latch(
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .ALU_result(ALU_result_MEM),
        .read_data(read_data_MEM),
        .rd(rd_MEM),
        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW),
        .ALU_result_out(ALU_result_WB),
        .read_data_out(read_data_WB),
        .rd_out(rd_WB)
    );
    
    // ===== WB Stage =====
    WB wb_stage(
        .clk(clk),
        .rst(rst),
        .alu_result(ALU_result_WB),
        .read_data(read_data_WB),
        .MemtoReg(MemtoRegW),
        .write_data(write_data)
    );

endmodule
