.data
ciphertext_alphabet: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"
keyphrase: .ascii "Stony Brook University\0"

ciphertext_alphabet1: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"
keyphrase1: .ascii "Monday, September 21st, 2020 4:39 PM EDT\0"

ciphertext_alphabet2: .ascii "drfXArg153cyIJvv2dkivJvSpka5BXf4MyeauUCg5cfQjiY6bs6BKEqE1cXtvHZ"
keyphrase2: .ascii "suPeRcalIfrAgiListICexPiaLIdoCIOus\0"

keyphrase3: .ascii "I'll have you know that I stubbed my toe last week and only cried for 20 minutes.\0"
.text
.globl main
main:
	la $a0, ciphertext_alphabet2
	la $a1, keyphrase3
	jal generate_ciphertext_alphabet
	
	# You must write your own code here to check the correctness of the function implementation.
	move $a0, $v0				#print v0
	li $v0, 1
	syscall 
	
	li $v0, 11
    li $a0, '\n'
    syscall
	
	li $v0, 4					#print new string 
	la $a0, ciphertext_alphabet2
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
