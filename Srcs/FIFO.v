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
 wire [23:0] wbin_next;
wire wfull_val;
always @(posedge wclk or negedge wrst_n)begin
if(!wrst_n)begin
wbin<=24'b0;
end
else if (winc & ~wfull)begin
wbin<=wbin_next; 
end
end
assign wbin_next=wbin+1;
assign waddr=wbin[22:0];
assign wptr=wbin; 
assign wfull_val=(wbin_next[23]!=wq2_rptr)&&(wbin_nect[22:0]==wq2_rptr[22:0]); // full condition

always @(posedge wclk or negedge wrst_n) begin
if(!wrst_n) wfull<=1'b0;
else wfull<= wfull_val;
end
endmodule

// read block
module read_block(input rinc,rclk,rrst_n,input [23:0] rq2_wptr,output [22:0]raddr,output  [23:0] rptr,output reg rempty);
reg [23:0]rbin;
wire [23:0]rbin_next;
wire rempty_val;
 always @(posedge rclk or negedge rrst_n)begin
 if(!rrst_n) begin
 rbin<=24'b0;
 end
 else if(rinc && ~rempty ) begin
 rbin<=rbin_next;
 end
 
 end
 assign rbin_next=rbin+1;
 assign raddr= rbin[22:0];
 assign rptr=rbin;
 assign rempty_val= (rbin_next[23:0]==rq2_wptr[23:0]); 
 always @(posedge rclk or negedge rrst_n)begin
 if(!rrst_n)begin
 rempty<=1'b1;
 end 
 else begin
 rempty<=rempty_val;
 end
 end
 
module sync_r2w(input wclk,wrst_n,input [23:0]rptr, output reg [23:0]  wq2_rptr); 
reg [23:0] wq1_rptr;
always @(posedge wclk or negedge wrst_n) begin
if(!wrst_n)begin
wq2_rptr<=0;
wq1_rptr<=0;
end
else begin
wq1_rptr<=rptr;
wq2_rptr<=wq1_rptr;
end
end
endmodule
module sync_w2r(input rclk,rrst_n,input [23:0]wptr, output reg [23:0]  rq2_rptr); 
reg [23:0] rq1_rptr;
always @(posedge rclk or negedge rrst_n) begin
if(!rrst_n)begin
rq2_rptr<=0;
rq1_rptr<=0;
end
else begin
rq1_rptr<=wptr;
rq2_rptr<=rq1_rptr;
end
end
endmodule
//top module
 
module asynFIFO(input [7:0] wdata,input wclk,winc,wrst_nrinc,rclk,rrst_n,output [7:0]rdata,output wfull,rempty);
wire [22:0]s_waddr, s_raddr;
wire [23:0]s_wptr,s_rq2_wptr,s_rptr,s_wq2_rptr;
wire s_rempty,s_wfull,s_wclken;

sync_r2w r2w_sync(wclk,wrst_n,s_rptr, s_wq2_rptr); 
sync_w2r w2r_sync(rclk,rrst_n,s_wptr, s_rq2_rptr); 
FIFO_wblock write_block(winc,wclk,wrst_n,s_wq2_rptr,s_waddr,s_wptr,s_wfull);
FIFO_rblock read_block(rinc,rclk,rrst_n,s_rq2_wptr,s_raddr,s_rptr,s_rempty);
FIFOmem memory_block(wdata,s_wclken,wclk,s_wfull,s_waddr,s_raddr,rdata);
assign s_wclken=winc & ~wfull;
assign wfull=s_wfull;
assign rempty=s_rempty;
endmodule

endmodule


