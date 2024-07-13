module FIFOmem(input [7:0]wdata,input wclken,wclk,wfull,input [22:0]waddr,raddr,output [7:0]rdata);
 reg [7:0]MEM[8388608:0];
   always @(posedge wclk) begin
   if(wclken && !wfull)begin
   MEM[waddr]=wdata;
   end
   end
   
   assign rdata=MEM[raddr];
  
endmodule

module FIFO_wblock(input winc,wclk,wrst_n,output  [22:0]waddr,input [23:0]wq2_rptr,output  [22:0]waddr,output reg wfull);//wptr has one extra bit for checking full and empty condition


reg [23:0]wbin;
wire wfull_val;
always @(posedge wclk or negedge wrst_n)begin
if(!wrst_n)begin
wbin<=23'b0;
end
else if (winc & ~wfull)begin
wbin<=wbin+1; 
end
end
assign waddr=wbin[22:0];
assign wptr=wbin; 
assign wfull_val={~wptr[23],wptr[22:0]}^wq2_rptr; // full condition

always @(posedge wclk or negedge wrst_n) begin
if(!wrst_n) wfull<=1'b0;
else wfull<= wfull_val;
end
endmodule
