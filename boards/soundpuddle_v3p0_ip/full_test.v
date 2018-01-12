/* Drive the clock for some cycles */
reg fclk = 1;
reg mclk = 1;

reg  [19:0] addr;
wire [15:0] data;
reg  [15:0] rdata;
reg  [15:0] wdata;

reg nbl0;
reg nbl1;
reg ne1;
reg ne2;
reg noe;
reg nwe;

assign data = (!ne2 && noe) ? wdata : 16'bz;

/* Set up outputs */
wire B0_C;
wire B0_LE0;
wire B0_LE1;
wire B0_S00_S09_D;
wire B0_S01_S10_D;
wire B0_S02_S11_D;
wire B0_S03_S12_D;
wire B0_S04_S13_D;
wire B0_S05_S14_D;
wire B0_S06_S15_D;
wire B0_S07_S16_D;
wire B0_S08_S17_D;

wire B1_C;
wire B1_LE0;
wire B1_LE1;
wire B1_S18_S27_D;
wire B1_S19_S28_D;
wire B1_S20_S29_D;
wire B1_S21_S30_D;
wire B1_S22_S31_D;
wire B1_S23_S32_D;
wire B1_S24_S33_D;
wire B1_S25_S34_D;
wire B1_S26_S35_D;

wire B2_C;
wire B2_LE0;
wire B2_LE1;
wire B2_S36_S45_D;
wire B2_S37_S46_D;
wire B2_S38_S47_D;
wire B2_S39_S48_D;
wire B2_S40_S49_D;
wire B2_S41_S50_D;
wire B2_S42_S51_D;
wire B2_S43_S52_D;
wire B2_S44_S53_D;

wire B3_C;
wire B3_LE0;
wire B3_LE1;
wire B3_S54_S63_D;
wire B3_S55_S64_D;
wire B3_S56_S65_D;
wire B3_S57_S66_D;
wire B3_S58_S67_D;
wire B3_S59_S68_D;
wire B3_S60_S69_D;
wire B3_S61_S70_D;
wire B3_S62_S71_;

/* Instantiate module */
top uut (
    .clk(fclk),
    .B0_C(B0_C),
    .B0_LE0(B0_LE0),
    .B0_LE1(B0_LE1),
    .B0_S00_S09_D(B0_S00_S09_D),
    .B0_S01_S10_D(B0_S01_S10_D),
    .B0_S02_S11_D(B0_S02_S11_D),
    .B0_S03_S12_D(B0_S03_S12_D),
    .B0_S04_S13_D(B0_S04_S13_D),
    .B0_S05_S14_D(B0_S05_S14_D),
    .B0_S06_S15_D(B0_S06_S15_D),
    .B0_S07_S16_D(B0_S07_S16_D),
    .B0_S08_S17_D(B0_S08_S17_D),

    .B1_C(B1_C),
    .B1_LE0(B1_LE0),
    .B1_LE1(B1_LE1),
    .B1_S18_S27_D(B1_S18_S27_D),
    .B1_S19_S28_D(B1_S19_S28_D),
    .B1_S20_S29_D(B1_S20_S29_D),
    .B1_S21_S30_D(B1_S21_S30_D),
    .B1_S22_S31_D(B1_S22_S31_D),
    .B1_S23_S32_D(B1_S23_S32_D),
    .B1_S24_S33_D(B1_S24_S33_D),
    .B1_S25_S34_D(B1_S25_S34_D),
    .B1_S26_S35_D(B1_S26_S35_D),

    .B2_C(B2_C),
    .B2_LE0(B2_LE0),
    .B2_LE1(B2_LE1),
    .B2_S36_S45_D(B2_S36_S45_D),
    .B2_S37_S46_D(B2_S37_S46_D),
    .B2_S38_S47_D(B2_S38_S47_D),
    .B2_S39_S48_D(B2_S39_S48_D),
    .B2_S40_S49_D(B2_S40_S49_D),
    .B2_S41_S50_D(B2_S41_S50_D),
    .B2_S42_S51_D(B2_S42_S51_D),
    .B2_S43_S52_D(B2_S43_S52_D),
    .B2_S44_S53_D(B2_S44_S53_D),

    .B3_C(B3_C),
    .B3_LE0(B3_LE0),
    .B3_LE1(B3_LE1),
    .B3_S54_S63_D(B3_S54_S63_D),
    .B3_S55_S64_D(B3_S55_S64_D),
    .B3_S56_S65_D(B3_S56_S65_D),
    .B3_S57_S66_D(B3_S57_S66_D),
    .B3_S58_S67_D(B3_S58_S67_D),
    .B3_S59_S68_D(B3_S59_S68_D),
    .B3_S60_S69_D(B3_S60_S69_D),
    .B3_S61_S70_D(B3_S61_S70_D),
    .B3_S62_S71_D(B3_S62_S71_D),

    .a00(addr[0]),
    .a01(addr[1]),
    .a02(addr[2]),
    .a03(addr[3]),
    .a04(addr[4]),
    .a05(addr[5]),
    .a06(addr[6]),
    .a07(addr[7]),
    .a08(addr[8]),
    .a09(addr[9]),
    .a10(addr[10]),
    .a11(addr[11]),
    .a12(addr[12]),
    .a13(addr[13]),
    .a14(addr[14]),
    .a15(addr[15]),
    .a16(addr[16]),
    .a17(addr[17]),
    .a18(addr[18]),
    .a19(addr[19]),

    .d00(data[0]),
    .d01(data[1]),
    .d02(data[2]),
    .d03(data[3]),
    .d04(data[4]),
    .d05(data[5]),
    .d06(data[6]),
    .d07(data[7]),
    .d08(data[8]),
    .d09(data[9]),
    .d10(data[10]),
    .d11(data[11]),
    .d12(data[12]),
    .d13(data[13]),
    .d14(data[14]),
    .d15(data[15]),

    .nbl0(nbl0),
    .nbl1(nbl1),
    .ne1(ne1),
    .ne2(ne2),
    .noe(noe),
    .nwe(nwe)
);

`define WREG(_addr, _data)          \
    begin                           \
        addr = _addr;               \
        wdata = _data;              \
        nbl0 = 0;                   \
        nbl1 = 0;                   \
        ne2 = 0;                    \
        noe = 1;                    \
        nwe = 0;                    \
        repeat (8) @(negedge mclk); \
        nwe = 1;                    \
        @(negedge mclk);            \
        nbl0 = 1;                   \
        nbl1 = 1;                   \
        ne1 = 1;                    \
        ne2 = 1;                    \
        noe = 1;                    \
        nwe = 1;                    \
        @(negedge mclk);            \
    end

`define RREG(_addr)                 \
    begin                           \
        addr = _addr;               \
        nbl0 = 0;                   \
        nbl1 = 0;                   \
        ne2 = 0;                    \
        noe = 0;                    \
        nwe = 1;                    \
        repeat (8) @(negedge mclk); \
        nbl0 = 1;                   \
        nbl1 = 1;                   \
        ne1 = 1;                    \
        ne2 = 1;                    \
        noe = 1;                    \
        nwe = 1;                    \
        @(negedge mclk);            \
    end

always @(posedge noe) begin
    rdata <= data;
end

integer i;
always #18 fclk = ~fclk;
always #1  mclk = ~mclk;
initial begin
    addr = 20'b0;
    wdata = 16'b0;
    nbl0 = 1;
    nbl1 = 1;
    ne1 = 1;
    ne2 = 1;
    noe = 1;
    nwe = 1;
    repeat (512) @(negedge fclk);

    repeat (16) begin
        repeat (72) begin
            `WREG(20'h02, 16'hFF00);
        end

        `WREG(20'h01, 16'h01);
        `RREG(20'h00);
        while (rdata == 16'h0F) begin
            `RREG(20'h00);
        end
        `WREG(20'h01, 16'h00);

        `RREG(20'h00);
        while (rdata == 16'h00) begin
            `RREG(20'h00);
        end

        for (i = 0; i < 72; i++) begin
            `WREG(20'h02, i);
        end

        `WREG(20'h01, 16'h01);
        `RREG(20'h00);
        while (rdata == 16'h0F) begin
            `RREG(20'h00);
        end
        `WREG(20'h01, 16'h00);

        `RREG(20'h00);
        while (rdata == 16'h00) begin
            `RREG(20'h00);
        end
    end

    $finish;
end

reg B0_C0;
reg B0_C1;
reg B0_S00;
reg B0_S01;
reg B0_S02;
reg B0_S03;
reg B0_S04;
reg B0_S05;
reg B0_S06;
reg B0_S07;
reg B0_S08;
reg B0_S09;
reg B0_S10;
reg B0_S11;
reg B0_S12;
reg B0_S13;
reg B0_S14;
reg B0_S15;
reg B0_S16;
reg B0_S17;

always @(*) begin
    if (B0_LE0) begin
        B0_C0 <= B0_C;
        B0_S00 <= B0_S00_S09_D;
        B0_S01 <= B0_S01_S10_D;
        B0_S02 <= B0_S02_S11_D;
        B0_S03 <= B0_S03_S12_D;
        B0_S04 <= B0_S04_S13_D;
        B0_S05 <= B0_S05_S14_D;
        B0_S06 <= B0_S06_S15_D;
        B0_S07 <= B0_S07_S16_D;
        B0_S08 <= B0_S08_S17_D;
    end
    if (B0_LE1) begin
        B0_C1 <= B0_C;
        B0_S09 <= B0_S00_S09_D;
        B0_S10 <= B0_S01_S10_D;
        B0_S11 <= B0_S02_S11_D;
        B0_S12 <= B0_S03_S12_D;
        B0_S13 <= B0_S04_S13_D;
        B0_S14 <= B0_S05_S14_D;
        B0_S15 <= B0_S06_S15_D;
        B0_S16 <= B0_S07_S16_D;
        B0_S17 <= B0_S08_S17_D;
    end
end

reg B1_C0;
reg B1_C1;
reg B1_S18;
reg B1_S19;
reg B1_S20;
reg B1_S21;
reg B1_S22;
reg B1_S23;
reg B1_S24;
reg B1_S25;
reg B1_S26;
reg B1_S27;
reg B1_S28;
reg B1_S29;
reg B1_S30;
reg B1_S31;
reg B1_S32;
reg B1_S33;
reg B1_S34;
reg B1_S35;

always @(*) begin
    if (B1_LE0) begin
        B1_C0 <= B1_C;
        B1_S18 <= B1_S18_S27_D;
        B1_S19 <= B1_S19_S28_D;
        B1_S20 <= B1_S20_S29_D;
        B1_S21 <= B1_S21_S30_D;
        B1_S22 <= B1_S22_S31_D;
        B1_S23 <= B1_S23_S32_D;
        B1_S24 <= B1_S24_S33_D;
        B1_S25 <= B1_S25_S34_D;
        B1_S26 <= B1_S26_S35_D;
    end
    if (B1_LE1) begin
        B1_C1 <= B1_C;
        B1_S27 <= B1_S18_S27_D;
        B1_S28 <= B1_S19_S28_D;
        B1_S29 <= B1_S20_S29_D;
        B1_S30 <= B1_S21_S30_D;
        B1_S31 <= B1_S22_S31_D;
        B1_S32 <= B1_S23_S32_D;
        B1_S33 <= B1_S24_S33_D;
        B1_S34 <= B1_S25_S34_D;
        B1_S35 <= B1_S26_S35_D;
    end
end

reg B2_C0;
reg B2_C1;
reg B2_S36;
reg B2_S37;
reg B2_S38;
reg B2_S39;
reg B2_S40;
reg B2_S41;
reg B2_S42;
reg B2_S43;
reg B2_S44;
reg B2_S45;
reg B2_S46;
reg B2_S47;
reg B2_S48;
reg B2_S49;
reg B2_S50;
reg B2_S51;
reg B2_S52;
reg B2_S53;

always @(*) begin
    if (B2_LE0) begin
        B2_C0 <= B2_C;
        B2_S36 <= B2_S36_S45_D;
        B2_S37 <= B2_S37_S46_D;
        B2_S38 <= B2_S38_S47_D;
        B2_S39 <= B2_S39_S48_D;
        B2_S40 <= B2_S40_S49_D;
        B2_S41 <= B2_S41_S50_D;
        B2_S42 <= B2_S42_S51_D;
        B2_S43 <= B2_S43_S52_D;
        B2_S44 <= B2_S44_S53_D;
    end
    if (B2_LE1) begin
        B2_C1 <= B2_C;
        B2_S45 <= B2_S36_S45_D;
        B2_S46 <= B2_S37_S46_D;
        B2_S47 <= B2_S38_S47_D;
        B2_S48 <= B2_S39_S48_D;
        B2_S49 <= B2_S40_S49_D;
        B2_S50 <= B2_S41_S50_D;
        B2_S51 <= B2_S42_S51_D;
        B2_S52 <= B2_S43_S52_D;
        B2_S53 <= B2_S44_S53_D;
    end
end

reg B3_C0;
reg B3_C1;
reg B3_S54;
reg B3_S55;
reg B3_S56;
reg B3_S57;
reg B3_S58;
reg B3_S59;
reg B3_S60;
reg B3_S61;
reg B3_S62;
reg B3_S63;
reg B3_S64;
reg B3_S65;
reg B3_S66;
reg B3_S67;
reg B3_S68;
reg B3_S69;
reg B3_S70;
reg B3_S71;

always @(*) begin
    if (B3_LE0) begin
        B3_C0 <= B3_C;
        B3_S54 <= B3_S54_S63_D;
        B3_S55 <= B3_S55_S64_D;
        B3_S56 <= B3_S56_S65_D;
        B3_S57 <= B3_S57_S66_D;
        B3_S58 <= B3_S58_S67_D;
        B3_S59 <= B3_S59_S68_D;
        B3_S60 <= B3_S60_S69_D;
        B3_S61 <= B3_S61_S70_D;
        B3_S62 <= B3_S62_S71_D;
    end
    if (B2_LE1) begin
        B3_C1 <= B3_C;
        B3_S63 <= B3_S54_S63_D;
        B3_S64 <= B3_S55_S64_D;
        B3_S65 <= B3_S56_S65_D;
        B3_S66 <= B3_S57_S66_D;
        B3_S67 <= B3_S58_S67_D;
        B3_S68 <= B3_S59_S68_D;
        B3_S69 <= B3_S60_S69_D;
        B3_S70 <= B3_S61_S70_D;
        B3_S71 <= B3_S62_S71_D;
    end
end

