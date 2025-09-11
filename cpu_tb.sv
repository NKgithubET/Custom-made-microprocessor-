`timescale 1ns / 1ns  // Time unit = 1ns, precision = 1ns
module cpu_tb;
    parameter n = 8;
    parameter Psize = 6;
    parameter Isize = n + 16;
    parameter CLK_PERIOD = 20;

    logic clk, reset;
    logic [n-1:0] outport;
    logic [7:0] sw;

    logic [7:0] expected_r1 [0:127];  // Moved to module scope
    logic [7:0] last_r1;  // Explicitly declared for regs[1] writes
    integer test_cases [0:9];         // Changed int to integer
    integer i;                        // Loop variable

    cpu #(.n(n)) dut (.clk(clk), .reset(reset), .outport(outport), .sw(sw));

    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    

    initial begin
        reset = 0;
        sw = 8'b10101101; // Initialize sw[7] to 0
        #10;
        reset = 1;

        $display("Simulation started at time %0t", $time);
        
        // Test Case 1: sw[7] = 0 (initial state), run for 40ns (2 cycles)
        #2;
        
        // Test Case 2: sw[7] = 1 (switch pressed), run for 80ns (4 cycles)
       // sw = 8'b10101101;
        sw = 8'b10101101;
        #450;
        
        // Test Case 3: sw[7] = 0 (switch released with bounce), run for 80ns (4 cycles)
       /* sw = 8'b00101101;
        #20;  // Bounce low for 20ns
        sw = 8'b10101101;  // Bounce high
        #80;  // Bounce high for 20ns
        sw = 8'b00101101;  // Settle low
        #350;*/

        // Test Case 4: Corner and major cases
        //$display("Testing corner and major cases for sw[6:0] with sw[7]=1");
      
      reset = 0;
        //sw = 8'h00;  // Initialize sw[7] to 0
        #10;
        reset = 1;
       
        
       

        

        $display("Simulation ended at time %0t", $time);
        $finish;
    end

    always @(posedge clk) begin
        // Display general CPU state
        $display("Time=%0t | reset=%b | PC=%0d | I=%h | Rdata1=%h | Rdata2=%h | Wdata=%h | outport=%h | flags=%b",
                 $time, reset, dut.ProgAddress, dut.I, dut.Rdata1, dut.Rdata2, dut.Wdata, dut.outport, dut.flags);    
    
      
    
        // Display register 5 when read via Raddr1
        if (dut.I[10:6] == 5'h05) begin
            $display("  Register 5 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 5 when read via Raddr2
        if (dut.I[15:11] == 5'h05) begin
            $display("  Register 5 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 5 when written
        if (dut.w && (dut.I[15:11] == 5'h05)) begin
            $display("  Register 5 (written): %h", dut.Wdata);
        end





        // Display register 6 when read via Raddr1
        if (dut.I[10:6] == 5'h06) begin
            $display("  Register 6 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 6 when read via Raddr2
        if (dut.I[15:11] == 5'h06) begin
            $display("  Register 6 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 6 when written
        if (dut.w && (dut.I[15:11] == 5'h06)) begin
            $display("  Register 6 (written): %h", dut.Wdata);
        end


          // Display register 7 when read via Raddr1
        if (dut.I[10:6] == 5'h07) begin
            $display("  Register 7 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 7 when read via Raddr2
        if (dut.I[15:11] == 5'h07) begin
            $display("  Register 7 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 7 when written
        if (dut.w && (dut.I[15:11] == 5'h07)) begin
            $display("  Register 7 (written): %h", dut.Wdata);
        end



          // Display register 8 when read via Raddr1
        if (dut.I[10:6] == 5'h08) begin
            $display("  Register 8 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 8 when read via Raddr2
        if (dut.I[15:11] == 5'h08) begin
            $display("  Register 8 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 8 when written
        if (dut.w && (dut.I[15:11] == 5'h08)) begin
            $display("  Register 8 (written): %h", dut.Wdata);
        end


          // Display register 9 when read via Raddr1
        if (dut.I[10:6] == 5'h09) begin
            $display("  Register 9 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 9 when read via Raddr2
        if (dut.I[15:11] == 5'h09) begin
            $display("  Register 9 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 9 when written
        if (dut.w && (dut.I[15:11] == 5'h09)) begin
            $display("  Register 9 (written): %h", dut.Wdata);
        end






          // Display register 10 when read via Raddr1
        if (dut.I[10:6] == 5'h0A) begin
            $display("  Register 10 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 10 when read via Raddr2
        if (dut.I[15:11] == 5'h0A) begin
            $display("  Register 10 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 10 when written
        if (dut.w && (dut.I[15:11] == 5'h0A)) begin
            $display("  Register 10 (written): %h", dut.Wdata);
        end


          // Display register 11 when read via Raddr1
        if (dut.I[10:6] == 5'h0B) begin
            $display("  Register 11 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 11 when read via Raddr2
        if (dut.I[15:11] == 5'h0B) begin
            $display("  Register 11 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 11 when written
        if (dut.w && (dut.I[15:11] == 5'h0B)) begin
            $display("  Register 11 (written): %h", dut.Wdata);
        end



         // Display register 12 when read via Raddr1
        if (dut.I[10:6] == 5'h0C) begin
            $display("  Register 12 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 12 when read via Raddr2
        if (dut.I[15:11] == 5'h0C) begin
            $display("  Register 12 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 12 when written
        if (dut.w && (dut.I[15:11] == 5'h0C)) begin
            $display("  Register 12 (written): %b", dut.Wdata);
        end



         // Display register 13 when read via Raddr1
        if (dut.I[10:6] == 5'h0D) begin
            $display("  Register 13 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 13 when read via Raddr2
        if (dut.I[15:11] == 5'h0D) begin
            $display("  Register 13 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 13 when written
        if (dut.w && (dut.I[15:11] == 5'h0D)) begin
            $display("  Register 13 (written): %b", dut.Wdata);
        end


        // Display register 14 when read via Raddr1
        if (dut.I[10:6] == 5'h0E) begin
            $display("  Register 14 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 14 when read via Raddr2
        if (dut.I[15:11] == 5'h0E) begin
            $display("  Register 14 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 14 when written
        if (dut.w && (dut.I[15:11] == 5'h0E)) begin
            $display("  Register 14 (written): %b", dut.Wdata);
        end



        // Display register 15 when read via Raddr1
        if (dut.I[10:6] == 5'h0F) begin
            $display("  Register 15 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 15 when read via Raddr2
        if (dut.I[15:11] == 5'h0F) begin
            $display("  Register 15 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 15 when written
        if (dut.w && (dut.I[15:11] == 5'h0F)) begin
            $display("  Register 15 (written): %b", dut.Wdata);
        end





        // Display register 16 when read via Raddr1
        if (dut.I[10:6] == 5'h10) begin
            $display("  Register 16 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 16 when read via Raddr2
        if (dut.I[15:11] == 5'h10) begin
            $display("  Register 16 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 16 when written
        if (dut.w && (dut.I[15:11] == 5'h10)) begin
            $display("  Register 16 (written): %b", dut.Wdata);
        end


        // Display register 01 when read via Raddr1
        if (dut.I[10:6] == 5'h01) begin
            $display("  Register 02 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 01 when read via Raddr2
        if (dut.I[15:11] == 5'h01) begin
            $display("  Register 01 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 01 when written
        if (dut.w && (dut.I[15:11] == 5'h01)) begin
            $display("  Register 01 (written): %b", dut.Wdata);
        end



         // Display register 03 when read via Raddr1
        if (dut.I[10:6] == 5'h03) begin
            $display("  Register 03 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 03 when read via Raddr2
        if (dut.I[15:11] == 5'h03) begin
            $display("  Register 03 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 03 when written
        if (dut.w && (dut.I[15:11] == 5'h03)) begin
            $display("  Register 03 (written): %b", dut.Wdata);
        end



        // Display register 17 when read via Raddr1
        if (dut.I[10:6] == 5'h11) begin
            $display("  Register 17 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 17 when read via Raddr2
        if (dut.I[15:11] == 5'h11) begin
            $display("  Register 17 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 17 when written
        if (dut.w && (dut.I[15:11] == 5'h11)) begin
            $display("  Register 17 (written): %b", dut.Wdata);
        end




        // Display register 18 when read via Raddr1
        if (dut.I[10:6] == 5'h12) begin
            $display("  Register 18 (read via Raddr1): %h", dut.Rdata1);
        end
        
        // Display register 18 when read via Raddr2
        if (dut.I[15:11] == 5'h12) begin
            $display("  Register 18 (read via Raddr2): %h", dut.Rdata2);
        end
        
        // Display register 18 when written
        if (dut.w && (dut.I[15:11] == 5'h12)) begin
            $display("  Register 18 (written): %b", dut.Wdata);
        end




    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);
    end
endmodule