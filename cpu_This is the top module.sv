`include "alucodes.sv"
module cpu #( parameter n = 8) // data bus width
(input logic clk,  
  input logic reset,
  input logic [7:0] sw, 
  output logic[n-1:0] outport // need an output port, tentatively this will be the ALU output
);       

//assign outport[0] = reset;

// declarations of local signals that connect CPU modules
// ALU
logic [3:0] ALUfunc; // ALU function
logic [3:0] flags; // ALU flags, routed to decoder
logic imm; // immediate operand signal
logic [n-1:0] Alub; // output from imm MUX
//
// registers
logic [n-1:0] Rdata1, Rdata2, Wdata; // Register data
logic w; // register write control
//
// Program Counter 
parameter Psize = 8; // up to 64 instructions
logic PCincr,PCabsbranch,PCrelbranch; // program counter control
logic [Psize-1 : 0]ProgAddress;
// Program Memory
parameter Isize = n+12; // Isize - instruction width
logic [Isize-1:0] I; // I - instruction code
//reg [2:0] custom_counter;
// Debounced sw[7]
logic stable_sw7;

// ROM signals
logic [Psize-1:0] rom_addr;
logic [n-1:0] rom_dout;
//logic [n-1:0] Alub;

// Index from switches (7 bits: 0-127)
logic [6:0] sw_index;
assign sw_index = sw[6:0]; // Use sw[6:0]
logic signed [7:0] offset;

logic [4:0] Raddr2_sel;


debounce #(.DEBOUNCE_LIMIT(2)) debouncer (
        .clk(clk),
        .reset(reset),
        .sw7(sw[7]),
        .stable_sw7(stable_sw7)
    );


pc  #(.Psize(Psize)) pc (.clk(clk),.reset(reset),
        .PCincr(PCincr),
        .PCabsbranch(PCabsbranch),
        .PCrelbranch(PCrelbranch),
        .Branchaddr(I[Psize-1:0]), 
        .PCout(ProgAddress) );

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.address(ProgAddress),.I(I));

decoder  D (.opcode(I[Isize-1:Isize-4]),
            .PCincr(PCincr),
            .PCabsbranch(PCabsbranch), 
            .PCrelbranch(PCrelbranch),
            .flags(flags), // ALU flags
		  .ALUfunc(ALUfunc),.imm(imm),.w(w));

assign Raddr2_sel = (I[19:16] == 6'b0010) ? I[5:0] : I[Isize-5:Isize-9];  // ADD uses I[7:3]

regs #(.n(n)) gpr (
        .clk(clk), .w(w), .Wdata(Wdata), .reset(reset),
        .Raddr1(I[Isize-10:Isize-14]),  // I[12:8]
        .Raddr2(Raddr2_sel),
        .Waddr(I[Isize-5:Isize-9]),     // I[17:13]
        .Rdata1(Rdata1), .Rdata2(Rdata2)
    );

alu    #(.n(n))  iu(.a(Rdata1),.b(Alub),
       .func(ALUfunc),.flags(flags),.stable_sw7(stable_sw7),
       .result(Wdata),.sw(sw)); // ALU result -> destination reg

// ROM
    rom #(.WIDTH(n), .DEPTH(256), .ADDR_WIDTH(8)) dataMemory (
        .clk(clk), .addr(rom_addr), .dout(rom_dout)
    );

// ROM address: Extend sw_index to 8 bits
logic [7:0] base_index;
assign base_index = {1'b0, sw_index}; // Zero-extend 7-bit to 8-bit
    
assign offset = {{2{I[5]}}, I[5:0]};  // Sign-extend 6-bit to 8-bit
//assign sum = Rdata1 + offset;
//logic [5:0] sum_truncated;
//assign sum_truncated = sum[5:0];

assign rom_addr = (imm && ALUfunc == 4'b1001) ? (I[19:16] == 4'b1000 ? (Rdata1 + offset) : I[5:0]) : base_index;

//assign rom_addr = (imm && ALUfunc == 4'b1001) ? (I[19:16] == 4'b1000 ? (Rdata1 + offset)[5:0] : I[5:0]) : base_index;
//assign rom_addr = (imm && ALUfunc == 4'b1001) ? (I[19:16] == 4'b1000  ? (Rdata1 + I[5:0] ) : I[5:0]) : base_index; //I[21:18]=load rom[reg + offset],should be changed 

assign Alub = (ALUfunc == 4'b1001) ? rom_dout : (imm ? I[n-3:0] : Rdata2);

// connect ALU result to outport conditionally
assign outport = (ProgAddress == 8'd17 || ProgAddress == 8'd18) ? Wdata : {n{1'b0}};


always @(posedge clk) begin
  $display("Time=%0t | rom_addr=%h | rom_dout=%h | Alub=%h | Wdata=%h | w=%b | Raddr1=%b", 
                 $time, rom_addr, rom_dout, Alub, Wdata, w, I[Isize-10:Isize-14]);

  $display("Time=%0t | I=%h | imm=%b | ALUfunc=%b | Rdata2=%h | rom_addr=%h", 
           $time, I, imm, ALUfunc, Rdata2, rom_addr);
end
endmodule