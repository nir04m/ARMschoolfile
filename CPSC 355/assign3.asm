size = 50                            // the size of array
size_a = size * 4                     // cal the size of array 
i_size = 4                             // the size of i
j_size = 4                              // the size of j
temp_size = 4                             // the size of temp
array_s = 20                             // offset array
i_s = array_s + size_a                   // offset i
j_s = array_s + size_a                    // offset j
temp_s = j_s + j_size                     // // offset temp
var_size = size_a + i_size + j_size + temp_size       //needed
alloc = -(16 + var_size) & -16                          //allocating the memory
dealloc = -alloc                       //deallocating memory
fp    .req   x29
lr    .req   x30

fmt3:     .string "v[%d]: %d\n"
fmt2:     .string "\nSorted array:\n"
fmt:      .string "v[%d]: %d\n"
          .balign 4
          .global main

main:      stp    fp,lr,[sp,alloc]!
           mov    fp,sp

           mov    w19,0                  //setting i to zero
           str    w19,[fp,i_s]
           
           b      test1

loop1:     bl     rand
           and    w20,w0,0xFF            //rand & 0xff
           add    x28,fp,array_s         // calculating the array
           ldr    w19,[fp,i_s]
           str    w20,[x28,w19,sxtw 2]        // storing the value on x20 to v[i]
           adrp   x0,fmt
           add    x0,x0,:lo12:fmt
           ldr    w1,[fp,i_s]                // printing i         
           ldr    w2,[x28,w19,sxtw 2]         // printing v[i]
           bl     printf
           
           ldr    w19,[fp,i_s]
           add    w19,w19,1
           str    w19,[fp,i_s]

test1:     cmp    w19,size              //i < 50
           b.lt   loop1

           mov    w19,1                    //i = 1
           str    w19,[fp,i_s]             // storing the value of i
           b      test2
           
loop2:     add    sp,sp,-4 & -16
           ldr    w22,[x28,w19,sxtw 2]         // temp = v[i]
           str    w22,[fp,temp_s]             // storing the value of temp
 
           ldr    w19,[fp,i_s]
           mov    w23,w19                 //setting j = i
           str    w23,[fp,j_s]            // storing the value of j
           ldr    w22,[fp,temp_s]         // gettinh the value in temp
           b      test3
     
loop3:     
           ldr    w23,[fp,j_s]               // getting the value of j
           sub    w25,w23,1                  // j-1

           ldr    w25,[x28,w25,sxtw 2]        // loading v[j-1] to w25
           str    w23,[fp,j_s]
           str    w25,[x28,w23,sxtw 2]       //storing v[j-1] to v[j]
           ldr    w23,[fp,j_s]
           sub    w23,w23,1                   // decrementing j by 1
           str    w23,[fp,j_s]
           
           ldr    w23,[fp,j_s]                 // loading the value of j
           

test3:     
           cmp    w23,0                       // j > 0
           b.le   next                        // if j<0 goto next
           ldr    w23,[fp,j_s]               // Read w23 from array
           sub    w25,w23,1                  // sub j-1
           ldr    w25,[x28,w25,sxtw 2]       //loading the value of v[j-1] to w25
           cmp    w22,w25
           b.lt   loop3
                 
next:      ldr    w22,[fp,temp_s]          
           str    w22,[x28,w23,sxtw 2]     // v[j] = temp
           ldr    w19,[fp,i_s]
           add    w19,w19,1            // incrementing i by 1
           str    w19,[fp,i_s]
           add    sp,sp,16
           
test2:     cmp    w19,size                      // for i < 50
           b.lt   loop2

           adrp   x0,fmt2
           add    x0,x0,:lo12:fmt2
           bl     printf                     //printing sorted array
           b      next1

next1:     ldr    w19,[fp,i_s]      
           mov    w19,0                     // setting the value of i = 0
           str    w19,[fp,i_s]

loop4:     add   x28,fp,array_s 
           adrp  x0,fmt3
           add   x0,x0,:lo12:fmt3
           ldr   w1,[fp,i_s]
           add   x21,fp,array_s
           ldr   w2,[x28,w19,sxtw 2]
           bl    printf
           ldr   w19,[fp,i_s]         //printing the sorted array values
           add   w19,w19,1
           str   w19,[fp,i_s]
           

test4:     ldr    w19,[fp,i_s]
           cmp    w19,size
           b.lt   loop4

           mov    w0,0
           ldp    fp,lr,[sp],dealloc
           ret
