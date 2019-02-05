fmt:     .string " x = %d\n y = %d\n maximum = %d\n"
         .balign 4
         .global main

main:     stp     x29,x30,[sp,-16]!
          mov     x29,sp
          define(x_r,x20) // defining x value register to x_r
          define(x_m,x24) // defining max value register to x_m
          define(x_y,x28) // defining y value register to x_y
          define(x_f,x22) // defining -5 value register to x_f
          define(x_s,x14) // defining -31 value register to x_s
          define(x_t,x16) // defining 4 value register to x_t
          define(x_g,x18) // defining 31 value register to x_g


          mov        x0,0
          mov        x_r,-6 // setting the value of x starting from -6
          mov        x_m,-123
          b          test

top:      mov        x_f,-5 //adding 5 to the register
          mul        x23,x_r,x_r // multiply x with x to get x square
          mul        x23,x23,x_r // multiply x sqaure to get x cube
          mul        x23,x23,x_f // multiply x cube with -5

          mov        x_s,-31 // adding -31 to the register
          mul        x25,x_r,x_r // multiply x with x to get x square
          mul        x25,x25,x_s // multiply x square with -31

          mov        x_t,4 // adding 4 to the register

          mov        x_g,31  // adding 31 to the register
          madd       x27,x_r,x_t,x_g
                     
          add       x_y,x23,x25  // adding the result together to get y
          add       x_y,x_y,x27

          cmp       x_y,x_m     // if (y > max)
          b.le      else
 
          mov       x_m,x_y  // changing the current max to the new max
          adrp      x0,fmt
          add       x0,x0,:lo12:fmt
          mov       x1,x_r  // copy the value of x to display
          mov       x2,x_y  // copy the value of y to display     
          mov       x3,x_m  // copy the max to be display
          bl        printf
     
          mov       x_g,0  // reseting the value of x_g
          mov       x_t,0  // reseting the value of x_t
          mov       x_s,0  // reseting the value of x_s
          add       x_r,x_r,1 // incrementing the value of x by 1
          b         test

else:                               // else 
          adrp      x0,fmt
          add       x0,x0,:lo12:fmt
          mov       x1,x_r
          mov       x2,x_y
          mov       x3,x_m
          bl        printf

          mov       x_g,0
          mov       x_t,0
          mov       x_s,0
          add       x_r,x_r,1
          b         test


test:     cmp      x_r,6 //while(x <= 6)
          b.lt     top
          
          
           
next:     ldp      x29,x30,[sp],16 //exiting the program
          ret  
