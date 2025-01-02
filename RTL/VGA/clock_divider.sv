
module clock_divider (
    input logic clk,       // Original 31.5 MHz clock input
    output logic clk_out   // Divided clock output (1 Hz in this case)
);

    // This constant determines the frequency division
    // 31.5 MHz / 31,500,000 = 1 Hz
    parameter DIVIDE_COUNT = 31_500_000 / 2;
    logic [31:0] counter = 0;

    always_ff @(posedge clk) begin
        counter <= counter + 1;
        if(counter == DIVIDE_COUNT - 1) begin
            clk_out <= ~clk_out;       // Toggle clk_out
            counter <= 0;
        end
    end

endmodule
