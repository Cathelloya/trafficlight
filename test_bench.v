`timescale 1ns / 1ps

module sequence_generator_tb;

// 输入信号
reg clk;
reg reset;
reg switch;
reg S0, S1, S2, S3, S4; // 新增输入信号

// 输出信号
wire [1:0] out;
wire [31:0] counter;

wire [1:0] out2;
wire [31:0] counter2;


// 实例化被测试的模块
sequence_generator uut (
    .clk(clk),
    .reset(reset),
    .switch(switch),
    .S0(S0), // 连接新增输入信号
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .S4(S4),
    .out(out),
    .counter(counter),
    .out2(out2),
    .counter2(counter2)
);

// 生成时钟信号
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 产生100MHz的时钟信号
end

// 初始复位
initial begin
    reset = 1;
    #100 reset = 0;
end

// 模拟开关操作和复位操作
initial begin
    // 初始状态
    switch = 0;
    S0 = 0; // 设置初始值
    S1 = 0;
    S2 = 0;
    S3 = 0;
    S4 = 0;
    #200; // 等待一段时间

    // 模拟开关被按下
    switch = 1;
    S0 = 1; // 设置测试 S0 的功能
    #50;  // 保持按下状态一段时间

    // 释放开关
    switch = 0;
    #100; // 等待一段时间

    // 再次模拟开关被按下
    switch = 1;
    S1 = 1; // 设置测试 S1 的功能
    #50;  // 保持按下状态一段时间

    switch = 0;
    #100; // 等待一段时间

    // 结束模拟
    $finish;
end

// 监视输出
initial begin
    $monitor("Time: %t, State: %b, Counter: %d, Output: %b", $time, uut.state, uut.counter, uut.out);
end

endmodule
