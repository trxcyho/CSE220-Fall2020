.data
str: .ascii "CSE 220 COVID-19 Edition\0" 
ch: .byte 'C'
start_index: .word 1

.text
.globl main
main:
	la $a0, str
	lbu $a1, ch
	lw $a2, start_index
	jal index_of
	
	# You must write your own code here to check the correctness of the function implementation.
	move $a0, $v0
	li $v0, 1
	syscall
	
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
