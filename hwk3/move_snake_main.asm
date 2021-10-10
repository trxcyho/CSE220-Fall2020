.data
direction: .byte 'U'
apples: .byte 1 2 2 9 0 5 1 7 6 10 3 10 3 11 2 10 2 1 2 4 2 5 1 13
apples_length: .word 12
.align 2
state:
.byte 8  # num_rows
.byte 14  # num_cols
.byte 4  # head_row
.byte 5  # head_col
.byte 14  # length
# Game grid:
.asciiz "....................##......................#..a.....#....#..1234..#..........56...E......##.7..CD.........89AB."
		#
		
apples1: .byte 4 4 2 7 3 5 1 8 1 7 3 11 1 11 0 4
apples_length1: .word 8
state1:
.byte 5  # num_rows
.byte 12  # num_cols
.byte 2  # head_row
.byte 4  # head_col
.byte 7  # length
# Game grid:
.asciiz ".............a.#....#......#12..#......#.3..#........4567..."
		#.............a.#....#......#12..#......#.3..#........4567...

apples2: .byte 0 7 3 10 0 9 4 5 0 1 4 10 1 10 0 4 1 3 4 9 0 8 1 9 0 3 4 11 2 0 1 7 3 8 4 1 0 6 4 2 2 4 1 6 4 0 1 2 3 1 2 11 1 0 1 5 2 5 0 10 3 3 1 4 3 9 0 5 0 11 0 2 3 11 1 11 2 2 4 6 2 7 4 8 3 6 4 7 2 10 3 7 2 3 2 8 3 5 2 1 0 0 1 8 4 3 3 0 2 9 3 4 3 2 4 4 1 1 2 6
.align 2
apples_length2: .word 60
state2: 
.byte 5  # num_rows
.byte 12  # num_cols
.byte 2  # head_row
.byte 4  # head_col
.byte 7  # length
# Game grid:
.asciiz "#....#.......a.#....#....###12..###....#.3..#...#....4567..#"

.text
.globl main
main:
la $a0, state2
lbu $a1, direction
la $a2, apples2
lw $a3, apples_length2
jal move_snake

# You must write your own code here to check the correctness of the function implementation.

	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	move $a0, $v1
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	la $a0, state2
	addi $a0, $a0, 5
	li $v0, 4
	syscall
	
	
	
li $v0, 10
syscall

.include "hwk3.asm"
