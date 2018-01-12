module top (
    input clk,

    output B0_C,
    output B0_LE0,
    output B0_LE1,
    output B0_S00_S09_D,
    output B0_S01_S10_D,
    output B0_S02_S11_D,
    output B0_S03_S12_D,
    output B0_S04_S13_D,
    output B0_S05_S14_D,
    output B0_S06_S15_D,
    output B0_S07_S16_D,
    output B0_S08_S17_D,

    output B1_C,
    output B1_LE0,
    output B1_LE1,
    output B1_S18_S27_D,
    output B1_S19_S28_D,
    output B1_S20_S29_D,
    output B1_S21_S30_D,
    output B1_S22_S31_D,
    output B1_S23_S32_D,
    output B1_S24_S33_D,
    output B1_S25_S34_D,
    output B1_S26_S35_D,

    output B2_C,
    output B2_LE0,
    output B2_LE1,
    output B2_S36_S45_D,
    output B2_S37_S46_D,
    output B2_S38_S47_D,
    output B2_S39_S48_D,
    output B2_S40_S49_D,
    output B2_S41_S50_D,
    output B2_S42_S51_D,
    output B2_S43_S52_D,
    output B2_S44_S53_D,

    output B3_C,
    output B3_LE0,
    output B3_LE1,
    output B3_S54_S63_D,
    output B3_S55_S64_D,
    output B3_S56_S65_D,
    output B3_S57_S66_D,
    output B3_S58_S67_D,
    output B3_S59_S68_D,
    output B3_S60_S69_D,
    output B3_S61_S70_D,
    output B3_S62_S71_D,

    input a00,
    input a01,
    input a02,
    input a03,
    input a04,
    input a05,
    input a06,
    input a07,
    input a08,
    input a09,
    input a10,
    input a11,
    input a12,
    input a13,
    input a14,
    input a15,
    input a16,
    input a17,
    input a18,
    input a19,

    inout d00,
    inout d01,
    inout d02,
    inout d03,
    inout d04,
    inout d05,
    inout d06,
    inout d07,
    inout d08,
    inout d09,
    inout d10,
    inout d11,
    inout d12,
    inout d13,
    inout d14,
    inout d15,

    input nbl0,
    input nbl1,
    input ne1,
    input ne2,
    input noe,
    input nwe
);

    reg [7:0] resetn_counter = 0;
    wire resetn = &resetn_counter;
    always @(posedge clk) begin
        if (!resetn) begin
            resetn_counter <= resetn_counter + 1;
        end
    end

    /* Control/status signals */
    reg go;
    wire [3:0] idle;

    parameter FRAME_LENGTH = 16;
    parameter STRIPS = 72;
    reg [FRAME_LENGTH-1:0] strips [STRIPS-1:0];

    wire bank_clk_divided;

    divider #(1) bank_divider(clk, resetn, bank_clk_divided);

    /* Bank instantiation */
    parameter BANKS = 4;
    wire [BANKS-1:0] bank_clock;
    wire [BANKS-1:0] bank_le0;
    wire [BANKS-1:0] bank_le1;
    wire [8:0]       bank_data [BANKS-1:0];

    assign {B3_C,   B2_C,   B1_C,   B0_C}   = bank_clock;
    assign {B3_LE0, B2_LE0, B1_LE0, B0_LE0} = bank_le0;
    assign {B3_LE1, B2_LE1, B1_LE1, B0_LE1} = bank_le1;
    assign {B0_S00_S09_D, B0_S01_S10_D,
            B0_S02_S11_D, B0_S03_S12_D,
            B0_S04_S13_D, B0_S05_S14_D,
            B0_S06_S15_D, B0_S07_S16_D,
            B0_S08_S17_D} = bank_data[0];
    assign {B1_S18_S27_D, B1_S19_S28_D,
            B1_S20_S29_D, B1_S21_S30_D,
            B1_S22_S31_D, B1_S23_S32_D,
            B1_S24_S33_D, B1_S25_S34_D,
            B1_S26_S35_D} = bank_data[1];
    assign {B2_S36_S45_D, B2_S37_S46_D,
            B2_S38_S47_D, B2_S39_S48_D,
            B2_S40_S49_D, B2_S41_S50_D,
            B2_S42_S51_D, B2_S43_S52_D,
            B2_S44_S53_D} = bank_data[2];
    assign {B3_S54_S63_D, B3_S55_S64_D,
            B3_S56_S65_D, B3_S57_S66_D,
            B3_S58_S67_D, B3_S59_S68_D,
            B3_S60_S69_D, B3_S61_S70_D,
            B3_S62_S71_D} = bank_data[3];

    wire all_idle;
    assign all_idle = &idle;

    genvar i;
    generate
        for (i = 0; i < BANKS; i = i + 1) begin : GEN_BANKS
            led_bank
                #    ( .FRAME_LENGTH(FRAME_LENGTH) )
                bank ( .clk(bank_clk_divided)
                     , .resetn(resetn)
                     , .go(go)

                     , .idle(idle[i])

                     , .frame0( strips[ 0 + (i * 18)])
                     , .frame1( strips[ 1 + (i * 18)])
                     , .frame2( strips[ 2 + (i * 18)])
                     , .frame3( strips[ 3 + (i * 18)])
                     , .frame4( strips[ 4 + (i * 18)])
                     , .frame5( strips[ 5 + (i * 18)])
                     , .frame6( strips[ 6 + (i * 18)])
                     , .frame7( strips[ 7 + (i * 18)])
                     , .frame8( strips[ 8 + (i * 18)])
                     , .frame9( strips[ 9 + (i * 18)])
                     , .frame10(strips[10 + (i * 18)])
                     , .frame11(strips[11 + (i * 18)])
                     , .frame12(strips[12 + (i * 18)])
                     , .frame13(strips[13 + (i * 18)])
                     , .frame14(strips[14 + (i * 18)])
                     , .frame15(strips[15 + (i * 18)])
                     , .frame16(strips[16 + (i * 18)])
                     , .frame17(strips[17 + (i * 18)])

                     , .dclk(bank_clock[i])
                     , .latch0(bank_le0[i])
                     , .latch1(bank_le1[i])
                     , .data(bank_data[i])
                     );
        end
    endgenerate

    /* Memory interface */
    wire [19:0] addr;
    wire [15:0] data_in;

    assign addr = {a19, a18, a17, a16, a15, a14, a13, a12, a11, a10,
                   a09, a08, a07, a06, a05, a04, a03, a02, a01, a00};
    localparam N_REGISTERS = 4;
    localparam ADDR_BITS = $clog2(N_REGISTERS);
    wire [15:0] registers [0:N_REGISTERS - 1];

    parameter STAT_OFFSET = 0;
    parameter CTRL_OFFSET = 1;
    parameter DATA_OFFSET = 2;
    parameter RSV0_OFFSET = 3;

    assign registers[STAT_OFFSET] = { 12'b0, idle };
    assign registers[CTRL_OFFSET] = 16'b0;
    assign registers[DATA_OFFSET] = 16'b0;
    assign registers[RSV0_OFFSET] = 16'b0;

    wire [ADDR_BITS-1:0] reg_addr;
    assign reg_addr = addr[ADDR_BITS-1:0];

    wire oe;
    assign oe = !ne2 && !noe;

    SB_IO #(
        .PIN_TYPE(6'b 1010_01),
        .PULLUP(1'b0)
    ) data_io [15:0] (
        .PACKAGE_PIN({d15, d14, d13, d12, d11, d10, d09, d08,
                      d07, d06, d05, d04, d03, d02, d01, d00}),
        .OUTPUT_ENABLE(oe),
        .D_OUT_0(registers[reg_addr]),
        .D_IN_0(data_in)
    );

    localparam STRIP_BITS = $clog2(STRIPS);
    reg [STRIP_BITS-1:0] strip;

    always @(posedge nwe) begin
        if (!resetn) begin
            strip <= 0;
            go <= 0;
        end else if (!ne2) begin
            (* parallel_case *)
            case (reg_addr)
                CTRL_OFFSET: begin
                    go <= data_in[0];
                    if (data_in[0]) begin
                        strip <= 0;
                    end
                end
                DATA_OFFSET: begin
                    strips[strip] <= data_in;
                    if (strip != STRIPS - 1) begin
                        strip <= strip + 1;
                    end else begin
                        strip <= 0;
                    end
                end
            endcase
        end
    end

endmodule

