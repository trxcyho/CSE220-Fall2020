.data
plaintext_alphabet: .ascii "eauUCg5cfQjiY6bs6BKEqE1cXtvHZEn0MOHKZ9uaz5XPGBRIOYQM41FHQAxGc2W"
sorted_alphabet: .ascii "egljhotupvfsxawqkrmzdyncib\0"

sorted_alphabet1: .asciiz "eznovrqbdatjghlwmskyipcxfu"

sorted_alphabet2: .asciiz "jmhoxqzgityudwsecvfalnkrbp"

sorted_alphabet3: .asciiz "ethoansircdlmpuwfvbgqykjxz"
space: .asciiz " "
.text
.globl main
main:
	la $a0, plaintext_alphabet
	la $a1, sorted_alphabet3
	jal generate_plaintext_alphabet
	
	# You must write your own code here to check the correctness of the function implementation.
	
	li $v0, 4					#print plaintext_alphabet 
	la $a0, plaintext_alphabet
	syscall
	
	li $v0, 4					#print space 
	la $a0, space
	syscall
	
	li $v0, 4					#print sorted_alphabet 
	la $a0, sorted_alphabet3
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
#abcdeeeeeeeeefgggggggghhhhhijjjjjjklllllllmnoooopqrstttuuvwxyz egljhotupvfsxawqkrmzdyncib
#abcdeeeeeeeeefgggggggghhhhhijjjjjjklllllllmnoooopqrstttuuvwxyz egljhotupvfsxawqkrmzdyncib

#abbcdeeeeeeeeefghijklmnnnnnnnoooooopqqqrrrrstuvvvvvwxyzzzzzzzz eznovrqbdatjghlwmskyipcxfu
#abbcdeeeeeeeeefghijklmnnnnnnnoooooopqqqrrrrstuvvvvvwxyzzzzzzzz eznovrqbdatjghlwmskyipcxfu

#abcdefgghhhhhhhijjjjjjjjjklmmmmmmmmnoooooopqqqqrstuvwxxxxxyzzz jmhoxqzgityudwsecvfalnkrbp
#abcdefgghhhhhhhijjjjjjjjjklmmmmmmmmnoooooopqqqqrstuvwxxxxxyzzz jmhoxqzgityudwsecvfalnkrbp
