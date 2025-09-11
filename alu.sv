//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module for picoMIPS
// Version: 1,  only 8 funcs
// Author:  tjk
// Last rev. 23 Oct 12
//-----------------------------------------------------

`include "alucodes.sv"  
module alu #(parameter n =8) (
   input logic [n-1:0] a, b, // ALU operands
   input logic [3:0] func, // ALU function code
   input logic stable_sw7,
   input logic [7:0] sw,
   output logic [3:0] flags, // ALU flags V,N,Z,C
   output logic [n-1:0] result // ALU result
   
);       
//------------- code starts here ---------
logic signed [7:0] signed_a, signed_b;
  logic signed [15:0] mul_result;

assign signed_a = a;  // Interpret as signed
assign signed_b = b;


// create an n-bit adder 
// and then build the ALU around the adder
logic[n-1:0] ar,b1; // temp signals
always_comb
begin
   if(func==`RSUB)
      b1 = ~b + 1'b1; // 2's complement subtrahend
   else b1 = b;

   ar = a+b1; // n-bit adder
end // always_comb
   
// create the ALU, use signal ar in arithmetic operations
always_comb
begin
  //default output values; prevent latches 
  flags = 3'b0;
  result = a; // default
  mul_result = 16'h0000;
  //result = 10101010;
  case(func)
  
	   `RB   : begin
        result = b;
        $display("it is in the RB ALU");
        end
     `RADD  : begin

      result = signed_a + signed_b;  // 8-bit signed addition
        flags[3] = result[7];          // N: Negative
        flags[2] = (result == 8'h00);  // Z: Zero
        flags[1] = (signed_a[7] & signed_b[7] & ~result[7]) | 
                   (~signed_a[7] & ~signed_b[7] & result[7]);  // C: Carry
        flags[0] = (signed_a[7] & signed_b[7] & ~result[7]) | 
                   (~signed_a[7] & ~signed_b[7] & result[7]);  // V: Overflow

        $display("it is in the RADD ALU");
       
		end

    `MUL_ALU: begin  // MUL
        mul_result = signed_a * signed_b;  // 16-bit signed multiplication
        result = mul_result[14:7];         // Most significant 8 bits

        $display("it is in the MUL_ALU ALU");
      end

    `RSUB  : begin

        result = b - a;  // a = Rdata1, b = Rdata2
        flags[1] = (result == 0); // Zero flag
	     //result = ar; // arithmetic subtraction
		  // V
        flags[3] = ~a[7] & b[7] & ~result[7] |  a[7] & ~b[7] 
                  & result[7];
        // C - note: picoMIPS inverts carry when subtracting
        flags[0] = a[7] & ~b[7] |  a[7] & result[7] | ~b[7] 
                  & result[7];

        
		end

    `LSW :begin
         result = {7'b0, stable_sw7};
         
        $display("it is in the LDSw alu");
        $display("the value of stable_sw7 is %b",stable_sw7);
        $display("the value of result is %b",result);
     end      

     

    `LDR: begin

        result = b; // b = rom_dout when imm = 1
        $display("it is in LDR alu");

    end

    `MOVSW_ALU: begin  // 4'b1010
         result = {1'b0, sw[6:0]};
         $display("it is in the MOVSW alu");
         end

   

    default: begin

        result = 8'h00; 
        
    end

   endcase
	 
 
    // calculate flags Z and N
  flags[1] = result == {n{1'b0}}; // Z
  flags[2] = result[n-1]; // N
 
 end //always_comb

endmodule //end of module ALU


