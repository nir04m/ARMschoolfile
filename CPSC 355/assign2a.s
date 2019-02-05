fmt3:        .string " 64-bit result = %d\n"
fmt2:        .string " product = %d\n multiplier = %d\n"
fmt:         .string " Multiplier = %d\n Multiplicand = %d\n"
             .balign 4
             .global main

main:        stp     x29,x30,[sp,-16]!
             mov     x29,sp
         
                   //defining multiplier to be w25
                   //defining product to be w23
                   //defing mltiplicand to be w24
             
         
             mov     w24,-16843010     //setting the value for the multiplicand 
             mov     w25,70            //setting the value for the multiplier
             mov     w23,0             //setting the value for the product
         
             adrp    x0,fmt
             add     w0,w0,:lo12:fmt
             mov     w1,w25            // printing out the value of the multiplier
             mov     w2,w24            //printing out the value of the multiplicand
             bl      printf
                   
         
            cmp     w25,0      // testing if the multiplier is less than zero
            b.lt    negative
            mov     x18,1      // setting negative to zero if false
            b       for
        
negative:   mov    w18,0      //setting negative to one if true
            b       for
          
        
for:        mov     w19,0      // start of the for statement
            b       test
         
top:        add     w19,w19,1     //incrementing i by 1
         
if:        tst     w25,0x1
          // b.eq    cont 
           add     w23,w23,w24  //adding multiplicand to product
         
cont:      asr     w25,w25,1  //arithmetic shift right for multiplier with shift count 1

if2:       tst     w23,0x1
           b.eq    else
           orr     w25,w25,0x80000000   //changing the value of the multiplier to the result when the multiplier is or with the value 0x80000000

else:      and     w25,w25,0x7fffffff   //changing the value of the multiplier to the result when the multiplier is and with the value 0x7fffffff
  
           asr     w23,w23,1    //arithmetic shift right for product with shift count 1

test:      cmp     w19,32      // checking if i is less than
           b.lt    top

if3:       cmp     w18,0
           b.lt    next
           sub     w23,w23,w24    // subtracting multiplicand from the product
 
next:       
           adrp    x0,fmt2       
           add     w0,w0,:lo12:fmt2
           mov     w1,w23
           mov     w2,w25
           bl      printf       // print the value of product and multiplier
         
           sxtw    x24,w23
           and     x24,x24,0xffffffff  // calulating the result(temp1) of product and 0xffffffff
         
           lsl     x24,x24,32      // shifting temp1 left by shift count 32
          
           sxtw    x23,w25
           and     x23,x23,0xffffffff  //calculating the result(temp2) of multiplier and 0xffffffff
         
           add     x25,x24,x23       //adding temp1 to temp2 to result
         
           adrp    x0,fmt3        
           add     x0,x0,:lo12:fmt3
           mov     x1,x25
           bl      printf      //printing the value of the result
         
           mov     x0,0

           ldp     x29,x30,[sp],16
           ret
