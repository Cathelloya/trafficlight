module sequence_generator(
    input wire clk,          // ʱ���ź�
    input wire reset,        // ��λ�ź�
    input wire switch,       // ���������ź�
    input wire S0,
    input wire S1,
    input wire S2,
    input wire S3,
    input wire S4,
    output reg [1:0] out,    // 2λ����ź�
    output reg [31:0] counter, // ���ڵ���ʱ��32λ������
    output reg [1:0] out2,    // ���ڲ��Եĵڶ�������ź�
    output reg [31:0] counter2 // ���ڲ��Եĵڶ���������
);

// ����ǰһ��״̬
reg S4_prev, S1_prev; // ���ڱ���ǰһ��ʱ�����ڵ� S3 �� S2 ��ֵ

// ����״̬����
reg [1:0] state;

// ����״̬����
localparam OFF = 2'b00,
           LEFT = 2'b01,
           FORWARD = 2'b10,
           RIGHT = 2'b11;

// ����ʱ�����
reg [31:0] FORWARD_T, RIGHT_T, LEFT_T, OFF_T;

// ״̬ת���߼�
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // �첽��λ
        state <= OFF;
        counter <= 0;
        counter2 <= 0;
        out <= 4'b0000;
        out2 <= 4'b0000;
        FORWARD_T <= 15;
        RIGHT_T <= 10;
        LEFT_T <= 10;
        OFF_T <= 3;
    end else if (switch) begin
        // ���ر����£�����counterΪ0��stateΪOFF
        state <= OFF; 
        counter <= 0;
        counter2 <= 0;
        out <= 4'b0000;
        out2 <= 4'b0000;
    end else begin
        case (state)
            FORWARD: begin
                if (counter <= 1) begin
                    state <= RIGHT;
                    //�ϱ�����
                    counter <= RIGHT_T;
                    out <= RIGHT;
                    //��������
                    counter2 <= RIGHT_T;
                    out2 <= LEFT;
                end else begin
                    //�ϱ�����
                    counter <= counter - 1;
                    out <= FORWARD;
                    //��������
                    counter2 <= counter2 - 1;
                    out2 <= OFF;
                end
            end
            RIGHT: begin
                if (counter <= 1) begin
                    state <= LEFT;
                    //�ϱ�����
                    counter <= LEFT_T;
                    out <= LEFT;
                    //��������
                    counter2 <= LEFT_T;
                    out2 <= RIGHT;
                end else begin
                    //�ϱ�����
                    counter <= counter - 1;
                    out <= RIGHT;
                    //��������
                    counter2 <= counter2 - 1;
                    out2 <= LEFT;
                end
            end
            LEFT: begin
                if (counter <= 1) begin
                    state <= OFF;
                    //�ϱ�����
                    counter <= OFF_T;
                    out <= OFF;
                    //��������
                    counter2 <= OFF_T;
                    out2 <= FORWARD;
                end else begin
                    //�ϱ�����
                    counter <= counter - 1;
                    out <= LEFT;
                    //��������
                    counter2 <= counter2 - 1;
                    out2 <= RIGHT;
                end
            end
            OFF: begin
                // �������û�б����£�������״̬ת��
                if (!switch) begin
                    if (counter <= 1) begin
                        state <= FORWARD;
                        //�ϱ�����
                        counter <= FORWARD_T;
                        out <= FORWARD;
                        //��������
                        counter2 <= FORWARD_T;
                        out2 <= OFF;
                    end else begin
                        //�ϱ�����
                        counter <= counter - 1;
                        out <= OFF;
                        //��������
                        counter2 <= counter2 - 1;
                        out2 <= FORWARD;
                    end
                end
            end
        endcase
    end
end

// ���ӻ����ʱ�����
always @(posedge clk) begin
    S4_prev <= S4;
    S1_prev <= S1;

    if (S2) begin
        // ���S3��S0�ı仯������FORWARD_T
        if (S3 && S0) begin
            if (S4 && !S4_prev) begin
                FORWARD_T <= FORWARD_T + 1;
            end
            if (S1 && !S1_prev) begin
                FORWARD_T <= FORWARD_T - 1;
            end
        end else if (S3 && !S0) begin // ���S3�ı仯������RIGHT_T
            if (S4 && !S4_prev) begin
                RIGHT_T <= RIGHT_T + 1;
            end
            if (S1 && !S1_prev) begin
                RIGHT_T <= RIGHT_T - 1;
            end
        end else if (!S3 && S0) begin // ���S0�ı仯������LEFT_T
            if (S4 && !S4_prev) begin
                LEFT_T <= LEFT_T  + 1;
            end
            if (S1 && !S1_prev) begin
                LEFT_T  <= LEFT_T  - 1;
            end
        end else if (!S3 && !S0) begin // ����OFF_T
            if (S4 && !S4_prev) begin
                OFF_T <= OFF_T  + 1;
            end
            if (S1 && !S1_prev) begin
                OFF_T  <= OFF_T - 1;
            end
        end
    end
end
endmodule
