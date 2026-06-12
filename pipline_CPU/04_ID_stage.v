module ID_stage(
    input wire [31:0] instruction,
    output wire [5:0] opcode,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rt,
    output wire [4:0] rd,
    output wire [5:0] funct,
    output wire [15:0] imm_16,
    output wire [25:0] target
);
    // 指令字段提取
    assign opcode = instruction[31:26];
    assign rs1 = instruction[25:21];
    assign rs2 = instruction[20:16];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign funct = instruction[5:0];
    assign imm_16 = instruction[15:0];
    assign target = instruction[25:0];
endmodule
