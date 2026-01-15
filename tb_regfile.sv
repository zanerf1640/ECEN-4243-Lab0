/*
This is the testbench for the register file module.
It tests basic read and write operations, as well as the reset functionality.
*/

module stimulus ();

   logic         clk;
   logic         we3;
   logic         reset;
   logic [4:0]   ra1, ra2, wa3;
   logic [31:0]  wd3;
   logic [31:0]  rd1, rd2;
   
   integer handle;
   integer desc;
   
   // Instantiate DUT
   regfile dut (clk, we3, reset, ra1, ra2, wa3, wd3, rd1, rd2);

   // Setup the clock to toggle every 5 time units 
   initial 
     begin	
    clk = 1'b1;
    forever #5 clk = ~clk;
     end

   initial
     begin
    // Gives output file name
    handle = $fopen("regfile_test.out");
    // Tells when to finish simulation
    #300 $finish;		
     end

   always 
     begin
    desc = handle;
    #10 $fdisplay(desc, "%b %b %b %b || %b %b", 
             reset, we3, wa3, wd3, rd1, rd2);
     end   
   
   initial 
     begin      
    // Test 1: Reset the register file
    #0  reset = 1'b1; we3 = 1'b0; ra1 = 5'd0; ra2 = 5'd0;
    #10 reset = 1'b0;	

    // Test 2: Write to register 5
    #10 we3 = 1'b1; wa3 = 5'd5; wd3 = 32'hA5A5A5A5;
    #10 we3 = 1'b0; 

    // Test 3: Read from register 5 with both ports
    #10 ra1 = 5'd5; ra2 = 5'd5;

    // Test 4: Write to register 10
    #10 we3 = 1'b1; wa3 = 5'd10; wd3 = 32'h5A5A5A5A;
    #10 we3 = 1'b0; 

    // Test 5: Read from different registers on both ports
    #10 ra1 = 5'd10; ra2 = 5'd5;

    // Test 6: Attempt to write to register 0 (should remain 0)
    #10 we3 = 1'b1; wa3 = 5'd0; wd3 = 32'hFFFFFFFF;
    #10 we3 = 1'b0; 

    // Test 7: Verify register 0 is still zero
    #10 ra1 = 5'd0; ra2 = 5'd0;

    // Test 8: Write to register 15
    #10 we3 = 1'b1; wa3 = 5'd15; wd3 = 32'h12345678;
    
    // Test 9: Read register 15 while it's being written (simultaneous read/write)
    #0  ra1 = 5'd15; ra2 = 5'd10;
    #10 we3 = 1'b0;

    // Test 10: Verify register 15 has new value
    #10 ra1 = 5'd15; ra2 = 5'd15;

    // Test 11: Write to multiple registers
    #10 we3 = 1'b1; wa3 = 5'd7; wd3 = 32'hDEADBEEF;
    #10 wa3 = 5'd20; wd3 = 32'hCAFEBABE;
    #10 wa3 = 5'd31; wd3 = 32'hFEEDFACE;
    #10 we3 = 1'b0;

    // Test 12: Read the newly written registers
    #10 ra1 = 5'd7; ra2 = 5'd20;
    #10 ra1 = 5'd31; ra2 = 5'd5;

    // Test 13: Reset the register file
    #10 reset = 1'b1;
    #10 reset = 1'b0;

    // Test 14: Verify all registers are zeroed after reset
    #10 ra1 = 5'd5; ra2 = 5'd10;
    #10 ra1 = 5'd15; ra2 = 5'd7;
    #10 ra1 = 5'd20; ra2 = 5'd31;    
     end
endmodule // stimulus