# RISC-V-CPU
第 1 个月：把五级流水线打磨成“可信 CPU”

目标：不要急着加新功能，先把当前 CPU 做到完全可靠。

你要完成：

RV32I 全指令测试
forwarding 单元重构
load-use stall
branch flush
jump flush
store/load 冲突检查
结构冲突检查
riscv-tests 或自建指令测试
Verilator 仿真
波形自动保存
每次提交自动回归

本月成果：

一个稳定 RV32I CPU
指令测试全通过
有自动化 testbench
有 README
有第一版设计文档

这个月不要追求高级功能。
如果基础 CPU 还有偶现 bug，后面所有优化都会变成灾难。
////////////////////////////////////////////////


第 2 个月：做 CSR、中断、异常、外设和裸机 SoC

目标：从 CPU 变成 SoC。

你要完成：

memory map
ROM / RAM
UART
Timer
CLINT 简化实现
CSR 文件
trap 入口
interrupt enable/disable
ecall
mret
裸机 C 程序启动
linker script
startup.S
printf 输出

本月成果：

裸机 C 程序能跑
串口能输出
timer interrupt 能进中断
trap 能返回
可以跑小型 benchmark

这一步非常关键。RT-Thread 跑不起来，国奖基本没戏。
/////////////////////////////////////////////

第 3 个月：RT-Thread 移植

目标：系统能启动，不追求性能。

你要完成：

RT-Thread Nano 启动
线程创建
SysTick/timer tick
上下文切换
串口 shell 或最小输出
malloc/heap 配置
异常处理
官方样例程序运行

本月成果：

RT-Thread 能稳定启动
能跑两个以上线程
能输出运行日志
能录制演示视频
能写出 RT-Thread 移植说明

这个阶段你会遇到大量细节问题，例如栈、链接脚本、中断返回、寄存器保存。
要边做边写文档，因为后面答辩会问。
/////////////////////////////////////////////////

第 4 个月：性能优化一：I-Cache + 取指优化

目标：解决取指瓶颈。

你要完成：

I-Cache
Cache miss stall
cache line refill
valid/tag
性能计数器
cycle counter
instruction counter
cache miss counter
branch miss counter

建议加这些 CSR 或 debug 计数器：

总周期数
执行指令数
CPI
I-Cache miss 次数
分支次数
分支预测失败次数
load-use stall 次数

本月成果：

有无 I-Cache 的性能对比
CoreMark 或自建 benchmark 对比
CPI 分析图
文档里能量化性能提升

国奖作品一定要有数据。不要只说“提升了性能”，要说：

I-Cache 使某程序运行周期减少 xx%，CPI 从 x.xx 降到 x.xx。
////////////////////////////////////////////////

第 5 个月：性能优化二：分支预测 + 乘除法

目标：提升整数程序性能。

你要完成：

ID 阶段提前分支判断，或者 EX 阶段优化
2-bit BHT
BTB
分支预测失败恢复
RV32M 乘法
迭代除法
benchmark 对比

本月成果：

无预测 vs 静态预测 vs 动态预测对比
无乘法扩展 vs RV32M 对比
性能优化表格
答辩用架构图

这一阶段，你的作品才真正开始像“冲国奖项目”。
/////////////////////////////////////////////

第 6 个月：FPGA 上板、时序收敛、AXI/总线优化

目标：从仿真正确变成 FPGA 稳定。

你要完成：

目标实验箱工程搭建
时钟约束
reset 约束
UART 实测
BRAM/外部 RAM 接入
AXI 或类 AXI 总线接口
timing report 分析
Fmax 优化
资源利用率统计
长时间运行稳定性测试

重点优化：

关键路径
forwarding 组合逻辑
ALU 路径
branch compare 路径
cache tag compare 路径
乘法器路径
总线状态机路径

本月成果：

FPGA 可稳定运行
RT-Thread 上板成功
benchmark 上板成功
资源占用表
最高频率表
现场演示脚本

很多队伍仿真能跑，上板就炸。你要比他们早一个月进入上板阶段。
///////////////////////////////////////////////////

第 7 个月：冲刺国奖材料、现场测评、答辩

目标：把项目包装成“完整作品”，不是“代码堆”。

你要完成：

PPT
设计报告
测评报告
视频
现场演示流程
常见问题答辩
新测例应急方案
代码整理
参数说明
架构图重画
性能数据复核

最后一个月不要再大改架构。
只能做：

修 bug
优化频率
补测评
补文档
练答辩

答辩重点要能讲清楚：

为什么选择五/六级顺序流水线，而不是乱序？
Cache 如何设计？miss 怎么处理？
分支预测如何恢复？
RT-Thread 如何移植？
中断和异常如何处理？
性能提升来自哪里？
官方新测例为什么能跑？
FPGA 资源和频率是多少？
最危险的 bug 是什么？怎么验证的？
和普通五级流水线相比提升在哪里？
////////////////////////////////////////

你至少要做 5 层验证：

1. 指令级测试

每条指令单独测：

ADD/SUB
AND/OR/XOR
SLL/SRL/SRA
SLT/SLTU
LB/LH/LW/LBU/LHU
SB/SH/SW
BEQ/BNE/BLT/BGE/BLTU/BGEU
JAL/JALR
LUI/AUIPC
2. 冲突专项测试

专门测：

EX-EX forwarding
MEM-EX forwarding
load-use stall
store data forwarding
branch dependent forwarding
jump flush
branch flush
load 后立即 branch
store 后立即 load
3. 随机指令测试

用 Python 生成随机指令流，对比 Spike/QEMU 或参考模型。

4. C 程序测试

跑：

排序
矩阵乘法
CRC
Dhrystone
CoreMark
memcpy/memset
链表
递归
中断嵌套简单测试
5. 系统级测试

跑：

RT-Thread 启动
多线程切换
timer tick
UART 输出
benchmark
长时间运行

你的报告里最好放一张验证闭环图：

RTL → 仿真 → 指令测试 → 随机测试 → C 程序 → RT-Thread → FPGA 上板 → 官方测例
////////////////////////////////////////////////////////////


必须掌握
RV32I 指令集
RV32M 扩展
五级流水线
forwarding/stall/flush
CSR
trap/interrupt
machine mode
linker script
startup.S
UART
timer
memory map
Verilog/SystemVerilog
Verilator
Vivado/Quartus
FPGA timing
Cache 基础
AXI/AXI-Lite 基础
RT-Thread 移植
需要能讲清楚
CPI
IPC
Fmax
运行时间
cache miss rate
branch misprediction rate
资源利用率
critical path
benchmark 优化来源
可以作为亮点
性能计数器
2-bit 分支预测
BTB
I-Cache
D-Cache
RV32M
AXI 总线
RT-Thread 成功运行
自动化回归测试
FPGA 上稳定测评
/////////////////////////////////////////////////


第 1 个月：五级流水线稳定化
第 2 个月：CSR/中断/SoC
第 3 个月：RT-Thread
第 4 个月：I-Cache/性能计数器
第 5 个月：分支预测/RV32M
第 6 个月：FPGA 上板/AXI/时序优化
第 7 个月：测评、文档、视频、答辩、现场演示
