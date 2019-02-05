// Mahir Shahriar  - My Name
// 30027575        - Student ID
// Lecture - 01    - Lecture section
// Tutorial - 09   - Tutorial section



// Strings used to print out array generated with random numbers and the sorted array
arrayP: .string "v[%d]: %d\n"                   // string for  printing out the array generated with random numbers
sorted: .string "\nsorted array: \n"       	// string for  printing out the sorted array 


// Defining m4 macros 
                                  // defining loop counter w19 to register w19  - x32
                             // defining w20 to register w20          - x32 
                                  // defining loop counter w22 to register w22  - x32
                              // defining w24 (w22-1) to register w24      - x32
                               // defining temporary register to w25       - x32


// Instance variables
size = 50                                       // setting size of the array
arraybase = 16                                  // setting the base address of the array
i_offset = 4                                	// setting i_offset 
j_offset = 4                                    // setting j_offset
temp_offset = 4                                 // setting w25 index
alloc = -(16 + 212) & -16                   	// allocate
dealloc = -alloc                                // deallocate


// defining fp and lr
fp  .req x29                                    // defining fp to register x29 - x64
lr  .req x30                                    // defining lr to register x30 - x64
	
    .balign 4                                   // Instructions must be word aligned
    .global main                                // Make "main" visible to OS
	
	

// main branch initializes value of w19 to 0, does allocation and branches to pre_test 	
main:                                           
    stp     x29, x30, [sp, alloc]!              // allocating
    mov     fp, sp                              // update FP to current SP
    add     x28, fp, arraybase                  // calculate the address of arraybase
    mov     w19, 0                                // initialize index w19 to stack
    str     w19, [fp, i_offset]                   // writing index w19 to stack
    b       pre_test                            // branch to pre_test


	
// generates the w20 array 
generaterandomarray:                                          
    bl      rand                                // bracnh and link rand
    ldr     w19, [fp, i_offset]                   // read index w19 from the stack
    and     w20, w0, 0xFF                    // Rand() & 0xFF
    str     w20, [x28, w19, SXTW 2]            // write w20 to array 
    adrp    x0, arrayP                          // Set 1st arg (high order bits)
    add     w0, w0, :lo12:arrayP                // Set 1st arg (lower 12 bits)
    mov     w1, w19                               // 1st arg
    mov     w2, w20                          // 2nd arg
    bl      printf                              // branches and links to printf
    add     w19, w19, 1                             // w19++  
    str     w19, [fp, i_offset]                   // writes index w19 to stack

	
// checks to see if w19 < 50 . if condition meets bracnhes to generaterandomarray.otherwise sets w19 to 50 , decrements w19 by 1 and branches to print_sorted
pre_test:                                          
    cmp     w19, size                             // compares value of w19 with size which is set to 50
    b.lt    generaterandomarray                 // branch to generaterandomarray if   w19 < size
    mov     w19, size                             // sets value of w19 to 50
    sub     w19, w19, 1                             // decrements value of w19 by 1
    str     w19, [fp, i_offset]                   // writes index w19 to stack
    b       print_sorted                        // branches to print_sorted

	
	
// Sorts the arrays
sortarray:                                          
    ldr     w23, [x28, w22, SXTW 2]               // reads w23 from array 
    sub     w24, w22, 1                         // w24 = w22 - 1
    ldr     w20, [x28, w24, SXTW 2]        // reads w20 from array
    cmp     w20, w23                         // compares w20 and value in register w23
    b.le    update_j                            // branches to update_j if w20 <= w23
    add     sp, sp, -4 & -16                    // sp = sp + -4 & -16
    mov     w25, w20                        // stores register value in w20 to temporary register
    str     w25, [x29, temp_offset]            // writes w25 to stack
    mov     w20, w23                         // sets w20 to the register value in w23
    str     w20, [x28, w24, SXTW 2]        // writes w20 to array
    mov     w23, w25                           // sets w23 to register value in w25
    str     w23, [x28, w22, SXTW 2]               // writes w23 to array 
    add     sp, sp, 16                          // sp = sp + 16
	
	
	
// increases value of w22 by 1
update_j:                                           
    add     w22, w22, 1                             // w22 = w22+1



// test for the nested for loop in c	
nested_forcondition:                                          
    cmp     w22, w19                                // compares value of w22 and w19
    b.le    sortarray                           // branches to sortarray if w22 <= w19
    sub     w19, w19, 1                             // w19--

	
	
// Initializes w22 to 1 before the sorting process
print_sorted:                                          
    mov     w22, 1                                // w22 = 1
    str     w22, [fp, j_offset]                   // writes index w22 to stack
    cmp     w19, 0                                // compares w19 with immediate value 0 
    b.ge    nested_forcondition                 // if w19 >= 0 branches to nested_forcondition
    mov     w19, 0                                // w19 = 0
    str     w19, [fp, i_offset]                   // writes index w19 to stack
    adrp    x0, sorted                          // Set 1st arg (high order bits)
    add     w0, w0, :lo12:sorted                // Set 1st arg (lower 12 bits)
    mov     w1, 0                               // 1st arg
    bl      printf                              // branches and links to printf
    b       print_Condition                     // Branch to print_Condition
    
    
    
// loops 50 times and prints the sorted arrays   
print:                                      
    ldr     w26, [x28, w19, SXTW 2]               // reads w26 from array     
    adrp    x0, arrayP                          // Set 1st arg (high order bits)
    add     w0, w0, :lo12:arrayP                // Set 1st arg (lower 12 bits)
    mov     w1, w19                               // 1st arg
    mov     w2, w26                             // 2nd arg
    bl      printf                              // branches and links to printf
    add     w19, w19, 1                             // w19 = w19+1


// test condition for  print
print_Condition:                                     
    cmp     w19, size                             // compares w19 and size
    b.lt    print                               // if w19 < size then branch to print


end:
    mov     w0, 0                               // Return 0 to OS
    ldp     fp, lr, [sp], dealloc               // Deallocate stack memory
    ret                                         // Return to calling code in OS

