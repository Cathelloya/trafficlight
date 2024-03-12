module sequence_generator(
    input wire clk,          // ʱ���ź�
    input wire reset,        // ��λ�ź�
    input wire switch,        // ���������ź�
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
localparam COUNT_15SEC = 15, // ����ʱ��Ƶ��Ϊ1Hz
          COUNT_10SEC = 10,
          COUNT_3SEC = 3;

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
                    counter <= COUNT_10SEC;
                    out <= RIGHT;
                end else begin
                    counter <= counter - 1;
                    out <= FORWARD;
                end
            end
            RIGHT: begin
                if (counter <= 1) begin
                    state <= LEFT;
                    counter <= COUNT_10SEC;
                    out <= LEFT;
                end else begin
                    counter <= counter - 1;
                    out <= RIGHT;
                end
            end
            LEFT: begin
                if (counter <= 1) begin
                    state <= OFF;
                    counter <= COUNT_3SEC;
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
                        counter <= COUNT_15SEC;
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