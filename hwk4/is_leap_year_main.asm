.data
year: .word 3997

.text
.globl main
main:
lw $a0, year
jal is_leap_year

# Write code to check the correctness of your code!
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
li $v0, 10
syscall

.include "hwk4.asm"
