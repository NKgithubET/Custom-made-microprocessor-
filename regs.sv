module regs #(parameter n = 8) (
    input logic clk, w, reset,
    input logic [n-1:0] Wdata,
    input logic [4:0] Raddr1, Raddr2, Waddr,  // Added Waddr
    output logic [n-1:0] Rdata1, Rdata2
);
    logic [n-1:0] gpr [31:0];
    
    always_ff @(posedge clk or negedge reset) begin
        if (~reset) begin
            for (int i = 0; i < 32; i++) gpr[i] <= 0;
        end else if (w) begin
            gpr[Waddr] <= Wdata;
            $display("Regfile write: %d = %h", Waddr, Wdata);  // Debug
        end
    end
    
    assign Rdata1 = (Raddr1 == 5'd0) ? 8'h00 : gpr[Raddr1];
    assign Rdata2 = (Raddr2 == 5'd0) ? 8'h00 : gpr[Raddr2];
endmodule