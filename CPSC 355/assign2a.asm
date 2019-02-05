fmt3:        .string " 64-bit result = %d\n"
fmt2:        .string " product = %d\n multiplier = %d\n"
fmt:         .string " Multiplier = %d\n Multiplicand = %d\n"
             .balign 4
             .global main

main:        stp     x29,x30,[sp,-16]!
             mov     x29,sp
         
             define(x_m,w25)      //defining multiplier to be x_m
             define(x_p,w23)      //defining product to be x_p
             define(x_d,w24)      //defing mltiplicand to be x_d
             define(i_r,w19)
         
             mov     x_d,-16843010     //setting the value for the multiplicand 
             mov     x_m,70            //setting the value for the multiplier
             mov     x_p,0             //setting the value for the product
         
             adrp    x0,fmt
             add     w0,w0,:lo12:fmt
             mov     w1,x_m            // printing out the value of the multiplier
             mov     w2,x_d            //printing out the value of the multiplicand
             bl      printf
                   
         
            cmp     x_m,0      // testing if the multiplier is less than zero
            b.lt    negative
            mov     x18,1      // setting negative to one if true
            b       for
        
negative:   mov    w18,0      //setting negative to zero if false
            b       for
          
        
for:        mov     i_r,0      // start of the for statement
            b       test
         
top:        add     i_r,i_r,1     //incrementing i by 1
         
if:        tst     x_m,0x1
           b.eq    cont 
           add     x_p,x_p,x_d  //adding multiplicand to product
         
cont:      asr     x_m,x_m,1  //arithmetic shift right for multiplier with shift count 1

if2:       tst     x_p,0x1
           b.eq    else
           orr     x_m,x_m,0x80000000   //changing the value of the multiplier to the result when the multiplier is or with the value 0x80000000

else:      and     x_m,x_m,0x7fffffff   //changing the value of the multiplier to the result when the multiplier is and with the value 0x7fffffff
  
           asr     x_p,x_p,1    //arithmetic shift right for product with shift count 1

test:      cmp     i_r,32      // checking if i is less than
           b.lt    top

if3:       cmp     w18,0
           b.lt    next
           sub     x_p,x_p,x_d    // subtracting multiplicand from the product
 
next:       
           adrp    x0,fmt2       
           add     w0,w0,:lo12:fmt2
           mov     w1,x_p
           mov     w2,x_m
           bl      printf       // print the value of product and multiplier
         
           sxtw    x24,x_p
           and     x24,x24,0xffffffff  // calulating the result(temp1) of product and 0xffffffff
         
           lsl     x24,x24,32      // shifting temp1 left by shift count 32
          
           sxtw    x23,x_m
           and     x23,x23,0xffffffff  //calculating the result(temp2) of multiplier and 0xffffffff
         
           add     x25,x24,x23       //adding temp1 to temp2 to result
         
           adrp    x0,fmt3        
           add     x0,x0,:lo12:fmt3
           mov     x1,x25
           bl      printf      //printing the value of the result
         
           mov     x0,0

           ldp     x29,x30,[sp],16
           ret
