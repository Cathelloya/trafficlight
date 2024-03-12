module sequence_generator(
    input wire clk,          // 时钟信号
    input wire reset,        // 复位信号
    input wire switch,       // 开关输入信号
    input wire S0,
    input wire S1,
    input wire S2,
    input wire S3,//111
    input wire S4,
    output reg [1:0] out,    // 2位输出信号
    output reg [31:0] counter // 用于倒计时的32位计数器
);

// 定义前一个状态
reg S4_prev, S1_prev; // 用于保存前一个时钟周期的 S3 和 S2 的值

// 定义状态变量
reg [1:0] state;

// 定义状态编码
localparam OFF = 2'b00,
           LEFT = 2'b01,
           FORWARD = 2'b10,
           RIGHT = 2'b11;

// 定义时间参数
reg [31:0] FORWARD_T, RIGHT_T, LEFT_T, YELLOW_T;

// 状态转移逻辑
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 异步复位
        state <= OFF;
        counter <= 0;
        out <= 4'b0000;
        FORWARD_T <= 15;
        RIGHT_T <= 10;
        LEFT_T <= 10;
        YELLOW_T <= 3;
    end else if (switch) begin
        // 开关被按下，保持counter为0和state为OFF
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
                // 如果开关没有被按下，则正常状态转移
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

// 增加或减少时间参数
always @(posedge clk) begin
    S4_prev <= S4;
    S1_prev <= S1;

    if (S2) begin
        // 检测S3和S0的变化来调整FORWARD_T
        if (S3 && S0) begin
            if (S4 && !S4_prev) begin
                FORWARD_T <= FORWARD_T + 1;
            end
            if (S1 && !S1_prev) begin
                FORWARD_T <= FORWARD_T - 1;
        end else if (S3 && !S0) begin // 检测S3的变化来调整RIGHT_T
            if (S4) begin
                RIGHT_T <= RIGHT_T + 1;
            end else if (S1) begin
                RIGHT_T <= RIGHT_T - 1;
            end
        end else if (!S3 && S0) begin // 检测S0的变化来调整LEFT_T
            if (S4) begin
                LEFT_T <= LEFT_T + 1;
            end else if (S1) begin
                LEFT_T <= LEFT_T - 1;
            end
        end else if (!S3 && !S0) begin // 调整YELLOW_T
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
