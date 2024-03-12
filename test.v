module sequence_generator(
    input wire clk,          // ʱ���ź�
    input wire reset,        // ��λ�ź�
    input wire switch,        // ���������ź�
    input wire S0,
    input wire S1,
    input wire S2,
    input wire S3,
    input wire S4,
    output reg [1:0] out,    // 2λ����ź�
    output reg [31:0] counter // ���ڵ���ʱ��32λ������
);

// ����״̬����
reg [1:0] state;

// ����״̬����
localparam OFF = 2'b00,
           LEFT = 2'b01,
           FORWARD = 2'b10,
           RIGHT = 2'b11;

// ����ʱ�����
localparam FORWARD_T = 15, // ����ʱ��Ƶ��Ϊ1Hz
          RIGHT_T = 10,
          LEFT_T = 10,
          YELLOW_T = 3;

// ״̬ת���߼�
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // �첽��λ
        state <= OFF;
        counter <= 0;
        out <= 4'b0000;
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

endmodule