module sequence_generator(
    input wire clk,          // 时钟信号
    input wire reset,        // 复位信号
    input wire switch,        // 开关输入信号
    output reg [1:0] out,    // 2位输出信号
    output reg [31:0] counter // 用于倒计时的32位计数器
);

// 定义状态变量
reg [1:0] state;

// 定义状态编码
localparam OFF = 2'b00,
           LEFT = 2'b01,
           FORWARD = 2'b10,
           RIGHT = 2'b11;

// 定义时间参数
localparam COUNT_15SEC = 15, // 假设时钟频率为1Hz
          COUNT_10SEC = 10,
          COUNT_3SEC = 3;

// 状态转移逻辑
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // 异步复位
        state <= OFF;
        counter <= 0;
        out <= 4'b0000;
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
                // 如果开关没有被按下，则正常状态转移
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