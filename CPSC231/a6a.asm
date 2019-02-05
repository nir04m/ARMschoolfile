              .data
n_m:   .double   1.0e-10
              .text 
buffer_size = 8                       //size of the buffer
buffer_s = 16                         //buffer offset
alloc = -(16+8) & -16             //memory to allocate 
dealloc = -alloc                  //memory to deallocate 

define(x_m,d16)
define(y_m,d17)
define(dy_dx,d18)
define(dy_m,d19)

define(argv_r,w20)
define(argc_r,x21)
define(fd_r,w23)
define(buf_base,x22)

open_err:    .string "Can't open file for reading. Aborting\n"
table_s:     .string "Initail Value       | Cuberoot\n"
result_s:    .string "Value: %.10f   Cuberoot: %.10f\n"
arg_err:     .string "Error: incorrect number of arguments. Usage: ./a6 <filename.bin>\n"


             .balign 4
             .global cuberoot
cuberoot:  stp    x29,x30,[sp,-16]!
           mov    x29,sp
           
           fmov   x_m,d0
           fmov   d24,3.0 
           fdiv   x_m,x_m,d24                   //x= input/3.0
           fmov   dy_m,3.0
           fsub   dy_m,dy_m,dy_m                //setting dy to 0.0
           adrp   x1,n_m
           add    x1,x1,:lo12:n_m             //address for n_m = 1.0e-10
           ldr    d22,[x19]                     //put the value in n_m into d22
           fmul   d21,d0,d22                    //d21 = input * n_m
           b      test
          //loop begins
cal:       fmul   y_m,x_m,x_m      
           fmul   y_m,y_m,x_m             //y = x*x*x
           fsub   dy_m,y_m,d0              //dy = y-input
           fmul   dy_dx,x_m,d24            //dy/dx = 3.0*x*
           fmul   dy_dx,dy_dx,x_m          //dy/dx = dy/dx *x
           fdiv   d20,dy_m,dy_dx           //d20 = dy/(dy/dx)
           fsub   x_m,x_m,d20              // x= x- d20
          //loop ends return x
test:      fabs   d23,dy_m                     //absolute value of dy
           fcmp   d23,d21                     //check if abs of dy < input*1.0e-10
           b.lt   cal
           
after:     adrp    x0,result_s
           add     x0,x0,:lo12:result_s             //printing the result
           fmov    d1,x_m 
           bl      printf
done:            
           ldp     x29,x30,[sp],16
           ret

                .balign 4
                .global main
main:      stp    x29,x30,[sp,alloc]!
           mov    x29,sp


           mov     argv_r,	w0              //number of arguments entered in terminal
           mov     argc_r,	x1              //address of the file name

	       cmp     argv_r, 2              //check if the number of arguments are two
	       b.eq	   openf
           adrp    x0,arg_err               
           add     x0,x0,:lo12:arg_err       
           bl      printf                   //print error message if the number of is not two
           b       exit

openf:     mov     w0,-100                   //read input from file
           ldr     x1,[argc_r,8]             //filename is placed in x1
           mov     w2,0
           mov     w3,0
           mov     x8,56                      //openat I/O request
           svc     0                           //system call function
           mov     fd_r,w0                    //move result into the file descriptor
           cmp     fd_r,0                     //check if file descriptor is greater than 0 i.e. open successfully
           b.ge    next1
        
           adrp    x0,open_err              
           add     x0,x0,:lo12:open_err          //print error message if the file does not open
           bl      printf
           b       exit

next1:     adrp    x0,table_s
           add     x0,x0,:lo12:table_s
           bl      printf
           add     buf_base,x29,buffer_s       // get buffer base address
           

readf:     mov     w0,fd_r                        //move file descriptor into w0
           mov     x1,buf_base                    //move buffer base address to x1
           mov     w2,buffer_size                 //move buffer size to w2 
           mov     x8,63                          //read I/O request
           svc     0                              //system call function
           mov     w25,w0                          //move the value in w0 to w25
        
           cmp     w25,buffer_size                           //check if 8 bytes were read
           b.ne    exit                          //if not go to exit
           
           ldr     d0,[buf_base]                   //load the value read to d0                              
           bl      cuberoot                        //call cuberoot function
                       
           b       readf
           b       exit
        

exit:      mov     w0,fd_r                       //move file descriptor into w0      
           mov     x8,57                          //close I/O request
           svc     0                             //system call function

           mov     x0,0
           ldp     x29,x30,[sp],dealloc            //deallocating and leaving code
           ret
