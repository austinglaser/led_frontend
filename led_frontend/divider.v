module divider #(
    parameter integer DIVISOR = 1
) (
    input clk,
    input resetn,
    output divided
);
    reg [$clog2(DIVISOR):0] counter;

    always @(posedge clk) begin
        if (!resetn) begin
            counter <= DIVISOR - 1;
        end else begin
            if (counter == 0) begin
                counter <= DIVISOR - 1;
            end else begin
                counter <= counter - 1;
            end
        end
    end

    assign divided = (DIVISOR == 1)
                        ? clk
                        : counter >= DIVISOR / 2;

endmodule
