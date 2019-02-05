size = 10
array_size = size * 4
i_size = 4
sum_size = 4
array_s = 16
i_s = array_s + array_size
sum_s = i_s + i_size
var_size = array_size + i_size + sum_size
alloc = -(16 + var_size) & -16
dealloc = -alloc
fp        .req      x29
lr        .req      x30

fmt:      .string " array[%d] = %d(sum = %d)\n array[n-1] = %d\n"
          .balign   4
          .global main

main:     stp       fp,lr,[sp,alloc]!
          mov       fp,sp

          mov       w19,0
          str       w19,[fp,i_s]
          mov       w19,0
          str       w19,[fp,sum_s]
          b         test1

loop1:    bl        rand
          and       w20,w0,0xFF
          add       x21,fp,array_s
          ldr       w19,[fp,i_s]
          str       w20,[x21,w19,sxtw 2]
          ldr       w19,[fp,i_s]
          add       w19,w19,1
          str       w19,[fp,i_s]
test1:    cmp       w19,size
          b.lt      loop1

          mov       w19,0
          str       w19,[fp,i_s]
          b         test2

loop2:    ldr       w19,[fp,i_s]
          sub       w19,w19,1
          str       w19,[fp,i_s]
          add       x21,fp,array_s
          ldr       w25,[x21,w19,sxtw 2]
          add       w19,w19,1
          str       w19,[fp,i_s]
          add       x21,fp,array_s
          ldr       w20,[x21,w19,sxtw 2]
          ldr       w21,[fp,sum_s]
          add       w21,w21,w20
          str       w21,[fp,sum_s]
          adrp      x0,fmt
          add       x0,x0,:lo12:fmt
          ldr       w1,[fp,i_s]
          add       x21,fp,array_s
          ldr       w2,[x21,w19,sxtw 2]
          ldr       w3,[fp,sum_s]
          mov       w4,w25
          bl        printf
          add       w19,w19,1
          str       w19,[fp,i_s]

test2:    cmp       w19,size
          b.lt      loop2
  
          mov       w0,0
          ldp       fp,lr,[sp],dealloc
          ret
