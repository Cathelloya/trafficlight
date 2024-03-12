`timescale 1ns / 1ps

module sequence_generator_tb;

// �����ź�
reg clk;
reg reset;

// ����ź�
wire [1:0] out;
wire [31:0] counter;

// ʵ���������Ե�ģ��
sequence_generator uut (
    .clk(clk),
    .reset(reset),
    .out(out),
    .counter(counter)
);

// ʱ������
initial begin
    clk = 0;
    forever #5 clk = ~clk; // ����һ������Ϊ10ns��ʱ���ź�
end

// ��������
initial begin
    // ��ʼ������
    reset = 1;
    #100; // �ȴ�100ns
    reset = 0; // �ͷŸ�λ

    // �۲����
    // ��������ֻ�Ǽ򵥵صȴ�һ��ʱ�����۲������ʵ�ʲ����п���ʹ�ø���Ķ�������֤��Ϊ
    #1000000; // �ȴ�1000000ns (1��)
    $finish; // ��������
end

// ��������źŵ�ֵ
initial begin
    $monitor("Time = %t, Output = %b", $time, out);
end

endmodule