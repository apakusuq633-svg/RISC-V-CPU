module EX_MEM(
    input wire clk,
    input wire rst,
    // Control signals
    input wire RegWriteE,
    input wire MemtoRegE,
    input wire MemWriteE,
    input wire MemReadE,
    input wire BranchE,
    // Data signals
    input wire [31:0] ALU_result,
    input wire [31:0] RD2_E,
    input wire [4:0] rd_E,
    input wire [31:0] branch_target,
    input wire zero_flag,
    
    // Output control signals
    output reg RegWriteM,
    output reg MemtoRegM,
    output reg MemWriteM,
    output reg MemReadM,
    output reg BranchM,
    // Output data signals
    output reg [31:0] ALU_result_out,
    output reg [31:0] RD2_out,
    output reg [4:0] rd_out,
    output reg [31:0] branch_target_out,
    output reg zero_flag_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteM <= 1'b0;
            MemtoRegM <= 1'b0;
            MemWriteM <= 1'b0;
            MemReadM <= 1'b0;
            BranchM <= 1'b0;
            ALU_result_out <= 32'h0000_0000;
            RD2_out <= 32'h0000_0000;
            rd_out <= 5'b00000;
            branch_target_out <= 32'h0000_0000;
            zero_flag_out <= 1'b0;
        end else begin
            RegWriteM <= RegWriteE;
            MemtoRegM <= MemtoRegE;
            MemWriteM <= MemWriteE;
            MemReadM <= MemReadE;
            BranchM <= BranchE;
            ALU_result_out <= ALU_result;
            RD2_out <= RD2_E;
            rd_out <= rd_E;
            branch_target_out <= branch_target;
            zero_flag_out <= zero_flag;
        end
    end
endmodule
