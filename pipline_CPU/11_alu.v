module alu(
    input wire clk,
    input wire rst,
    input wire [31:0] SrcAE,
    input wire [31:0] SrcBE,
    input wire [2:0] ALUControlE,
    output reg [31:0] ALUResultE
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            ALUResultE <= 32'h0000_0000;
        else begin
            case (ALUControlE)
                3'b000: ALUResultE = SrcAE & SrcBE; // AND
                3'b001: ALUResultE = SrcAE | SrcBE; // OR
                3'b010: ALUResultE = SrcAE + SrcBE; // ADD
                3'b110: ALUResultE = SrcAE - SrcBE; // SUB
                3'b111: ALUResultE = ($signed(SrcAE) < $signed(SrcBE)) ? 32'b1 : 32'b0; // SLT
            default: ALUResultE = 32'h0000_0000; // Default case
        endcase
        end
    end


endmodule