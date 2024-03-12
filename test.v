module sequence_generator(
    input wire clk,          // ʱ���ź�
    input wire reset,        // ��λ�ź�
    input wire switch,       // ���������ź�
    input wire S0,
    input wire S1,
    input wire S2,
    input wire S3,//111
    input wire S4,
    output reg [1:0] out,    // 2λ����ź�
    output reg [31:0] counter // ���ڵ���ʱ��32λ������
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
reg [31:0] FORWARD_T, RIGHT_T, LEFT_T, YELLOW_T;

// ״̬ת���߼�
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // �첽��λ
        state <= OFF;
        counter <= 0;
        out <= 4'b0000;
        FORWARD_T <= 15;
        RIGHT_T <= 10;
        LEFT_T <= 10;
        YELLOW_T <= 3;
    end else if (switch) begin
        // ���ر����£�����counterΪ0��stateΪOFF
        state <= OFF;
        counter <= 0;
        out <= 4'b0000;
    end else begin
        case (state)
            FORWARD: begin
                if (counter <= 1) begin
                    state <= RIGHT;
                    counter <= RIGHT_T;
                    out <= RIGHT;
                end else begin
                    counter <= counter - 1;
                    out <= FORWARD;
                end
            end
            RIGHT: begin
                if (counter <= 1) begin
                    state <= LEFT;
                    counter <= LEFT_T;
                    out <= LEFT;
                end else begin
                    counter <= counter - 1;
                    out <= RIGHT;
                end
            end
            LEFT: begin
                if (counter <= 1) begin
                    state <= OFF;
                    counter <= YELLOW_T;
                    out <= OFF;
                end else begin
                    counter <= counter - 1;
                    out <= LEFT;
                end
            end
            OFF: begin
                // �������û�б����£�������״̬ת��
                if (!switch) begin
                    if (counter <= 1) begin
                        state <= FORWARD;
                        counter <= FORWARD_T;
                        out <= FORWARD;
                    end else begin
                        counter <= counter - 1;
                        out <= OFF;
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
        end else if (S3 && !S0) begin // ���S3�ı仯������RIGHT_T
            if (S4) begin
                RIGHT_T <= RIGHT_T + 1;
            end else if (S1) begin
                RIGHT_T <= RIGHT_T - 1;
            end
        end else if (!S3 && S0) begin // ���S0�ı仯������LEFT_T
            if (S4) begin
                LEFT_T <= LEFT_T + 1;
            end else if (S1) begin
                LEFT_T <= LEFT_T - 1;
            end
        end else if (!S3 && !S0) begin // ����YELLOW_T
            if (S4) begin
                YELLOW_T <= YELLOW_T + 1;
            end else if (S1) begin
                YELLOW_T <= YELLOW_T - 1;
            end
        end
    end
end
end

endmodule
