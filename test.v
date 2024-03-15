module sequence_generator(
    input wire clk,          // 时钟信号
    input wire reset,        // 复位信号
    input wire switch,       // 开关输入信号
    input wire S0,
    input wire S1,
    input wire S2,
    input wire S3,
    input wire S4,
    output reg [1:0] out,    // 2位输出信号
    output reg [31:0] counter, // 用于倒计时的32位计数器
    output reg [1:0] out2,    // 用于测试的第二个输出信号
    output reg [31:0] counter2 // 用于测试的第二个计数器
);

// 定义前一个状态
reg S4_prev, S1_prev; // 用于保存前一个时钟周期的 S3 和 S2 的值

// 定义状态变量
reg [1:0] state;
reg [31:0] flag;
// 定义状态编码
localparam OFF = 2'b00,
           LEFT = 2'b01,
           FORWARD = 2'b10,
           RIGHT = 2'b11;

// 定义时间参数
reg [31:0] FORWARD_T, RIGHT_T, LEFT_T, OFF_T;
reg [31:0] PERIOD;

// 状态转移逻辑
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 异步复位
        state <= OFF;
        counter <= 0;
        counter2 <= 0;
        out <= 4'b0000;
        out2 <= 4'b0000;
        FORWARD_T <= 15;
        RIGHT_T <= 10;
        LEFT_T <= 10;
        OFF_T <= 3;
        flag<=0;
    end else if (switch) begin
        // 开关被按下，保持counter为0和state为OFF
        state <= OFF; 
        counter <= 0;
        counter2 <= 0;
        out <= 4'b0000;
        out2 <= 4'b0000;
        flag <= 0;
    end else begin
        //计算周期
        PERIOD <= FORWARD_T + RIGHT_T + LEFT_T + OFF_T;

        //判断flag的值，来切换南北方向和东西方向的信号
        flag = flag + 1;
        if (flag >= 2 * PERIOD)
        begin
            flag <= 0;
        end
        else 
        begin
            flag <= flag;
        end

        //判断flag的值，来切换南北方向
        if (flag >= 1 && flag <= PERIOD)
        begin
            out2 <= OFF;
            counter2 <= 0;
            
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
                    counter <= OFF_T;
                    out <= OFF;
                end else begin
                    counter <= counter - 1;
                    out <= LEFT;
                end
            end
            OFF: begin
                if (counter <= 1) begin
                    state <= FORWARD;
                    counter <= FORWARD_T;
                    out <= FORWARD;
                    
                end else begin
                    counter <= counter - 1;
                    out <= OFF;
                end
            end
        endcase
        end

        //判断flag的值，来切换东西方向
        else if (flag > PERIOD && flag <= 2 * PERIOD) 
        begin
            out <= OFF;
            counter <= 0;
            case (state)
            FORWARD: begin
                if (counter2 <= 1) begin
                    state <= RIGHT;
                    counter2 <= RIGHT_T;
                    out2 <= RIGHT;
                end else begin
                    counter2 <= counter2 - 1;
                    out2 <= FORWARD;
                end
            end
            RIGHT: begin
                if (counter2 <= 1) begin
                    state <= LEFT;
                    counter2 <= LEFT_T;
                    out2 <= LEFT;
                end else begin
                    counter2 <= counter2 - 1;
                    out2 <= RIGHT;
                end
            end
            LEFT: begin
                if (counter2 <= 1) begin
                    state <= OFF;
                    counter2 <= OFF_T;
                    out2 <= OFF;
                end else begin
                    counter2 <= counter2 - 1;
                    out2 <= LEFT;
                end
            end
            OFF: begin
                if (counter2 <= 1) begin
                    state <= FORWARD;
                    counter2 <= FORWARD_T;
                    out2 <= FORWARD;
                end else begin
                    counter2 <= counter2 - 1;
                    out2 <= OFF;
                end
            end
        endcase
        end
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
            end
        end else if (S3 && !S0) begin // 检测S3的变化来调整RIGHT_T
            if (S4 && !S4_prev) begin
                RIGHT_T <= RIGHT_T + 1;
            end
            if (S1 && !S1_prev) begin
                RIGHT_T <= RIGHT_T - 1;
            end
        end else if (!S3 && S0) begin // 检测S0的变化来调整LEFT_T
            if (S4 && !S4_prev) begin
                LEFT_T <= LEFT_T  + 1;
            end
            if (S1 && !S1_prev) begin
                LEFT_T  <= LEFT_T  - 1;
            end
        end else if (!S3 && !S0) begin // 调整OFF_T
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
