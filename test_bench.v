`timescale 1ns / 1ps

module sequence_generator_tb;

// �����ź�
reg clk;
reg reset;
reg switch;

// ����ź�
wire [1:0] out;
wire [31:0] counter;

// ʵ���������Ե�ģ��
sequence_generator uut (
    .clk(clk),
    .reset(reset),
    .switch(switch),
    .out(out),
    .counter(counter)
);

// ����ʱ���ź�
initial begin
    clk = 0;
    forever #5 clk = ~clk; // ����100MHz��ʱ���ź�
end

// ��ʼ��λ
initial begin
    reset = 1;
    #100 reset = 0;

end

// ģ�⿪�ز����͸�λ����
initial begin
    // ��ʼ״̬
    switch = 0;
    #200; // �ȴ�һ��ʱ��

    // ģ�⿪�ر�����
    switch = 1;
    #50;  // ���ְ���״̬һ��ʱ��

    // �ͷſ���
    switch = 0;
    #100; // �ȴ�һ��ʱ��

    // �ٴ�ģ�⿪�ر�����
    switch = 1;
    #50;  // ���ְ���״̬һ��ʱ��

    switch = 0;
    #100; // �ȴ�һ��ʱ��

    // ����ģ��
    $finish;
end

// �������
initial begin
    $monitor("Time: %t, State: %b, Counter: %d, Output: %b", $time, uut.state, uut.counter, uut.out);
end

endmodule