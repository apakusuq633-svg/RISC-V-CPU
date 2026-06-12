module control_unit(
    input wire [5:0] opcode,        // MIPS 6-bit opcode (bits 31-26)
    output reg RegWrite,            // Register file write enable
    output reg MemtoReg,            // 1: write memory data to register, 0: write ALU result
    output reg MemWrite,            // Data memory write enable
    output reg MemRead,             // Data memory read enable
    output reg [1:0] ALUOp,         // ALU operation select (2-bit)
    output reg ALUSrc,              // 1: ALU src from immediate, 0: from register
    output reg RegDst,              // 1: destination register is rd, 0: rt
    output reg Branch               // Branch signal (for BEQ)
);
    always @(*) begin
        case (opcode)
            // R-type: add, sub, and, or, slt, etc.
            6'b000000: begin
                RegWrite = 1'b1;
                RegDst   = 1'b1;    // rd is destination
                ALUSrc   = 1'b0;    // ALU src from register
                Branch   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;    // write ALU result to register
                ALUOp    = 2'b10;   // ALU control decodes funct field
            end

            // LW: lw $rt, imm($rs)
            6'b100011: begin
                RegWrite = 1'b1;
                RegDst   = 1'b0;    // rt is destination
                ALUSrc   = 1'b1;    // ALU src from sign-extended immediate
                Branch   = 1'b0;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                MemtoReg = 1'b1;    // write memory data to register
                ALUOp    = 2'b00;   // ALU performs addition (base + offset)
            end

            // SW: sw $rt, imm($rs)
            6'b101011: begin
                RegWrite = 1'b0;
                RegDst   = 1'bx;    // don't care
                ALUSrc   = 1'b1;    // ALU src from sign-extended immediate
                Branch   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                MemtoReg = 1'bx;    // don't care
                ALUOp    = 2'b00;   // ALU performs addition (base + offset)
            end

            // BEQ: beq $rs, $rt, offset
            6'b000100: begin
                RegWrite = 1'b0;
                RegDst   = 1'bx;    // don't care
                ALUSrc   = 1'b0;    // ALU src from register (compare)
                Branch   = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'bx;    // don't care
                ALUOp    = 2'b01;   // ALU performs subtraction for comparison
            end

            // ADDI: addi $rt, $rs, imm
            6'b001000: begin
                RegWrite = 1'b1;
                RegDst   = 1'b0;    // rt is destination
                ALUSrc   = 1'b1;    // ALU src from sign-extended immediate
                Branch   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;    // write ALU result to register
                ALUOp    = 2'b00;   // ALU performs addition
            end

            // J: j target
            6'b000010: begin
                RegWrite = 1'b0;
                RegDst   = 1'bx;
                ALUSrc   = 1'bx;
                Branch   = 1'b0;    // handled by separate jump logic
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'bx;
                ALUOp    = 2'bxx;   // don't care
            end

            default: begin
                RegWrite = 1'b0;
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                Branch   = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                MemtoReg = 1'b0;
                ALUOp    = 2'b00;
            end
        endcase
    end

endmodule
