module prog #(parameter Psize = 6, Isize = 20) (
    input logic [Psize-1:0] address,
    output logic [Isize-1:0] I  //
);
logic [Isize-1:0] progMem [0:(1<<Psize)-1];
initial begin
    for (int i=0; i<2**Psize; i++) begin
        progMem[i] = 20'h000000;  // 24-bit NOP
    end
        progMem[0] = 20'h00000;  // NOP

        progMem[1] = 20'h42800;  // LDSW %5                                                       0100_00101_00000_000000  opcode_destinationregister_xxxxx_xxxxx
        progMem[2] = 20'hA2810;  // BEQ %5, %0, +16  (If %5 == 0, skip 16 instructions)            1010_00101_00000_010000   opcode_source register_xxxxx_immediate
            

        progMem[3] = 20'h75800;  // MOVSW %11, sw[6:0] (base address)                              0111_01011_00000_000000    opcode_destinationregister_xxxxx_xxxxx
        progMem[4] = 20'h832FE;  // LDRIND %6, rom[%11 -2 ]                                        1000_00110_01011_111110    opcode_destinationregister_sourceregister_offsetvalue
        progMem[5] = 20'h83AFF;  // LDRIND %7, rom[%11 -1 ]                                        1000_00111_01011_111111
        progMem[6] = 20'h842C0;  // LDRIND %8, rom[%11 + 0 ]                                       1000 01000 01011 000000
        progMem[7] = 20'h84AC1;  // LDRIND %9, rom[%11 + 1 ]                                       1000 01001 01011 000001
        progMem[8] = 20'h852C2;  // LDRIND %10, rom[%11 + 2 ]                                      1000 01010 01011 000010

        
        progMem[9] = 20'h36191;   //Store in %12 by multiplying the value in %6 and the kernel value in the filler  0011_01100_00110_010001   opcode_destinationregister_sourceregister_kernelvalue
        progMem[10] = 20'h369DD;  //Store in %13 by multiplying the value in %7 and the kernel value in the filler  0011 01101 00111 011101
        progMem[11] = 20'h37223;  //Store in %14 by multiplying the value in %8 and the kernel value in the filler  0011 01110 01000 100011
        progMem[12] = 20'h37A5D;  //Store in %15 by multiplying the value in %9 and the kernel value in the filler  0011 01111 01001 011101
        progMem[13] = 20'h38291;  //Store in %16 by multiplying the value in %10 and the kernel value in the filler  0011 10000 01010 010001

        progMem[14] = 20'h20B0D;  //ADD %1, %12, %13                                            0010_00001_01100_001101    opcode_destinationregister_sourceregister1_sourceregister2_xxxxx
        progMem[15] = 20'h20B81;  //ADD %1, %14, %1                                            0010 00001 01110 000001
        progMem[16] = 20'h20BC1;  //ADD %1, %15, %1                                            0010 00001 01111 000001
        progMem[17] = 20'h20C01;  //ADD %1, %16, %1                                            0010 00001 10000 000001#

        progMem[18] = 20'h51000;  // LDI %2, 0x00  (Load 0x00 into %2 if stable_sw7 = 0)       0101_00010_00000_000000 opcode_destinationregister_xxxxxx_immediatevalue
        progMem[19] = 20'h90000;  // JMP 0  (Loop back)                                        1001_00000_00000_000000 opcode_destinationregister_xxxxxx_xxxxxx                               
    
end
always_comb begin
    I = progMem[address];
end
endmodule


