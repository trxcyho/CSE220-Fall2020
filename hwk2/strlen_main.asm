.data
str: .ascii "Wolfie Seawolf!!! 2020??\0"
str1: .asciiz "MIPS"
str2: .asciiz ""

.text
.globl main
main:
	la $a0, str1
	jal strlen
	
	# You must write your own code here to check the correctness of the function implementation.
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
