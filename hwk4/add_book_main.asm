.data
isbn: .asciiz "9780451230230"
title: .asciiz "The Pacific"
author: .asciiz "Hugh Ambrose"
books:
.align 2
.word 7 4 68
# Book struct start
.align 2
.ascii "9780345501330\0"
.ascii "Fairy Tail, Vol. 1 (Fair\0"
.ascii "Hiro Mashima, William Fl\0"
.word 7777
# empty or deleted entry starts here
.align 2
.byte 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
# empty or deleted entry starts here
.align 2
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start
.align 2
.ascii "9780670032080\0"
.ascii "Financial Peace Revisite\0"
.ascii "Dave Ramsey\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 222
# Book struct start
.align 2
.ascii "9780064408330\0"
.ascii "Joey Pigza Swallowed the\0"
.ascii "Jack Gantos\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 333
# empty or deleted entry starts here
.align 2
.byte -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 
# Book struct start
.align 2
.ascii "9781416971700\0"
.ascii "Out of My Mind\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Sharon M. Draper\0\0\0\0\0\0\0\0\0"
.word 0






.text
.globl main
main:
la $a0, books
la $a1, isbn
la $a2, title
la $a3, author
jal add_book

# Write code to check the correctness of your code!
	#move $a0, $v0
	#li $v0, 1
	#syscall
	
	#li $v0, 11
	#li $a0, '\n'
	#syscall
	
	#move $a0, $v1
	#li $v0, 1
	#syscall
	
move $a0, $v0	
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

move $a0, $v1
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t9, books
lw $a0, 0($t9)
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t9, books
lw $a0, 4($t9)
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $t9, books
lw $a0, 8($t9)
li $v0, 1
syscall

li $a0, '\n'
li $v0, 11
syscall

la $s0, books
lw $s1, 0($s0)            # capacity
lw $s2, 8($s0)            # element_size
mul $s3, $s1, $s2        # counter
addi $s0, $s0, 12        # starting addr of elements

li $s4, 0            # element counter

print_element:
#beqz $s3, end_print_element
beq $s4, $s1, end_print_element
lb $t0, 0($s0)
bltz $t0, reset_counter


move $a0, $s0
li $v0, 4
syscall

addi $s0, $s0, 14
move $a0, $s0
li $v0, 4
syscall

addi $s0, $s0, 25
move $a0, $s0
li $v0, 4
syscall

addi $s0, $s0, 25
move $a0, $s0
li $v0, 4
syscall

lw $a0, 0($s0)
li $v0, 1
syscall

addi $s0, $s0, 4
li $a0, '\n'
li $v0, 11
syscall

addi $s3, $s3, -1        # decrement counter
addi $s4, $s4, 1        # increment element counter

j print_element

reset_counter:
addi $s0, $s0, 68
li $a0, '\n'
li $v0, 11
syscall

li $s4, 0

j print_element

end_print_element:
li $v0, 10
syscall

.include "hwk4.asm"

