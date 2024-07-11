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
