QUEUESIZE = 8
MODMASK = 0x7
FALSE = 0
TRUE = 1

                .data
tail:           .word   -1

                .data
head:           .word   -1

                .global tail
                .global head

                .bss
                .global queue
queue:          .skip   QUEUESIZE*4

                .text
enqueue_print:  .string "\nQueue overflow! Cannot enqueue into Full queue.\n"
dequeue_print:  .string "\nQueue underflow! Cannot dequeuefrom an empty queue.\n"
display_print1: .string "\nEmpty queue\n"
display_print2: .string "\nCurrrent queue contents:\n"
display_print3: .string " %d"
display_print4: .string "<-- head of queue"
display_print5: .string "<-- tail of queue"
display_print6: .string "\n"

                .global enqueue
                .balign 4
enqueue:    stp      x29,x30,[sp,-16]!
            mov      x29,sp
         
            mov      w10,w0           //moving int value from w0 to w10
            bl       queueFull        //calling queueFull
            cmp      w0,TRUE          //checking if queueFull return true
            b.ne     en_if2
            adrp     x0,enqueue_print      //if queueFull is true print
            add      x0,x0,:lo12:enqueue_print
            bl       printf
            b        en_done               //return or leave enqueue

en_if2:     bl       queueEmpty            //calliing queueEmpty
            cmp      w0,TRUE               //checking if queueEmpty is true
            b.ne     en_else
            adrp     x19,head               
            add      x19,x19,:lo12:head    //calcuating the address of head 
            ldr      w11,[x19]             //putting the value of head in w11
            mov      w11,0                 //reseting the value of head to zero
            str      w11,[x19]             //storing the new value of head
     
            adrp     x20,tail              
            add      x20,x20,:lo12:tail      //calculating the address of tail
            ldr      w12,[x20]               //putting the value of tail in w12
            mov      w12,0                   //reseting the value of tail to zero
            str      w12,[x20]               //storing the new value of tail
            b        en_after                //leave the if else statment

en_else:    
            ldr      w12,[x20]               //load/read tail value into w12
            add      w12,w12,1               //add 1 to tail
            and      w12,w12,MODMASK         //put the and result of tail and modmask in tail
            str      w12,[x20]               //store the new value of tail

en_after:   adrp     x21,queue                
            add      x21,x21,:lo12:queue       //calcuating the address of queue array
            str      w10,[x21,w12,sxtw 2]      //store value into the array 
          
en_done:    ldp      x29,x30,[sp],16
            ret

            .global dequeue
            .balign 4
dequeue:    value_size = 4                      
            value_s = 16
            alloc = -(16 + value_s) & -16        //allocating memory for local variable value
            dealloc = -alloc
            define(value_r,w10)
            define(head_r,w11)
            define(tail_r,w12)

            stp      x29,x30,[sp,alloc]!
            mov      x29,sp
           
            bl       queueEmpty                    //calling queueEmpty
            cmp      x0,TRUE                       //checking if queueEmpty returned true
            b.ne     if_deq2
            adrp     x0,dequeue_print
            add      x0,x0,:lo12:dequeue_print  //printing
            bl       printf
            mov      x0,-1                        //return -1
            b        de_done                      //leave or return from dequeue

if_deq2:    adrp     x19,head
            add      x19,x19,:lo12:head          //calcuating the address of head
            ldr      head_r,[x19]                //putting the value of head in head_r
        
            adrp     x20,tail
            add      x20,x20,:lo12:tail          //calcuating the address of tail
            ldr      tail_r,[x20]                //putting the value of tail in tail_r

            adrp     x21,queue
            add      x21,x21,:lo12:queue           //calcuating the address of queue
            ldr      value_r,[x21,head_r,sxtw 2]    //putting the value in queue[head_r] to value_r
            str      value_r,[x29,value_s]          //storing the value_r to stack
            cmp      head_r,tail_r                  //checking if head_r is equal to tail_r
            b.ne     else_deq2  
            mov      head_r,-1                       // putting -1 to head_r
            str      head_r,[x19]                    //storing head_r in head
            mov      tail_r,-1                       //putting -1 to tail_r
            str      tail_r,[x20]                    //storing tail_r in tail
            b        de_after 
        
else_deq2:  ldr      head_r,[x19]                    //load/read the of head to head_r
            add      head_r,head_r,1                 //add 1 to head_r
            and      head_r,head_r,MODMASK          //put the and result of head and modmask in head_r 
            str      head_r,[x19]                   //store the new value of head_r into head
           
de_after:   ldr      w0,[x29,value_s]               //return value

de_done:    ldp      x29,x30,[sp],dealloc
            ret

            .global queueFull
            .balign 4
queueFull:  stp      x29,x30,[sp,-16]!
            mov      x29,sp
           
            adrp     x19,head
            add      x19,x19,:lo12:head          //calcuating the address of head
            ldr      w11,[x19]                 //putting the value of head in w11
        

            adrp     x20,tail               
            add      x20,x20,:lo12:tail           //calcuating the address of tail
            ldr      w12,[x20]                    //putting the value of tail in w12

            add      w12,w12,1                    //add 1 the value of tail 
            and      w12,w12,MODMASK              //get the result of tail and modmask and store in tail
            cmp      w12,w11                      //check if tail is equal to head
            b.ne     else_full
            mov      w0,TRUE                      //return true
            b        full_done
 
else_full:  mov      w0,FALSE                      //else return false

full_done:  ldp      x29,x30,[sp],16
            ret

            .global queueEmpty
            .balign 4
queueEmpty: stp      x29,x30,[sp,-16]!
            mov      x29,sp
           
            adrp     x19,head
            add      x19,x19,:lo12:head             //calcuating the address of head
            ldr      w11,[x19]                      //putting the value of head in w11

            adrp     x20,tail
            add      x20,x20,:lo12:tail              //calcuating the address of tail
            ldr      w12,[x20]                       //putting the value of tail in w12

            cmp      w11,-1                          //check if head is equal to -1
            b.ne     else_emp
            mov      w0,TRUE                         //return true
            b        emp_done

else_emp:   mov      w0,FALSE                         //else return false

emp_done:   ldp      x29,x30,[sp],16
            ret

            .global display
            .balign 4
display:    i_size = 4
            j_size = 4
            count_size = 4
            i_s = 16
            j_s = 20
            count_s = 24
            alloc = -(16 + i_s + j_s + count_s) & -16
            dealloc = -alloc
            define(i_r,w14)
            define(j_r,w15)
            define(count_r,w10)
            
            stp      x29,x30,[sp,alloc]!
            mov      x29,sp
            adrp     x19,head                     //calcuating the address of head
            add      x19,x19,:lo12:head           //putting the value of head in w11
            ldr      w11,[x19]

            adrp     x20,tail
            add      x20,x20,:lo12:tail         //calcuating the address of tail
            ldr      w12,[x20]                  //putting the value of tail in w12
            
            adrp     x21,queue
            add      x21,x21,:lo12:queue        //calcuating the address of queue array

            bl       queueEmpty                 //calling queueEmpty
            b        test2

if:         add      w11,w11,1                       //add 1 to head
            sub      count_r,w12,w11                 //subtract tail from head and store in count
            str      count_r,[x29,count_s]           //store count into stack
            cmp      count_r,1                       //check if count is less than or equal to 1
            b.gt     if_disp1
            ldr      count_r,[x29,count_s]          //load count from stack
            add      count_r,count_r,QUEUESIZE      //add count with queuesize
            str      count_r,[x29,count_s]          //store the new value of count in stack

if_disp1:   adrp     x0,display_print2             //print
            add      x0,x0,:lo12:display_print2
            bl       printf
            mov      x0,0

print_qnum: mov      i_r,w11                      //i = head
            str      i_r,[x29,i_s]               //store i in stack
            mov      j_r,0                        //j = 0
            str      j_r,[x29,j_s]               //store j in stack
            b        test

disp_for:   adrp     x0,display_print3
            add      x0,x0,:lo12:display_print3
            ldr      w1,[x21,w14,sxtw 2]           //print queue[i]
            bl       printf
            mov      x0,0
            ldr      i_r,[x29,i_s]              //load i from stack
             cmp      i_r,w11                   //check if i is equal to head
            b.ne     if_disp2
            adrp     x0,display_print4          //print
            add      x0,x0,:lo12:display_print4
            bl       printf
            
if_disp2:   cmp      i_r,w12                      //check if i is equal to tail
            b.ne     disp_after
            adrp     x0,display_print5            //print
            add      x0,x0,:lo12:display_print5
            bl       printf

disp_after: adrp     x0,display_print6            //print
            add      x0,x0,:lo12:display_print6
            bl       printf
 
            ldr      i_r,[x29,i_s]               //load i from stack
            add      i_r,i_r,1             //add 1 to i
            mov      w9,MODMASK            
            and      i_r,i_r,w9            //result = i and modmask
            str      i_r,[x29,i_s]           //store i to stack
            
            ldr      j_r,[x29,j_s]          //load j from stack
            add      j_r,j_r,1              //add 1 to j
            str      j_r,[x29,j_s]           //store j to stack

test:       ldr      j_r,[x29,j_s]           //load j from stack
            cmp      w15,w10                  //check if j is less than count
            b.lt     disp_for
            b        done_disp

test2:      cmp      w0,TRUE                   //checking if queueEmpty is true
            b.ne     if
            adrp     x0,display_print1                //print 
            add      x0,x0,:lo12:display_print1
            bl       printf
                   
done_disp:  ldp      x29,x30,[sp],dealloc                 //return or leave display
            ret
