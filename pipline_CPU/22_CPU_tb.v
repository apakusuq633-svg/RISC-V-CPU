module CPU_tb;
    reg clk;
    reg rst;
    
    // 实例化顶层CPU
    CPU_top cpu(
        .clk(clk),
        .rst(rst)
    );
    
    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns周期
    end
    
    // 复位和测试
    initial begin
        // 初始化
        rst = 1;
        #10;
        rst = 0;
        
        // 运行200个时钟周期进行观察
        #2000;
        
        $finish;
    end
    
    // 监控关键信号
    initial begin
        $monitor("Time=%0t | PC=%h | IF_Inst=%h | RegWrite=%b | ALUResult=%h | MemWrite=%b",
                 $time, cpu.PC, cpu.instruction_IF, cpu.RegWriteW, cpu.ALU_result_WB, cpu.MemWriteM);
    end

endmodule
