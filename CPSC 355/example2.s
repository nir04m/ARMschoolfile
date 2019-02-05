fmt:  .string "The output is:%d\n"
      .balign 4
      .global main

main:  stp         x29,x30,[sp,-16]!
       mov         x29,sp
       
       mov         x20,7
       mov         x21,28
       eor         x22,x20,x21
       and         x20,x20,x22
       adrp        x0,fmt
       add         x0,x0,:lo12:fmt
       mov         x1,x20
       bl          printf
       
       mov         x0,0
 
       ldp         x29,x30,[sp],16
       ret 
