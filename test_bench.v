`timescale 1ns / 1ps

module sequence_generator_tb;

// 输入信号
reg clk;
reg reset;

// 输出信号
wire [1:0] out;
wire [31:0] counter;

// 实例化待测试的模块
sequence_generator uut (
    .clk(clk),
    .reset(reset),
    .out(out),
    .counter(counter)
);

// 时钟生成
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 生成一个周期为10ns的时钟信号
end

// 测试序列
initial begin
    // 初始化输入
    reset = 1;
    #100; // 等待100ns
    reset = 0; // 释放复位

    // 观察输出
    // 这里我们只是简单地等待一段时间来观察输出，实际测试中可以使用更多的断言来验证行为
    #1000000; // 等待1000000ns (1秒)
    $finish; // 结束仿真
end

// 监视输出信号的值
initial begin
    $monitor("Time = %t, Output = %b", $time, out);
end

endmodule