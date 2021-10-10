.data
sorted_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka"
counts: .word 0x1b 0x17 0x1d 0xc 0x11 0xa 0x14 0x1e 0xe 0x1e 0x17 0x12 0x19 0x8 0x7 0x1b 0xc 0x0 0x12 0x5 0x1c 0x7 0x09 0x15 0x9 0x11

#counts1: .word 21 17 20 25 21 19 28 26 15 16 21 13 11 16 1 27 24 20 5 23 26 2 29 15 21 8

counts2: .word 23 26 29 1 20 9 15 30 24 20 23 7 17 15 5 4 17 14 12 24 14 1 0 4 14 6
#hcbitakejmqgnruysflzopxdvw
#hcbitakejmqgnruysflzopxdvw
#counts3: .word 26 2 13 11 50 6 2 27 17 0 1 10 9 24 27 9 2 14 22 37 9 3 7 0 2 0 

space: .asciiz " "
.text
.globl main
main:
	la $a0, sorted_alphabet
	la $a1, counts
	jal sort_alphabet_by_count
	
	# You must write your own code here to check the correctness of the function implementation.
	
	li $v0, 4					#print sorted_alphabet 
	la $a0, sorted_alphabet
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
