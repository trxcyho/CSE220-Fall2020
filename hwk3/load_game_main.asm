.data
filename: .asciiz "game01.txt"
filename1: .asciiz "game02.txt"
#...................####.......#........#....#........#....#..1.....#....#........#.......####...................
#...................####.......#........#....#........#....#..1.....#....#........#.......####...................
filename2: .asciiz "game03.txt"
#....................##......................#........#..a.#..1234..#..........56...E......##.7..CD.........89AB.
#

filename3: .asciiz "game04.txt"
filename4: .asciiz "game05.txt"
filename5: .asciiz "game06.txt"
filename6: .asciiz "game07.txt"
filename7: .asciiz "game08.txt"
filename8: .asciiz "game09.txt"
filename9: .asciiz "junk.txt"

.align 2
state: .byte 0x05 0x0c 0x0e 0x45 0x17
.asciiz "XArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZfffffffffffffffffffffffffffffffffffffffffffffffffffffjeiejfiejijefeefefe"
        #12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
        #		  1         2         3         4         5         6         7         8         9         10        11
.text
.globl main
main:

la $a0, state
la $a1, filename8
jal load_game

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
	
	
	#prints the length of the snake
	la $t9, state
	lbu $a0, 3($t9)
	li $v0, 1
	syscall

	li $v0, 11
	li $a0, '\n'
	syscall
	
	la $a0, state
	addi $a0, $a0, 5
	li $v0, 4
	syscall
	
	#print state or look at state in memory

li $v0, 10
syscall

.include "hwk3.asm"
