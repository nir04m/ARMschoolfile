//equates for struct point
x_s = 0  //point x offset
y_s = 4  //point y offset
structp_size = 8 //struct point size

//equates for struct dimension
width_s = 0  //dimension width offset
height_s = 4  //dimension height offset
structd_size = 8 //struct dimension size

//equates for struct box
origin_s = 0  //struct point origin offset
size_s = 8     //struct dimension size offset
area_s = 16    //box area offset
box_size = 28   //struct box size

FALSE = 0   
TRUE = 1


fp .req x29
lr .req x30

alloc = -(16 + box_size) & -16 //allocating space in memory
dealloc = -alloc  //deallocting memory

fmt1:  .string "Box %s origin = (%d,%d) width = %d height = %d area = %d\n"
fmt2:  .string "first"
fmt3:  .string "second"
fmt4:  .string "Initial box values:\n"
fmt5:  .string "\nChanged box values:\n"
       .balign 4

//subroutine newBox
newBox:   stp      fp,lr,[sp,alloc]!
          mov      fp,sp
          
          mov      w10,0
          mov      w9,1                      //x9 = 1
          str      w10,[x0,origin_s + x_s]   //b.origin.x = 0
          str      w10,[x0,origin_s + y_s]   //b.origin.y = 0
          str      w9,[x0,size_s + width_s]  //b.size.width = 1 
          str      w9,[x0,size_s + height_s] //b.size.height = 1
          str      w9,[x0,area_s]            //b.size.area = 1*1 =1

          mov      w0,0 
          ldp      fp,lr,[sp],dealloc
          ret
//end of subroutine newBox

//subroutine move
move:     stp      fp,lr,[sp,alloc]!
          mov      fp,sp
          
          mov       x20,x0      //x20 = struct box *b
          mov       w21,w1      //w21 = int deltaX
          mov       w22,w2      //w22 = int deltaY
 
          ldr       w23,[x20,origin_s + x_s]  //w23 = b->origin.x
          add       w23,w23,w21               //adding b->origin.x + deltaX to w23
          str       w23,[x20,origin_s + x_s]  // storing the result in w23 back to memory
          
          ldr       w23,[x20,origin_s + y_s]   //w23 = b-> origin.y
          add       w23,w23,w22                //adding b->origin.y + deltaY to w23
          str       w23,[x20,origin_s + y_s]  //storing the result in w23 back to memory
          mov       x0,0                       //restoring the value to 0
          mov       w1,0                       //restoring the value to 0
          mov       w2,0                       //restoring the value to 0

          ldp      fp,lr,[sp],dealloc
          ret

// end of move subroutine

//expand   subroutine
expand:    stp      fp,lr,[sp,alloc]!
           mov      fp,sp

           mov      x20,x0       //x20 = struct box *b
           mov      w21,w1       //w21 = int factor
 
           ldr      w23,[x20,size_s + width_s]  //w23 = b->size.width
           mul      w23,w23,w21                 // w23 = b->size.width * factor
           str      w23,[x20,size_s + width_s]  // storing w23 to memory

           ldr      w24,[x20,size_s + height_s]  //w24 = b->size.height
           mul      w24,w24,w21                  //w24 = b->size.height * factor
           str      w24,[x20,size_s + height_s]  // storing w24 to memory
           
           mul      w25,w23,w24                  //b->area = b->size.width * b->size.height
           str      w25,[x20,area_s]             //storing b->area to memory
           
           mov      x0,0          //restoring x0 to 0
           mov      w21,0         //restoring w21 to 0
            
           ldp      fp,lr,[sp],dealloc
           ret

//end of expand subroutine

//printBox subroutine
printBox:  stp      fp,lr,[sp,alloc]!
           mov      fp,sp
           
           mov      x21,x1                  //x21 = struct box *b
           mov      x1,x0                   //move x1 to char name
           adrp     x0,fmt1
           add      x0,x0,:lo12:fmt1
           ldr      x2,[x21,origin_s + x_s]  //load b->origin.x
           ldr      x3,[x21,origin_s + y_s]  //load b->origin.y
           ldr      x4,[x21,size_s + width_s] //load b->size.width
           ldr      x5,[x21,size_s + height_s] //load b->size.height
           ldr      x6,[x21,area_s]            //load b->area
           bl       printf
           
           mov      x0,0
           ldp      fp,lr,[sp],dealloc
           ret

//end of printBox subroutine

//equal subroutine
equal:     stp      fp,lr,[sp,alloc]!
           mov      fp,sp
          
           mov      x20,x0  //x20 = struct box *b1
           mov      x21,x1  //x21 = struct box *b2
           mov      w22,FALSE
           
           ldr      w23,[x20,origin_s + x_s] //w23 = b1->origin.x
           ldr      w24,[x21,origin_s + x_s] //w24 = b2->origin.x
           cmp      w23,w24                  //if w23 == w24
           b.ne     return
 
           ldr      w23,[x20,origin_s + y_s]  //w23 = b1->origin.y
           ldr      w24,[x21,origin_s + y_s]  //w24 = b2->origin.y
           cmp      w23,w24                   //if w23 == w24
           b.ne     return

           ldr      w23,[x20,size_s + width_s] //w23 = b1->size.width
           ldr      w24,[x21,size_s + width_s] //w24 = b2->size.width
           cmp      w23,w24                    //if w23 == w24
           b.ne     return

           ldr      w23,[x20,size_s + height_s] 
           ldr      w24,[x21,size_s + height_s]
           cmp      w23,w24
           b.ne     return
          
           mov      w22,TRUE

return:    mov      w0,w22
           ldp      fp,lr,[sp],dealloc
           ret

//end of equal subroutine
           Alloc = -(16 + box_size) & -16
           Dealloc = - Alloc
           box1_s = 16
           box2_s = box1_s + box_size
           .global main

main:      stp      fp,lr,[sp,Alloc]!
           mov      fp,sp

           add      x19,fp,box1_s
           add      x20,fp,box2_s


           mov      x0,x19
           bl       newBox
 
           mov      x0,x20
           bl       newBox
          
           adrp     x0,fmt4
           add      w0,w0,:lo12:fmt4 
           bl       printf

           adrp     x0,fmt2
           add      x0,x0,:lo12:fmt2
           mov      x1,x19
           bl       printBox

           adrp     x0,fmt3
           add      x0,x0,:lo12:fmt3
           mov      x1,x20
           bl       printBox

           mov      x0,x19
           mov      x1,x20
           bl       equal
           mov      x23,x0
           
           cmp      x23,TRUE
           b.ne     print_a
          
           mov      x0,x19
           mov      w1,-5
           mov      w2,7
           bl       move
           
           mov      x0,x20
           mov      w1,3
           bl       expand

print_a:   adrp     x0,fmt5
           add      w0,w0,:lo12:fmt5
           bl       printf
           
           adrp     x0,fmt2
           add      x0,x0,:lo12:fmt2
           mov      x1,x19
           bl       printBox
           
           adrp     x0,fmt3
           add      x0,x0,:lo12:fmt3
           mov      x1,x20
           bl       printBox

           mov      x0,0
           ldp      fp,lr,[sp],Dealloc
           ret
