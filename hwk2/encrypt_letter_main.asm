.data
plaintext_letter: .byte 'u'
letter_index: .word 3
plaintext_alphabet: .ascii "abbbbbbbbcdefffffffgggghiiijkklmnopqrstuuuuuvvvvvvwxxxxxxxxxyz\0"
ciphertext_alphabet: .ascii "StonyBrkUivesNwYadfAmcbghjlpquxzCDEFGHIJKLMOPQRTVWXZ0123456789\0"

plaintext_letter1: .byte 'p'
letter_index1: .word 46
plaintext_alphabet1: .ascii "abcdeeefghijkkkkkkkllllllmmnoppppppppqrstuvvvvvwxyyyyzzzzzzzzz\0"

plaintext_letter2: .byte 'x'
letter_index2: .word 37
plaintext_alphabet2: .ascii "abcccccdeeeeeeeeeffffffffgghijkkklmnoppppqrstuvwxxxxxxyzzzzzzz\0"

plaintext_letter3: .byte 'n'
letter_index3: .word 15
plaintext_alphabet3: .ascii "abccccccccdddddefghiiiiiijjjjjjjjjklmmnopqrstuvwwwwwwwxyyyyzzz\0"
.text
.globl main
main:
 	lbu $a0, plaintext_letter
	lw $a1, letter_index
	la $a2, plaintext_alphabet
	la $a3, ciphertext_alphabet
	jal encrypt_letter
	
	# You must write your own code here to check the correctness of the function implementation.
	
	move $a0, $v0 				#print char
	li $v0, 11
	syscall
	
	li $v0, 1					#print as integer
	syscall 
	
	li $v0, 4					#print plaintext_alphabet 
	la $a0, plaintext_alphabet
	syscall
	
	li $v0, 4					#print plaintext_alphabet 
	la $a0, ciphertext_alphabet
	syscall
	
	li $v0, 10
	syscall
	
.include "hwk2.asm"
