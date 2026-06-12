module alu_control (
    input wire [1:0] ALUOp,         // From control unit
    input wire [5:0] funct,         // From instruction (bits 5-0)
    output reg [2:0] ALUControl     // ALU control signal (3-bit)
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b010; // LW/SW: ALU performs addition
            2'b01: ALUControl = 3'b110; // BEQ: ALU performs subtraction
            2'b10: begin
                case (funct)
                    6'b100000: ALUControl = 3'b010; // ADD
                    6'b100010: ALUControl = 3'b110; // SUB
                    6'b100100: ALUControl = 3'b000; // AND
                    6'b100101: ALUControl = 3'b001; // OR
                    6'b101010: ALUControl = 3'b111; // SLT
                    default:   ALUControl = 3'bxxx; // Invalid funct
                endcase
            end
            default: ALUControl = 3'bxxx; // Invalid ALUOp
        endcase
    end
    
endmodule