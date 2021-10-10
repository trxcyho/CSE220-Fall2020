.data
str: .ascii "Stony Brook University\0"
str1: .asciiz "UNIVERSITY"
str2: .asciiz "2020-2021"
str3: .asciiz ""

.text
.globl main
main:
	la $a0, str2
	jal to_lowercase
    
	# You must write your own code here to check the correctness of the function implementation.
	move $a0, $v0				#print number of chars changed
	li $v0, 1
	syscall 
	
	li $v0, 11
    li $a0, '\n'
    syscall
    
	li $v0, 4					#print new string 
	la $a0, str2
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"	
