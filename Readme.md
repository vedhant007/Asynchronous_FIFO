# Asynchronous_FIFO
In this repository, I will document my journey in creating an asynchronous FIFO with 7 MB FIFO memory.
This is the block diagram of asynchronous FIFO.
![image](https://github.com/vedhant007/Asynchronous_FIFO/assets/66167443/3065754f-1c71-4cc8-8d9c-10595704741d)

I will make this FIFO in phases. 
1) memory block
2) write pointer and full write address generating block
3) Read pointer and Empty read address block
4) synchronizers
5) Integration of blocks
6) writing test bench code
7) debugging

PHASE 1:Memory block
For memory block, i have created a dual port ram with word size 8bit and depth 8388608 bits operating on only write clock.

PHASE 2: Write block
This block will have inputs : write clk, winc, wrst_n, readptr:
now, we have to generate two signals wptr and waddr;
and we have to also generate wfull conditions

WHY WE ARE GENERATING  WFULL CONDITION IN WRITE BLOCK AND R FULL CONDITION IN READ BLOCK?
Since we have to detect at earliest the the fifo is full or empty , so for full condition when wprt is equal to rpt and msp is not equal then it is full, and when fifo is empty if rpts is equal to wptr and msb are equal a rclk.
//wfull<=1'b1; we cannot put wfull inside this as for wfull read and write pointer should be
// at equal location, if the are not it doesn't matter if the pointer has wrapped or not write 
//operation will keep on happening so we can simply inc one bit and increment it and when msb is 1 it means it has wrapped one time

// wfull is cannot be attached to wptr, as wfull is different condition we will take 
//wptr as addr size+1 and inc it, when it has wrapped it 01111 lets say is last memory on ram,
// then next will be 10000 right and that 1 will indicate wrapping and if last bits are equal 
//to read last bits then its full execpt msb and wfull will happen when rptr and wptr is equal except msb
//as rptr=1 and wptr =0 will not happend as wspeed is > than rpspeed always thats why fifo is reqd
//what about if it is wraped
// 1 bit extra can help us in reducing memory buffer and help us use fifo in sort of continuous manner and take 
// benfit of memory double size.
// when wfull==1 we will not send data from sender module and we will wait till reading is happening and when reading is done we will set wfull=0
//but we have selected fifo depth accordingly so why should we need an extra bit??
corrected full ocndition xor operation is not correct used && can check
taking wbin_next signal as it is considered good practice in sequential circuit.

write block done now i will write read block, read block done was similary to write block.
