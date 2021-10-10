.data
counts: .word 556732 25 7 612618 -145953 -440997 -774137 758469 889951 834642 -919986 -204919 124497 179267 -303331 -285295 786955 -891155 -665164 -716764 -292806 176422 -299979 471550 -485856 -656536
message: .ascii "The specialization in artificial intelligence and data science emphasizes modern approaches for building intelligent systems using machine learning.\0"

counts1: .word -890186 -438641 -817157 612618 -145953 -440997 -774137 758469 889951 834642 -919986 -204919 124497 179267 -303331 -285295 786955 -891155 -665164 -716764 -292806 176422 -299979 471550 -485856 -656536
message1: .asciiz "We can only see a short distance ahead, but we can see plenty there that needs to be done. -Alan Turing"

message2: .asciiz ""
space: .asciiz " "
.text
.globl main
main:
	la $a0, counts
	la $a1, message2
	jal count_lowercase_letters

	# You must write your own code here to check the correctness of the function implementation.
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
    li $a0, '\n'
    syscall
	
	la $s0, counts
	li $s1, 26	# size of array
	li $t1, 0	# i = 0

	# Algorithm 1: print contents of the array
loop1:
	beq $t1, $s1, done1	# repeat until counter == size
	sll $t0, $t1, 2		# $t0 = 4*i
	add $t0, $t0, $s0	# $t0 holds address of ages[i]
	lw $a0, 0($t0)		# get ages[i]
	li $v0, 1		# syscall 1 is print_integer
	syscall
	
	la $a0, space 	
	li $v0, 4		# syscall 4 is print_string
	syscall

	addi $t1, $t1, 1	# i++
	
	j loop1
	
	done1:
	li $v0, 10
	syscall
	
.include "hwk2.asm"
