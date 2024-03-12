`timescale 1ns / 1ps

module sequence_generator_tb;

// 输入信号
reg clk;
reg reset;
reg switch;

// 输出信号
wire [1:0] out;
wire [31:0] counter;

// 实例化被测试的模块
sequence_generator uut (
    .clk(clk),
    .reset(reset),
    .switch(switch),
    .out(out),
    .counter(counter)
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
    #200; // 等待一段时间

    // 模拟开关被按下
    switch = 1;
    #50;  // 保持按下状态一段时间

    // 释放开关
    switch = 0;
    #100; // 等待一段时间

    // 再次模拟开关被按下
    switch = 1;
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