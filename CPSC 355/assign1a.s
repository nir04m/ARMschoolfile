fmt:     .string " x = %d\n y = %d\n maximum = %d\n"
         .balign 4 
         .global main


main:    stp     x29,x30,[sp, -16]!
         mov     x29,sp
         
         mov     x0,0
         mov     w1,0
         mov     w2,0
         mov     x20,-6 // value of x starting from -6
         mov     x24,-123  //maximum register is set to zero


test:    cmp     x20,6
         b.ge    next
         mov     x22,-5    // adding -5 to the register
         mul     x23,x20,x20  // multiplying x wuth x to get x square
         mul     x23,x23,x20 // multiplying x suare with x to get x cube
         mul     x23,x23,x22  //multiplying x cube with -5
     
         mov     x14,-31 //adding -31 to register 
         mul     x25,x20,x20 //multiplying x with x
         mul     x25,x25,x14 // multiplying x square with -31
     
         mov     x16,4   //adding 4 from 4x to register x26
         mul     x27,x20,x16 //multiplying 4 with x
     
         mov     x18,31 //adding the last number into register x23


         add     x28,x23,x25  // adds -5x cubic to -31x square 
         add     x28,x28,x27  // adds the result of the above to 4x
         add     x28,x28,x18  // adds the result to 31
      
         cmp     x28,x24  //if ( y< max )
         b.le    else // if the condition is not true it jumps to else statement
         
         mov     x24,x28 //changing the maximum to the new maximum
         adrp    x0,fmt
         add     x0,x0,:lo12:fmt
         mov     x1,x20  //copy the value of x to be display
         mov     x2,x28  //copy the value of y to be display
         mov     x3,x24  //copy the value of maximum to be disply
         bl      printf
         
         mov     x18,0   // reseting the value in x18 to zero
         mov     x16,0   // reseting the value  in x16 to zero
         mov     x14,0   // reseting the value in x14 to zero
         add     x20,x20,1 //incrementing the value of x by 1
         b       test     // returning to the beginning of the loop

else:    
         adrp    x0,fmt
         add     x0,x0,:lo12:fmt
         mov     x1,x20 //copy the value of x to be display 
         mov     x2,x28 //copy the value of y to be display
         mov     x3,x24 //copy the value of maximum to be display
         bl      printf 
                           
         mov     x18,0 // reseting the value in x18 to zero
         mov     x16,0 // reseting the value in x16 to zero
         mov     x14,0 // reseting the value in x14 to zero
         add     x20,x20,1 //incrementing the value of x by 1
         b       test // returning to the beginning of the loop


next:    ldp     x29,x30,[sp],16  //exiting the program
         ret
