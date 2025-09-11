//---------------------------------------------------------
// File Name   : decodertest.sv
// Function    : Testbench for picoMIPS instruction decoder 
// Author: tjk
// Last revised: [Current Date]
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"

module decodertest;

    // Declare inputs to the decoder
    logic [5:0] opcode;
    logic [3:0] flags;

    // Declare outputs from the decoder
    logic PCincr, PCabsbranch, PCrelbranch;
    logic [2:0] ALUfunc;
    logic imm, w;

    // Instantiate the decoder (Device Under Test)
    decoder dut (
        .opcode(opcode),
        .flags(flags),
        .PCincr(PCincr),
        .PCabsbranch(PCabsbranch),
        .PCrelbranch(PCrelbranch),
        .ALUfunc(ALUfunc),
        .imm(imm),
        .w(w)
    );

    // Test procedure
    initial begin
        // Test NOP
        opcode = `NOP;
        flags = 4'b0000; // Flags don't affect NOP
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `NOP[2:0] || imm != 0 || w != 0)
            $display("Error in NOP: PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test ADD
        opcode = `ADD;
        flags = 4'b0000; // Flags don't affect ADD
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `ADD[2:0] || imm != 0 || w != 1)
            $display("Error in ADD: PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test SUB
        /*opcode = `SUB;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `SUB[2:0] || imm != 0 || w != 1)
            $display("Error in SUB: PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        /*// Test ADDI
        opcode = `ADDI;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `ADDI[2:0] || imm != 1 || w != 1)
            $display("Error in ADDI: PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

       /* // Test SUBI
        opcode = `SUBI;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `SUBI[2:0] || imm != 1 || w != 1)
            $display("Error in SUBI: PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BEQ with Z=1 (flags[1]=1, branch taken)
        opcode = `BEQ;
        flags = 4'b0010;
        #1;
        /*if (PCincr != 0 || PCabsbranch != 0 || PCrelbranch != 1 || 
            ALUfunc != `BEQ[2:0] || imm != 0 || w != 0)
            $display("Error in BEQ (Z=1): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BEQ with Z=0 (flags[1]=0, no branch)
        opcode = `BEQ;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `BEQ[2:0] || imm != 0 || w != 0)
            $display("Error in BEQ (Z=0): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        /*// Test BNE with Z=0 (flags[1]=0, branch taken)
        opcode = `BNE;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 0 || PCabsbranch != 0 || PCrelbranch != 1 || 
            ALUfunc != `BNE[2:0] || imm != 0 || w != 0)
            $display("Error in BNE (Z=0): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BNE with Z=1 (flags[1]=1, no branch)
       /* opcode = `BNE;
        flags = 4'b0010;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `BNE[2:0] || imm != 0 || w != 0)
            $display("Error in BNE (Z=1): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BGE with N=0 (flags[2]=0, branch taken)
      /*  opcode = `BGE;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 0 || PCabsbranch != 0 || PCrelbranch != 1 || 
            ALUfunc != `BGE[2:0] || imm != 0 || w != 0)
            $display("Error in BGE (N=0): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BGE with N=1 (flags[2]=1, no branch)
        /*opcode = `BGE;
        flags = 4'b0100;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `BGE[2:0] || imm != 0 || w != 0)
            $display("Error in BGE (N=1): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BLO with C=1 (flags[0]=1, branch taken)
       /* opcode = `BLO;
        flags = 4'b0001;
        #1;
        /*if (PCincr != 0 || PCabsbranch != 0 || PCrelbranch != 1 || 
            ALUfunc != `BLO[2:0] || imm != 0 || w != 0)
            $display("Error in BLO (C=1): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        // Test BLO with C=0 (flags[0]=0, no branch)
       /* opcode = `BLO;
        flags = 4'b0000;
        #1;
        /*if (PCincr != 1 || PCabsbranch != 0 || PCrelbranch != 0 || 
            ALUfunc != `BLO[2:0] || imm != 0 || w != 0)
            $display("Error in BLO (C=0): PCincr=%b, PCabsbranch=%b, PCrelbranch=%b, ALUfunc=%b, imm=%b, w=%b",
                     PCincr, PCabsbranch, PCrelbranch, ALUfunc, imm, w);*/

        $display("Test completed.");
        $finish;
    end

endmodule