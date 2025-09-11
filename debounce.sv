//------------------------------------
// File Name   : debounce.sv
// Function    : Debounce logic for sw[7]
//------------------------------------
module debounce #(
    parameter DEBOUNCE_LIMIT = 2  // Adjust based on clock frequency (e.g., 20ns period = 50 MHz)
) (
    input logic clk,       // Same clock as CPU (50 MHz)
    input logic reset,     // Active-low reset (rename to avoid conflict with CPU reset)
    input logic sw7,         // Switch input sw[7]
    output logic stable_sw7  // Debounced output
);
    logic [19:0] debounce_counter;  // 20-bit counter for up to ~1M cycles

    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin
            debounce_counter <= 0;
            stable_sw7 <= 0;
        end else begin
            if (sw7 != stable_sw7) begin
                if (debounce_counter == DEBOUNCE_LIMIT - 1) begin
                    stable_sw7 <= sw7;           // Update stable output after limit reached
                    debounce_counter <= 0;       // Reset counter
                end else begin
                    debounce_counter <= debounce_counter + 1;  // Increment counter
                end
            end else begin
                debounce_counter <= 0;  // Reset counter if input matches stable output
            end
        end
    end
endmodule
