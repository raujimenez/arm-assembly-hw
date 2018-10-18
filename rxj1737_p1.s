.global main
.func main

main: 
	BL _scanf	@get value for operand 1
	MOV R5,R0
	BL _getchar	@get value for operand op
	MOV R8, R0
	BL _scanf	@get value for operand 2
	MOV R9, R0

	MOV R1, R5 	@get input values
	MOV R2, R8
	MOV R3, R9
	
	BL _getop 	@decide operation
	MOV R1, R0 	@get value to print
	BL _print
	
	B _exit

_exit:  
	MOV R7, #4          @ write syscall, 4
	MOV R0, #1
	SWI 0               @ execute syscall
   	MOV R7, #1          @ terminate syscall, 1
    	SWI 0               @ execute syscall


@INPUT PROCEDURES
_getchar:
    	MOV R7, #3              @ write syscall, 3
    	MOV R0, #0              @ input stream from monitor, 0
    	MOV R2, #1              @ read a single character
    	LDR R1, =read_op     @ store the character in data memory
    	SWI 0                   	@ execute the system call
    	LDR R0, [R1]            @ move the character to the return register
    	AND R0, #0xFF           @ mask out all but the lowest 8 bits
    	MOV PC, LR              @ return
_scanf:
    	PUSH {LR}                @ store LR since scanf call overwrites
    	SUB SP, SP, #4          @ make room on stack
    	LDR R0, =format_str     @ R0 contains address of format string
    	MOV R1, SP              @ move SP to R1 to store entry on stack
    	BL scanf                @ call scanf
    	LDR R0, [SP]            @ load value at SP into R0
    	ADD SP, SP, #4          @ restore the stack pointer
    	POP {PC}                 @ return	

@OPERATOR DECIDER
_getop:
	MOV R4, LR
	CMP R2,  #'+'
	BLEQ _SUM
	CMP R2, #'-'
	BLEQ _DIFFERENCE
	CMP R2, #'*'
	BLEQ _PRODUCT
	CMP R2, #'<'
	BLEQ _LESSTHAN
	MOV PC, R4

@OUTPUT THE RESULT
_print:
	MOV R4, LR          @ store LR since printf call overwrites
	LDR R0,= print_str   @ R0 contains formatted string address
    	BL printf           @ call printf
    	MOV PC, R4          @ return

@CALCULATION PROCEDURES
_SUM:
	MOV R0, R1          @ copy input register R1 to return register R0
	ADD R0, R3         @ add input register R2 to return register R0
	MOV PC, LR          @ return
_DIFFERENCE:
	MOV R0, R1          @ copy input register R1 to return register R0
	SUB R0, R3          @ subtract input register R2 to return register R0
	MOV PC, LR          @ return
_PRODUCT:
	MOV R0, R1          @ copy input register R1 to return register R0
	MUL R0, R3          @ subtract input register R2 to return register R0
	MOV PC, LR          @ return
_LESSTHAN:
	MOV R0, R1          @ copy input register R1 to return register R0
	CMP R0, R3          @ subtract input register R2 to return register R0
	MOVLT R0, #1
	MOVGE R0, #0
	MOV PC, LR          @ return

.data
	read_op: 		.ascii " " 
	format_str:	.asciz "%d"
	print_str:  	.asciz "%d\n"

