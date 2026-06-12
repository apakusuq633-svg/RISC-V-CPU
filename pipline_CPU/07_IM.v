module IM(

    input wire clk,
    input wire rst,
    input wire we3,
    input wire [4:0]rs1,
    input wire [4:0]rs2,
    input wire [4:0]rd,
    input wire [31:0] write_data,
    input wire ForwardingA,
    input wire ForwardingB,
    input wire [31:0] ALU_result,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);
    reg [31:0] register_file [0:31];
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            register_file[i] = 32'h0000_0000;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                register_file[i] <= 32'h0000_0000;
            end
        end else if (rd != 5'b00000 && we3) begin
            register_file[rd] <= write_data;
        end
    end

    always @(*) begin
        read_data1 = ForwardingA ? ALU_result : register_file[rs1];
        read_data2 = ForwardingB ? ALU_result : register_file[rs2];
    end


endmodule