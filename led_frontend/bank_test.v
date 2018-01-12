/* Instantiation */
reg clk = 0;
reg resetn;
reg go;

reg [31:0] frame0;
reg [31:0] frame1;
reg [31:0] frame2;
reg [31:0] frame3;
reg [31:0] frame4;
reg [31:0] frame5;
reg [31:0] frame6;
reg [31:0] frame7;
reg [31:0] frame8;
reg [31:0] frame9;
reg [31:0] frame10;
reg [31:0] frame11;
reg [31:0] frame12;
reg [31:0] frame13;
reg [31:0] frame14;
reg [31:0] frame15;
reg [31:0] frame16;
reg [31:0] frame17;

reg dclk0;
reg dclk1;
reg [8:0] data0;
reg [8:0] data1;

wire dclk;
wire [8:0] data;
wire latch0;
wire latch1;

led_bank uut (
    .clk(clk),
    .resetn(resetn),
    .go(go),

    .frame0(frame0),
    .frame1(frame1),
    .frame2(frame2),
    .frame3(frame3),
    .frame4(frame4),
    .frame5(frame5),
    .frame6(frame6),
    .frame7(frame7),
    .frame8(frame8),
    .frame9(frame9),
    .frame10(frame10),
    .frame11(frame11),
    .frame12(frame12),
    .frame13(frame13),
    .frame14(frame14),
    .frame15(frame15),
    .frame16(frame16),
    .frame17(frame17),

    .dclk(dclk),
    .data(data),
    .latch0(latch0),
    .latch1(latch1)
);

always @(*) begin
    if (latch0) begin
        dclk0 <= dclk;
        data0 <= data;
    end
    if (latch1) begin
        dclk1 <= dclk;
        data1 <= data;
    end
end

/* Drive the clock */
always #5 clk = ~clk;
initial begin
    repeat (1000) @(posedge clk);
    $finish;
end

/* Test sequence */
initial #0 begin
    resetn = 0;
    go = 0;
    frame0  = 'hFF0000FF;
    frame1  = 'hFF0000FF;
    frame2  = 'hFF0000FF;
    frame3  = 'hFF0000FF;
    frame4  = 'hFF0000FF;
    frame5  = 'hFF0000FF;
    frame6  = 'hFF0000FF;
    frame7  = 'hFF0000FF;
    frame8  = 'hFF0000FF;
    frame9  = 'hFF00FF00;
    frame10 = 'hFF00FF00;
    frame11 = 'hFF00FF00;
    frame12 = 'hFF00FF00;
    frame13 = 'hFF00FF00;
    frame14 = 'hFF00FF00;
    frame15 = 'hFF00FF00;
    frame16 = 'hFF00FF00;
    frame17 = 'hFF00FF00;

    @(negedge clk);
    resetn = 1;

    @(negedge clk);
    @(negedge clk);
    go = 1;

    @(negedge clk);
    go = 0;
end
