module FIFOmem(input [7:0]wdata,input wclken,wclk,wfull,input [22:0]waddr,raddr,output [7:0]rdata);
 reg [7:0]MEM[8388608:0];
   always @(posedge wclk) begin
   if(wclken && !wfull)begin
   MEM[waddr]=wdata;
   end
   end
   
   assign rdata=MEM[raddr];
  
endmodule

