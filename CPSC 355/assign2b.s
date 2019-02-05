fmt3:      .string " 64-bit result = %d\n"
fmt2:      .string " product = %d\n multiplier = %d\n"
fmt:       .string " multiplier = %d/n multiplicand = %d\n"
           .balign 4
           .global main

main:      stp     x29,x30,[sp,-16]!
           mov     x29,sp

           
           
           
           

           mov     w24,522133279
           mov     w25,200
           mov     w23,0

           adrp    x0,fmt
           add     w0,w0,:lo12:fmt
           mov     w1,w25
           mov     w2,w24
           bl      printf

           cmp     w25,0
           b.lt    negative
           mov     x18,1
           b       for

negative:  mov     x18,0
           b       for

for:       mov     x19,0
           b       test

top:       add     x19,x19,1

if:        tst     w25,0x1
           b.eq    cont
           add     w23,w23,w24

cont:      asr     w25,w25,1

if2:       tst     w23,0x1
           b.eq    else
           orr     w25,w25,0x80000000

else:      and     w25,w25,0x7fffffff
    
           asr      w23,w23,1

test:      cmp      x19,32
           b.lt     top

if3:       cmp      w18,0
           b.lt     next
           sub      w23,w23,w24

next:      adrp     x0,fmt2
           add      w0,w0,:lo12:fmt2
           mov      w1,w23
           mov      w2,w25
           bl       printf

           sxtw     x24,w23
           and      x24,x24,0xffffffff

           lsl      x24,x24,32

           sxtw     x23,w25
           and      x23,x23,0xffffffff 
    
           add      x25,x24,x23

           adrp     x0,fmt3
           add      x0,x0,:lo12:fmt3
           mov      x1,x25
           bl       printf
           
           mov      x0,0
                  

           ldp     x29,x30,[sp],16
           ret
