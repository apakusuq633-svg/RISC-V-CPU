module ID_EX(
    input wire clk,
    input wire rst,
    input wire flush,
    // Control signals
    input wire RegWriteD,
    input wire MemtoRegD,
    input wire MemWriteD,
    input wire MemReadD,
    input wire [1:0] ALUOpD,
    input wire ALUSrcD,
    input wire RegDstD,
    input wire BranchD,
    // Data signals
    input wire [31:0] PC_in,
    input wire [31:0] RD1,
    input wire [31:0] RD2,
    input wire [31:0] sign_ext_imm,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [4:0] rt,
    input wire [4:0] rd,
    input wire [5:0] funct,
    
    // Output control signals
    output reg RegWriteE,
    output reg MemtoRegE,
    output reg MemWriteE,
    output reg MemReadE,
    output reg [1:0] ALUOpE,
    output reg ALUSrcE,
    output reg RegDstE,
    output reg BranchE,
    // Output data signals
    output reg [31:0] PC_out,
    output reg [31:0] RD1_out,
    output reg [31:0] RD2_out,
    output reg [31:0] imm_out,
    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rt_out,
    output reg [4:0] rd_out,
    output reg [5:0] funct_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteE <= 1'b0;
            MemtoRegE <= 1'b0;
            MemWriteE <= 1'b0;
            MemReadE <= 1'b0;
            ALUOpE <= 2'b00;
            ALUSrcE <= 1'b0;
            RegDstE <= 1'b0;
            BranchE <= 1'b0;
            PC_out <= 32'h0000_0000;
            RD1_out <= 32'h0000_0000;
            RD2_out <= 32'h0000_0000;
            imm_out <= 32'h0000_0000;
            rs1_out <= 5'b00000;
            rs2_out <= 5'b00000;
            rt_out <= 5'b00000;
            rd_out <= 5'b00000;
            funct_out <= 6'b000000;
        end else if (flush) begin
            // 冲突时清空流水线
            RegWriteE <= 1'b0;
            MemtoRegE <= 1'b0;
            MemWriteE <= 1'b0;
            MemReadE <= 1'b0;
            ALUOpE <= 2'b00;
            ALUSrcE <= 1'b0;
            RegDstE <= 1'b0;
            BranchE <= 1'b0;
        end else begin
            RegWriteE <= RegWriteD;
            MemtoRegE <= MemtoRegD;
            MemWriteE <= MemWriteD;
            MemReadE <= MemReadD;
            ALUOpE <= ALUOpD;
            ALUSrcE <= ALUSrcD;
            RegDstE <= RegDstD;
            BranchE <= BranchD;
            PC_out <= PC_in;
            RD1_out <= RD1;
            RD2_out <= RD2;
            imm_out <= sign_ext_imm;
            rs1_out <= rs1;
            rs2_out <= rs2;
            rt_out <= rt;
            rd_out <= rd;
            funct_out <= funct;
        end
    end
endmodule
