// chap8-arrays.s

// see https://thinkingeek.com/2013/01/27/arm-assembler-raspberry-pi-chapter-8/

// there are 9 indexing modes!

.data
 
 // int a[100] 
.balign 4
a: .skip 100*4 

/*
struct my_struct
{
  char f0;
  int f1;
} b;
*/
.balign 4
b: .skip 8 // padding


.text
.global main
main:
    dbg #0
	// r0: value to store in array
	// r1: beginning address of array, 
	// r2:  index of the array
	_va: ldr r1,adr_of_a
	add r1,r1,pc // r1 = &a
	mov r0, #0
	mov r2, #0

loop:	str r0, [r1, +r2, LSL #2 ] // *(r1 + r2*4) ← r0 
	    add r2,#1  // r2++
	    cmp r2,100
 		bne loop
 		mov r0, r2
	    bx lr


adr_of_a: .word a - _va

/*
b.f1 = b.f1 + 7;

 If r1 contains the base address of our structure, accessing the field f1 is pretty easy now that we know all the available indexing modes.


ldr r2, [r1, #+4]!  // r1 ← r1 + 4 then r2 ← *r1 
add r2, r2, #7     // r2 ← r2 + 7 
str r2, [r1]       // *r1 ← r2 

Note that we use a pre-indexing mode to keep in r1 the address of the field f1. This way the second store does not need to compute that address again. 

*/