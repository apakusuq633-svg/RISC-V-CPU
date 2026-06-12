module sign_extend(
    input wire [15:0] imm_16,
    output reg [31:0] imm_32
);
    always @(*) begin
        if (imm_16[15] == 1'b1) begin
            imm_32 = {16'hFFFF, imm_16};
        end else begin
            imm_32 = {16'h0000, imm_16};
        end
    end
endmodule
