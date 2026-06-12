module IF(
    input wire clk,
    input wire rst,
    input wire [31:0] pc,
    input wire we,                       // 写使能，用于加载指令
    input wire [31:0] write_data,        // 写入的指令数据
    output reg [31:0] instruction
);
    reg [31:0] instruction_memory [0:255];
    integer i;
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            instruction_memory[i] = 32'h0000_0000;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction <= 32'h0000_0000;
        end else begin
            if (we) begin
                instruction_memory[pc[9:2]] <= write_data;   // 写指令
            end else begin
                instruction <= instruction_memory[pc[9:2]];  // 读指令，8位地址匹配256条目
            end
        end
    end

endmodule