// Mahir Shahriar  - My Name
// 30027575        - Student ID
// Lecture - 01    - Lecture section
// Tutorial - 09   - Tutorial section



// Strings used to print out array generated with random numbers and the sorted array
arrayP: .string "v[%d]: %d\n"                   // string for  printing out the array generated with random numbers
sorted: .string "\nsorted array: \n"       	// string for  printing out the sorted array 


// Defining m4 macros 
define(i, w19)                                  // defining loop counter i to register w19  - x32
define(random, w20)                             // defining random to register w20          - x32 
define(j, w22)                                  // defining loop counter j to register w22  - x32
define(j_min, w24)                              // defining j_min (j-1) to register w24      - x32
define(temp, w25)                               // defining temporary register to w25       - x32


// Instance variables
size = 50                                       // setting size of the array
arraybase = 16                                  // setting the base address of the array
i_offset = 4                                	// setting i_offset 
j_offset = 4                                    // setting j_offset
temp_offset = 4                                 // setting temp index
alloc = -(16 + 212) & -16                   	// allocate
dealloc = -alloc                                // deallocate


// defining fp and lr
fp  .req x29                                    // defining fp to register x29 - x64
lr  .req x30                                    // defining lr to register x30 - x64
	
    .balign 4                                   // Instructions must be word aligned
    .global main                                // Make "main" visible to OS
	
	

// main branch initializes value of i to 0, does allocation and branches to pre_test 	
main:                                           
    stp     x29, x30, [sp, alloc]!              // allocating
    mov     fp, sp                              // update FP to current SP
    add     x28, fp, arraybase                  // calculate the address of arraybase
    mov     i, 0                                // initialize index i to stack
    str     i, [fp, i_offset]                   // writing index i to stack
    b       pre_test                            // branch to pre_test


	
// generates the random array 
generaterandomarray:                                          
    bl      rand                                // bracnh and link rand
    ldr     i, [fp, i_offset]                   // read index i from the stack
    and     random, w0, 0xFF                    // Rand() & 0xFF
    str     random, [x28, i, SXTW 2]            // write random to array 
    adrp    x0, arrayP                          // Set 1st arg (high order bits)
    add     w0, w0, :lo12:arrayP                // Set 1st arg (lower 12 bits)
    mov     w1, i                               // 1st arg
    mov     w2, random                          // 2nd arg
    bl      printf                              // branches and links to printf
    add     i, i, 1                             // i++  
    str     i, [fp, i_offset]                   // writes index i to stack

	
// checks to see if i < 50 . if condition meets bracnhes to generaterandomarray.otherwise sets i to 50 , decrements i by 1 and branches to print_sorted
pre_test:                                          
    cmp     i, size                             // compares value of i with size which is set to 50
    b.lt    generaterandomarray                 // branch to generaterandomarray if   i < size
    mov     i, size                             // sets value of i to 50
    sub     i, i, 1                             // decrements value of i by 1
    str     i, [fp, i_offset]                   // writes index i to stack
    b       print_sorted                        // branches to print_sorted

	
	
// Sorts the arrays
sortarray:                                          
    ldr     w23, [x28, j, SXTW 2]               // reads w23 from array 
    sub     j_min, j, 1                         // j_min = j - 1
    ldr     random, [x28, j_min, SXTW 2]        // reads random from array
    cmp     random, w23                         // compares random and value in register w23
    b.le    update_j                            // branches to update_j if random <= w23
    add     sp, sp, -4 & -16                    // sp = sp + -4 & -16
    mov     temp, random                        // stores register value in random to temporary register
    str     temp, [x29, temp_offset]            // writes temp to stack
    mov     random, w23                         // sets random to the register value in w23
    str     random, [x28, j_min, SXTW 2]        // writes random to array
    mov     w23, temp                           // sets w23 to register value in temp
    str     w23, [x28, j, SXTW 2]               // writes w23 to array 
    add     sp, sp, 16                          // sp = sp + 16
	
	
	
// increases value of j by 1
update_j:                                           
    add     j, j, 1                             // j = j+1



// test for the nested for loop in c	
nested_forcondition:                                          
    cmp     j, i                                // compares value of j and i
    b.le    sortarray                           // branches to sortarray if j <= i
    sub     i, i, 1                             // i--

	
	
// Initializes j to 1 before the sorting process
print_sorted:                                          
    mov     j, 1                                // j = 1
    str     j, [fp, j_offset]                   // writes index j to stack
    cmp     i, 0                                // compares i with immediate value 0 
    b.ge    nested_forcondition                 // if i >= 0 branches to nested_forcondition
    mov     i, 0                                // i = 0
    str     i, [fp, i_offset]                   // writes index i to stack
    adrp    x0, sorted                          // Set 1st arg (high order bits)
    add     w0, w0, :lo12:sorted                // Set 1st arg (lower 12 bits)
    mov     w1, 0                               // 1st arg
    bl      printf                              // branches and links to printf
    b       print_Condition                     // Branch to print_Condition
    
    
    
// loops 50 times and prints the sorted arrays   
print:                                      
    ldr     w26, [x28, i, SXTW 2]               // reads w26 from array     
    adrp    x0, arrayP                          // Set 1st arg (high order bits)
    add     w0, w0, :lo12:arrayP                // Set 1st arg (lower 12 bits)
    mov     w1, i                               // 1st arg
    mov     w2, w26                             // 2nd arg
    bl      printf                              // branches and links to printf
    add     i, i, 1                             // i = i+1


// test condition for  print
print_Condition:                                     
    cmp     i, size                             // compares i and size
    b.lt    print                               // if i < size then branch to print


end:
    mov     w0, 0                               // Return 0 to OS
    ldp     fp, lr, [sp], dealloc               // Deallocate stack memory
    ret                                         // Return to calling code in OS

