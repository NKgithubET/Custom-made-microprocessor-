//-----------------------------------------------------
// File Name : regstest.sv
// Function : testbench for pMIPS 32 x n registers, %0 == 0
// Version 1 : Adapted for single write port register file
// Author: [Your Name]
// Last rev. [Current Date]
//-----------------------------------------------------
module regstest;

parameter n = 8;

logic clk, w;
logic [n-1:0] Wdata;
logic [4:0] Raddr1, Raddr2;
logic [n-1:0] Rdata1, Rdata2;

regs #(.n(n)) r(.*);

initial
begin
  clk = 0;
  #5ns forever #5ns clk = ~clk;
end

initial
begin
    // Initial setup: write to registers 1 and 2 sequentially
    w = 1;
    Raddr1 = 1;
    Raddr2 = 2;
    Wdata = 11;         // Write 11 to register 1
    #10 Wdata = 12;     // After 10ns, write 12 to register 2 (Raddr2 = 2)

    // Disable write and hold for observation
    #12 w = 0;

    // Change Wdata, but no write yet
    #10 Wdata = 8'hFF;

    // Write to register 0 to test zero-register behavior
    #10 w = 1;
    Raddr2 = 0;         // Select register 0
    #10 w = 0;          // Disable write after write attempt

    // End simulation
    #10 $finish;
end

endmodule // module regstest