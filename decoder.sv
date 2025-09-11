//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder (final fixed version)
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"

module decoder (
    input  logic [3:0] opcode,
    input  logic [3:0] flags,      // [3]=V, [2]=N, [1]=Z, [0]=C
    output logic PCincr,           // Increment PC
    output logic PCabsbranch,      // Absolute branch
    output logic PCrelbranch,      // Relative branch
    output logic [3:0] ALUfunc,
    output logic imm,
    output logic w
);

    // Internal signals
    logic takeBranch;
    //logic [7:0] last_known_pc;  // For debug tracking

    always_comb begin
        // Default values (safe state)
        PCincr      = 1'b1;
        PCabsbranch = 1'b0;
        PCrelbranch = 1'b0;
        ALUfunc     = 3'b000;  // Pass-through
        imm         = 1'b0;
        w           = 1'b0;
        takeBranch  = 1'b0;

        case (opcode)
            //----- Core Operations -----
            `NOP:begin
              
              $display("it is in the NOP decoder");
              
            end   // No changes to defaults
            
            `ADD: begin
                ALUfunc = `RADD;  // ADD function
                imm = 1'b0;         // Register-based
                w = 1'b1;
                $display("it is in the ADD decoder, ALUfunc = %b", ALUfunc);
            end
            

            `MUL: begin
                ALUfunc = `MUL_ALU;  // New MUL function
                imm = 1'b1;        // Register-based
                w = 1'b1;          // Write result
                $display("it is in the MUL decoder, ALUfunc = %b", ALUfunc);
                
                end

        
            `LDSW: begin
                ALUfunc = `LSW;
                imm = 1'b0;
                 w = 1'b1;
                 $display("it is in the LDSW decoder, ALUfunc = %b", ALUfunc);
                end
 

            `LDI: begin
              ALUfunc = `RB;  // Pass immediate value
              imm = 1'b1;
              w = 1'b1;
              $display("it is in the LDI decoder");
               end

            `LDROM: begin
              ALUfunc = `LDR;  // Reuse `LDR` ALU function (4'b1001)
              imm = 1'b0;      // Don’t use immediate from instruction
              w = 1'b1;        // Write to register
              $display("it is in the LDROM decoder, ALUfunc = %b", ALUfunc);
            end
            
            `MOVSW: begin
                ALUfunc = `MOVSW_ALU;  // New ALUfunc for MOVSW
                imm = 1'b0;
                w = 1'b1;
                $display("it is in the MOVSW decoder");
                end


            `LDRIND: begin
                ALUfunc = `LDR;  // 4'b1001
                imm = 1'b1;      // Use Rdata2 + I[7:0]
                w = 1'b1;
                $display("it is in the LDRIND decoder, ALUfunc = %b", ALUfunc);
                end

            


            `JMP: begin  // JMP (absolute jump)
                PCincr = 0;        // Don’t increment
                PCabsbranch = 1;   // Absolute branch to Branchaddr
                ALUfunc = 3'b111;  // No ALU operation
                w=1'b0;
            end


            `BEQ: 
            begin
                ALUfunc = `RSUB ;
                if (flags[1]) begin
                  PCincr = 0;      // Don’t increment if branching
                  PCrelbranch = 1; // Take the branch
                end else begin
                   PCincr = 1;      // Increment if not branching
                    PCrelbranch = 0; // Don’t branch
                end
                $display("it is in the BEQ decoder");
                w=1'b0;
            end 

            
            default: begin
                $display("WARNING: Unknown opcode %b (%h) at time %t", 
                        opcode, opcode, $time);
                // Safe defaults
                PCincr = 1'b1;
                w = 1'b0;
            end
        endcase

        // Handle branch conditions
        if (takeBranch) begin
            PCincr = 1'b0;
            PCrelbranch = 1'b1;
        end
    end

endmodule