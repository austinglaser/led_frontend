module led_bank #(
    parameter integer FRAME_LENGTH = 32
) (
    input clk,
    input resetn,
    input go,

    input [FRAME_LENGTH-1:0] frame0,
    input [FRAME_LENGTH-1:0] frame1,
    input [FRAME_LENGTH-1:0] frame2,
    input [FRAME_LENGTH-1:0] frame3,
    input [FRAME_LENGTH-1:0] frame4,
    input [FRAME_LENGTH-1:0] frame5,
    input [FRAME_LENGTH-1:0] frame6,
    input [FRAME_LENGTH-1:0] frame7,
    input [FRAME_LENGTH-1:0] frame8,
    input [FRAME_LENGTH-1:0] frame9,
    input [FRAME_LENGTH-1:0] frame10,
    input [FRAME_LENGTH-1:0] frame11,
    input [FRAME_LENGTH-1:0] frame12,
    input [FRAME_LENGTH-1:0] frame13,
    input [FRAME_LENGTH-1:0] frame14,
    input [FRAME_LENGTH-1:0] frame15,
    input [FRAME_LENGTH-1:0] frame16,
    input [FRAME_LENGTH-1:0] frame17,

    output reg dclk,
    output reg latch0,
    output reg latch1,
    output reg [8:0] data,
    output idle
);
    /* State enumeration */
    localparam SSIZE = 9;

    localparam IDLE  = 0;
    localparam SIDLE = 1 << IDLE;

    localparam B0    = 1;
    localparam SB0   = 1 << B0;

    localparam L0    = 2;
    localparam SL0   = 1 << L0;

    localparam C0    = 3;
    localparam SC0   = 1 << C0;

    localparam D0    = 4;
    localparam SD0   = 1 << D0;

    localparam B1    = 5;
    localparam SB1   = 1 << B1;

    localparam L1    = 6;
    localparam SL1   = 1 << L1;

    localparam C1    = 7;
    localparam SC1   = 1 << C1;

    localparam D1    = 8;
    localparam SD1   = 1 << D1;


    reg [FRAME_LENGTH-1:0] frame0_lat;
    reg [FRAME_LENGTH-1:0] frame1_lat;
    reg [FRAME_LENGTH-1:0] frame2_lat;
    reg [FRAME_LENGTH-1:0] frame3_lat;
    reg [FRAME_LENGTH-1:0] frame4_lat;
    reg [FRAME_LENGTH-1:0] frame5_lat;
    reg [FRAME_LENGTH-1:0] frame6_lat;
    reg [FRAME_LENGTH-1:0] frame7_lat;
    reg [FRAME_LENGTH-1:0] frame8_lat;
    reg [FRAME_LENGTH-1:0] frame9_lat;
    reg [FRAME_LENGTH-1:0] frame10_lat;
    reg [FRAME_LENGTH-1:0] frame11_lat;
    reg [FRAME_LENGTH-1:0] frame12_lat;
    reg [FRAME_LENGTH-1:0] frame13_lat;
    reg [FRAME_LENGTH-1:0] frame14_lat;
    reg [FRAME_LENGTH-1:0] frame15_lat;
    reg [FRAME_LENGTH-1:0] frame16_lat;
    reg [FRAME_LENGTH-1:0] frame17_lat;

    /* Local values */
    reg [SSIZE-1:0] state;
    wire [SSIZE-1:0] next_state;

    /* Idle signal */
    assign idle = (state == SIDLE);

    /* Next state logic */
    reg [FRAME_LENGTH:0] bit;
    assign next_state = next_state_function(state, bit, go);

    function [SSIZE-1:0] next_state_function;
        input [SSIZE-1:0] state;
        input [FRAME_LENGTH:0] bit;
        input go;
        (* parallel_case *)
        case (1)
            state[IDLE]: next_state_function = go ? SB0 : SIDLE;
            state[B0]:   next_state_function = SL0;
            state[L0]:   next_state_function = SC0;
            state[C0]:   next_state_function = SD0;
            state[D0]:   next_state_function = SB1;
            state[B1]:   next_state_function = SL1;
            state[L1]:   next_state_function = SC1;
            state[C1]:   next_state_function = SD1;
            state[D1]:   next_state_function = bit[0] ? SIDLE : SB0;
        endcase
    endfunction

    always @(posedge clk) begin
        if (!resetn) begin
            state <= SIDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(posedge clk) begin
        if (!resetn) begin
            dclk   <= 1;
            latch0 <= 1;
            latch1 <= 1;
            data   <= 9'b0;

            bit    <= 1 << (FRAME_LENGTH);
        end else begin
            (* parallel_case *)
            case (1)
                state[IDLE]: begin
                    data <= 9'b0;
                    dclk <= 1;
                    latch0 <= 0;
                    latch1 <= 0;
                    bit <= 1 << (FRAME_LENGTH);
                    frame0_lat  <= frame0;
                    frame1_lat  <= frame1;
                    frame2_lat  <= frame2;
                    frame3_lat  <= frame3;
                    frame4_lat  <= frame4;
                    frame5_lat  <= frame5;
                    frame6_lat  <= frame6;
                    frame7_lat  <= frame7;
                    frame8_lat  <= frame8;
                    frame9_lat  <= frame9;
                    frame10_lat <= frame10;
                    frame11_lat <= frame11;
                    frame12_lat <= frame12;
                    frame13_lat <= frame13;
                    frame14_lat <= frame14;
                    frame15_lat <= frame15;
                    frame16_lat <= frame16;
                    frame17_lat <= frame17;
                end

                state[B0]: begin
                    data <= {frame0_lat[FRAME_LENGTH - 1],
                             frame1_lat[FRAME_LENGTH - 1],
                             frame2_lat[FRAME_LENGTH - 1],
                             frame3_lat[FRAME_LENGTH - 1],
                             frame4_lat[FRAME_LENGTH - 1],
                             frame5_lat[FRAME_LENGTH - 1],
                             frame6_lat[FRAME_LENGTH - 1],
                             frame7_lat[FRAME_LENGTH - 1],
                             frame8_lat[FRAME_LENGTH - 1]};
                    dclk <= 0;
                end

                state[L0]: begin
                    latch0 <= 1;
                end

                state[C0]: begin
                    dclk <= 1;
                end

                state[D0]: begin
                    latch0 <= 0;
                end

                state[B1]: begin
                    data <= {frame9_lat [FRAME_LENGTH - 1],
                             frame10_lat[FRAME_LENGTH - 1],
                             frame11_lat[FRAME_LENGTH - 1],
                             frame12_lat[FRAME_LENGTH - 1],
                             frame13_lat[FRAME_LENGTH - 1],
                             frame14_lat[FRAME_LENGTH - 1],
                             frame15_lat[FRAME_LENGTH - 1],
                             frame16_lat[FRAME_LENGTH - 1],
                             frame17_lat[FRAME_LENGTH - 1]};
                    dclk <= 0;
                    bit <=  bit >> 1;
                    frame0_lat  <= frame0_lat  << 1;
                    frame1_lat  <= frame1_lat  << 1;
                    frame2_lat  <= frame2_lat  << 1;
                    frame3_lat  <= frame3_lat  << 1;
                    frame4_lat  <= frame4_lat  << 1;
                    frame5_lat  <= frame5_lat  << 1;
                    frame6_lat  <= frame6_lat  << 1;
                    frame7_lat  <= frame7_lat  << 1;
                    frame8_lat  <= frame8_lat  << 1;
                    frame9_lat  <= frame9_lat  << 1;
                    frame10_lat <= frame10_lat << 1;
                    frame11_lat <= frame11_lat << 1;
                    frame12_lat <= frame12_lat << 1;
                    frame13_lat <= frame13_lat << 1;
                    frame14_lat <= frame14_lat << 1;
                    frame15_lat <= frame15_lat << 1;
                    frame16_lat <= frame16_lat << 1;
                    frame17_lat <= frame17_lat << 1;
                end

                state[L1]: begin
                    latch1 <= 1;
                end

                state[C1]: begin
                    dclk <= 1;
                end

                state[D1]: begin
                    latch1 <= 0;
                end
            endcase
        end
    end

endmodule
