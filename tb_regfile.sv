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
      #200 $finish;		
      end

   always 
     begin
    desc = handle;
    #10 $fdisplay(desc, "%b %b %b %b || %b %b", 
             reset, we3, wa3, wd3, rd1, rd2);
     end   
   
   initial 
     begin      
    #0  reset = 1'b1;
    #10 reset = 1'b0;	

    // Write to register 5
    #10 we3 = 1'b1; 
    #10 wa3 = 5'd5; 
    #10 wd3 = 32'hA5A5A5A5;
    #10 we3 = 1'b0; 

    // Read from register 5
    ra1 = 5'd5; ra2 = 5'd0;

    // Write to register 10
    #10 we3 = 1'b1; 
    #10 wa3 = 5'd10; 
    #10 wd3 = 32'h5A5A5A5A;
    #10 we3 = 1'b0;

    // Read from register 10
    ra1 = 5'd0; ra2 = 5'd10;

    // Write to register 15
    #10 we3 = 1'b1; 
    #10 wa3 = 5'd15; 
    #10 wd3 = 32'hFFFFFFFF;
    #10 we3 = 1'b0;

    // Read both register 10 and 5
    ra1 = 5'd5; ra2 = 5'd10;

    // Reset the register file
    #10 reset = 1'b1;
    #10 reset = 1'b0;

     end
endmodule // stimulus
