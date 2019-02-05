fmt3:      .string " 64-bit result = %d\n"
fmt2:      .string " product = %d\n multiplier = %d\n"
fmt:       .string " multiplier = %d/n multiplicand = %d\n"
           .balign 4
           .global main

main:      stp     x29,x30,[sp,-16]!
           mov     x29,sp

           define(x_m,w25)
           define(x_p,w23)
           define(x_d,w24)
           define(i_r,x19)

           mov     x_d,522133279
           mov     x_m,200
           mov     x_p,0

           adrp    x0,fmt
           add     w0,w0,:lo12:fmt
           mov     w1,x_m
           mov     w2,x_d
           bl      printf

           cmp     x_m,0
           b.lt    negative
           mov     x18,1
           b       for

negative:  mov     x18,0
           b       for

for:       mov     i_r,0
           b       test

top:       add     i_r,i_r,1

if:        tst     x_m,0x1
           b.eq    cont
           add     x_p,x_p,x_d

cont:      asr     x_m,x_m,1

if2:       tst     x_p,0x1
           b.eq    else
           orr     x_m,x_m,0x80000000

else:      and     x_m,x_m,0x7fffffff
    
           asr      x_p,x_p,1

test:      cmp      i_r,32
           b.lt     top

if3:       cmp      w18,0
           b.lt     next
           sub      x_p,x_p,x_d

next:      adrp     x0,fmt2
           add      w0,w0,:lo12:fmt2
           mov      w1,x_p
           mov      w2,x_m
           bl       printf

           sxtw     x24,x_p
           and      x24,x24,0xffffffff

           lsl      x24,x24,32

           sxtw     x23,x_m
           and      x23,x23,0xffffffff 
    
           add      x25,x24,x23

           adrp     x0,fmt3
           add      x0,x0,:lo12:fmt3
           mov      x1,x25
           bl       printf
           
           mov      x0,0
                  

           ldp     x29,x30,[sp],16
           ret
