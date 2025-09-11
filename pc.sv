
module pc #(parameter Psize = 8) (
    input logic clk, reset,
    input logic PCincr, PCabsbranch, PCrelbranch,
    input logic [Psize-1:0] Branchaddr,
    output logic [Psize-1:0] PCout
);
    logic [Psize-1:0] PC;
    always_ff @(posedge clk or negedge reset) begin
        if (~reset)
            PC <= 0;
        else if (PCabsbranch)
            PC <= Branchaddr;      // Jump to absolute address
        else if (PCrelbranch)
            PC <= PC + Branchaddr; // Relative branch (not used here)
        else if (PCincr)
            PC <= PC + 1;          // Normal increment
    end
    assign PCout = PC;
endmodule