.global main
.func main

main:
	BL _scanf
	MOV R6, R0			@n value
	BL _scanf 		
	MOV R10, R0			@m value
	MOV R1, R6
	MOV R2, R10
	BL count_partition
	MOV R1, R0
	MOV R2, R6	
	MOV R3, R10
	BL _printf
	B main

@***********************************************************************************
@*****************************Begin of partition*************************************
@***********************************************************************************
count_partition:
    PUSH {LR}               @ store the return address
    
    @TERMINATOR CASES
    CMP R1, #0              @ n == 0
    MOVEQ R0, #1
    POPEQ {PC}              @ restore stack pointer and return if equal
    CMP R1, #0		@ n < 0 
    MOVLT R0, #0
    POPLT {PC}              @ restore stack pointer and return if equal
    CMP R2, #0		@ m == 0 
    MOVEQ R0, #0
    POPEQ {PC}              @ restore stack pointer and return if equal
   
   @ELSE PART
    SUB R1, R1, R2         @ n - m
    PUSH {R1}
    PUSH {R2}
    BL count_partition                @ compute count_partitions(n - m,m)
    MOV R4, R0
    POP {R2}
    POP {R1}
    
    SUB R2, R2, #1		@m - 1
    PUSH {R1}
    PUSH {R2}            
    BL count_partition		@compute partition(n, m - 1) 
    MOV R5, R0
    ADD R0, R4, R5
    POP {R2}
    POP {R1}
    
    POP {PC}               @ restore the stack pointer and return	
@***********************************************************************************
@*********************Begin of input and out functions******************************
@***********************************************************************************
_scanf:
    PUSH {LR}               @ store the return address
    PUSH {R1}               @ backup regsiter value
    LDR R0, =format_str     @ R0 contains address of format string
    SUB SP, SP, #4          @ make room on stack
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ remove value from stack
    POP {R1}                @ restore register value
    POP {PC}                @ restore the stack pointer and return

_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
    
    
@***********************************************************************************
@***********************Begin of data declarations*********************************
@***********************************************************************************

.data
format_str:	.asciz	"%d"
printf_str: 		.asciz 	"There are %d partitions of %d using integers up to %d\n"
