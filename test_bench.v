`timescale 1ns / 1ps

module sequence_generator_tb;

// �����ź�
reg clk;
reg reset;
reg switch;
reg S0, S1, S2, S3, S4; // ���������ź�

// ����ź�
wire [1:0] out;
wire [31:0] counter;

wire [1:0] out2;
wire [31:0] counter2;


// ʵ���������Ե�ģ��
sequence_generator uut (
    .clk(clk),
    .reset(reset),
    .switch(switch),
    .S0(S0), // �������������ź�
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .S4(S4),
    .out(out),
    .counter(counter),
    .out2(out2),
    .counter2(counter2)
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
    S0 = 0; // ���ó�ʼֵ
    S1 = 0;
    S2 = 0;
    S3 = 0;
    S4 = 0;
    #200; // �ȴ�һ��ʱ��

    // ģ�⿪�ر�����
    switch = 1;
    S0 = 1; // ���ò��� S0 �Ĺ���
    #50;  // ���ְ���״̬һ��ʱ��

    // �ͷſ���
    switch = 0;
    #100; // �ȴ�һ��ʱ��

    // �ٴ�ģ�⿪�ر�����
    switch = 1;
    S1 = 1; // ���ò��� S1 �Ĺ���
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
