.data
direction: .byte 'D'
.align 2
state:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 1  # head_row
.byte 5  # head_col
.byte 7  # length
# Game grid:
.asciiz ".............a.#.1..#......#.2..#......#.3..#........4567..."
		#1234567890123456789012345678901234567890
		
state4: 
.byte 8  # num_rows
.byte 14  # num_cols
.byte 4  # head_row
.byte 5  # head_col
.byte 14  # length
# Game grid:
.asciiz "....................##......................#........#..a.#..1234..#..........56...E......##.7..CD.........89AB."
		#
		
state5:		#game05
.byte 8  # num_rows
.byte 14  # num_cols
.byte 4  # head_row
.byte 5  # head_col
.byte 13  # length
# Game grid:
.asciiz "....................##......................#........#....#..1234..#a.........56..D.......##.7..C..........89AB."
		 
state6:		#game06		
.byte 5  # num_rows
.byte 5  # num_cols
.byte 1  # head_row
.byte 2  # head_col
.byte 3  # length
# Game grid:
.asciiz "....a..1...#2#..#3#..###."
		
.text
.globl main
main:
la $a0, state5
lbu $a1, direction
jal increase_snake_length
# You must write your own code here to check the correctness of the function implementation.

	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	la $a0, state5
	addi $a0, $a0, 5
	li $v0, 4
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	la $t9, state5
	lbu $a0, 4($t9)
	li $v0, 1
	syscall
	
li $v0, 10
syscall

.include "hwk3.asm"
