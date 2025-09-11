

`define NOP     4'b0001  //No operation do nothing
`define ADD     4'b0010  //ADD the values stored in two registers and store them in another register
`define MUL     4'b0011  //Multiply the values stored in two registers and store them in another register
`define LDSW    4'b0100  //load the switch value into a register
`define LDI     4'b0101  // Load Immediate
`define LDROM   4'b0110  //Load the noisy values from rom into a register
`define MOVSW   4'b0111  // EE, load sw[6:0] into register
`define LDRIND  4'b1000  // EC, load rom[reg + offset]
`define JMP     4'b1001  //Absolute branch jump to a designated address in the program memory 
`define BEQ     4'b1010  //Branches to a designiated location if the value is equalto zero 












