module branch_unit(
    // Branch signals from EX_MEM
    input wire BranchM,
    input wire zero_flag,
    input wire [31:0] branch_target,
    
    // Current PC
    input wire [31:0] PC,
    
    // Output
    output reg [31:0] next_pc,
    output reg branch_taken
);
    always @(*) begin
        // 分支条件：BranchM为1且zero_flag为1（相等）
        if (BranchM && zero_flag) begin
            next_pc = branch_target;
            branch_taken = 1'b1;
        end else begin
            next_pc = PC + 4;
            branch_taken = 1'b0;
        end
    end
endmodule
