module MEM_WB(
    input wire clk,
    input wire rst,
    // Control signals
    input wire RegWriteM,
    input wire MemtoRegM,
    // Data signals
    input wire [31:0] ALU_result,
    input wire [31:0] read_data,
    input wire [4:0] rd,
    
    // Output control signals
    output reg RegWriteW,
    output reg MemtoRegW,
    // Output data signals
    output reg [31:0] ALU_result_out,
    output reg [31:0] read_data_out,
    output reg [4:0] rd_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteW <= 1'b0;
            MemtoRegW <= 1'b0;
            ALU_result_out <= 32'h0000_0000;
            read_data_out <= 32'h0000_0000;
            rd_out <= 5'b00000;
        end else begin
            RegWriteW <= RegWriteM;
            MemtoRegW <= MemtoRegM;
            ALU_result_out <= ALU_result;
            read_data_out <= read_data;
            rd_out <= rd;
        end
    end
endmodule
