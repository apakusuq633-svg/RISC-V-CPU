module WB(
    input wire clk,
    input wire rst,
    input wire [31:0]alu_result,
    input wire [31:0]read_data,
    input wire MemtoReg,
    output reg [31:0] write_data
);
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            write_data<=32'h0000_0000;
        end else begin
            write_data <= MemtoReg ? read_data : alu_result;
        end
    end


endmodule