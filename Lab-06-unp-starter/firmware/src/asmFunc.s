/*** asmFunc.s   ***/
/* Tell the assembler to allow both 16b and 32b extended Thumb instructions */
.syntax unified

#include <xc.h>

/* Tell the assembler that what follows is in data memory    */
.data
.align
 
/* define and initialize global variables that C can access */
/* create a string */
.global nameStr
.type nameStr,%gnu_unique_object
    
/*** STUDENTS: Change the next line to your name!  **/
nameStr: .asciz "Joshua Lopez"  
 
.align    /* ensure following vars are allocated on word-aligned addresses */

/* initialize a global variable that C can access to print the nameStr */
.global nameStrPtr
.type nameStrPtr,%gnu_unique_object
nameStrPtr: .word nameStr   /* Assign the mem loc of nameStr to nameStrPtr */

.global a_value,b_value
.type a_value,%gnu_unique_object
.type b_value,%gnu_unique_object

/* NOTE! These are only initialized ONCE, right before the program runs.
 * If you want these to be 0 every time asmFunc gets called, you must set
 * them to 0 at the start of your code!
 */
a_value:          .word     0  
b_value:           .word     0  

 /* Tell the assembler that what follows is in instruction memory    */
.text
.align

    
/********************************************************************
function name: asmFunc
function description:
     output = asmFunc ()
     
where:
     output: 
     
     function description: The C call ..........
     
     notes:
        None
          
********************************************************************/    
.global asmFunc
.type asmFunc,%function
asmFunc:   

    /* save the caller's registers, as required by the ARM calling convention */
    push {r4-r11,LR}
 
.if 0
    /* profs test code. */
    mov r0,r0
.endif
    
    /** note to profs: asmFunc.s solution is in Canvas at:
     *    Canvas Files->
     *        Lab Files and Coding Examples->
     *            Lab 5 Division
     * Use it to test the C test code */
    
    /*** STUDENTS: Place your code BELOW this line!!! **************/
    
/*Assigns registers 3 and 4 to a_value and b_value memory location respectively*/
ldr r3, =a_value /*Start memory address. In this case a_value memory address*/
ldr r4, =b_value /*End memory address. Use b_value mem address to end loop later*/
    
loop:
    lsr r1, r0, 31 /*Isolates the MSB of the 16 bit value in B16-B31*/
    cmp r1, 1	   /*Checks to see if the MSB is 1(negative)*/
    beq negative   /*If MSB is 1, then it branches to negative*/

    /*If execution is in here, then B16-B31 is a positive value*/
    lsr r1, r0, 16 /*Shifts the 16 bits we care about (B16-B31) into B0-B15 while also shifting out its previous bits,
		    *and storing the new value into r1. B16-B31 will have 0 bits.*/
    b assignment_handler /*Once we have our manipulated value, we branch to handle its assignment*/

negative:
    /*If in here, then B16-B31 in r0 is a negative value*/
    asr r1, r0, 16 /*In r0, shifts the bits inside B0-B15 out so only the bits in B16-B31 remain in locations B0-B15, 
		    *but it adds 1 to B16-B31 making it a negative value through extended sign and storing it in r1*/

assignment_handler:
    str r1, [r3]   /*Stores the manipulated, unpacked 16 bit value in r1 into its respective memory location*/
    cmp r3, r4	   /*Check if r3 has reached b_value memory address*/
    beq done       /*If the above cmp is equal, we're done*/
    add r3, r3, 4  /*If here, we're not done, and we add 4 to the mem location of a_value so we get b_value's address*/
    ror r0, r0, 16 /*Rotates the packed value to work with the other 16 bits(Rb) as with Ra for the next iteration*/
    b loop	   /*Continue the loop for Rb*/
    
    
    /*** STUDENTS: Place your code ABOVE this line!!! **************/

done:    
    /* restore the caller's registers, as required by the 
     * ARM calling convention 
     */
    mov r0,r0 /* these are do-nothing lines to deal with IDE mem display bug */
    mov r0,r0 /* this is a do-nothing line to deal with IDE mem display bug */

screen_shot:    pop {r4-r11,LR}

    mov pc, lr	 /* asmFunc return to caller */
   

/**********************************************************************/   
.end  /* The assembler will not process anything after this directive!!! */
           




