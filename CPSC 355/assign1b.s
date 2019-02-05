fmt:     .string " x = %d\n y = %d\n maximum = %d\n"
         .balign 4
         .global main

main:     stp     x29,x30,[sp,-16]!
          mov     x29,sp
           // defining x value register to x20
           // defining max value register to x24
           // defining y value register to x28
           // defining -5 value register to x22
           // defining -31 value register to x14
           // defining 4 value register to x16
           // defining 31 value register to x18


          mov        x0,0
          mov        x20,-6 // setting the value of x starting from -6
          mov        x24,-123
          b          test

top:      mov        x22,-5 //adding 5 to the register
          mul        x23,x20,x20 // multiply x with x to get x square
          mul        x23,x23,x20 // multiply x sqaure to get x cube
          mul        x23,x23,x22 // multiply x cube with -5

          mov        x14,-31 // adding -31 to the register
          mul        x25,x20,x20 // multiply x with x to get x square
          mul        x25,x25,x14 // multiply x square with -31

          mov        x16,4 // adding 4 to the register

          mov        x18,31  // adding 31 to the register
          madd       x27,x20,x16,x18
                     
          add       x28,x23,x25  // adding the result together to get y
          add       x28,x28,x27

          cmp       x28,x24     // if (y > max)
          b.le      else
 
          mov       x24,x28  // changing the current max to the new max
          adrp      x0,fmt
          add       x0,x0,:lo12:fmt
          mov       x1,x20  // copy the value of x to display
          mov       x2,x28  // copy the value of y to display     
          mov       x3,x24  // copy the max to be display
          bl        printf
     
          mov       x18,0  // reseting the value of x18
          mov       x16,0  // reseting the value of x16
          mov       x14,0  // reseting the value of x14
          add       x20,x20,1 // incrementing the value of x by 1
          b         test

else:                               // else 
          adrp      x0,fmt
          add       x0,x0,:lo12:fmt
          mov       x1,x20
          mov       x2,x28
          mov       x3,x24
          bl        printf

          mov       x18,0
          mov       x16,0
          mov       x14,0
          add       x20,x20,1
          b         test


test:     cmp      x20,6 //while(x <= 6)
          b.lt     top
          
          
           
next:     ldp      x29,x30,[sp],16 //exiting the program
          ret  
