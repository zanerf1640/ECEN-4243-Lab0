module regfile (input logic         clk, 
		input logic 	    we3,
      input logic         reset, 
		input logic [4:0]   ra1, ra2, wa3, 
		input logic [31:0]  wd3, 
		output logic [31:0] rd1, rd2);
   
   logic [31:0] 		    rf[31:0];
   
   // three ported register file
   assign rd1 = (ra1 != 0) ? rf[ra1] : 32'b0;
   assign rd2 = (ra2 != 0) ? rf[ra2] : 32'b0;
   // read two ports combinationally
   always_ff @(posedge clk) begin
      if (reset) begin
         // Reset all registers to 0
         for (int i = 0; i < 32; i++) begin
            rf[i] <= 32'b0; 
         end
      end 
      else if (we3 && (wa3 != 0)) begin
         rf[wa3] <= wd3;
      end
   end
   // write third port on rising edge of clock
   
   // register 0 hardwired to 0
   
   
endmodule // regfile
