.data
isbn: .asciiz "9780802122550"
books:
.align 2
.word 7 7 68
# Book struct start
.align 2
.ascii "9780553214830\0"
.ascii "The Declaration of Indep\0"
.ascii "Founding Fathers\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780446695660\0"
.ascii "Double Whammy\0\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Carl Hiaasen\0\0\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780060855900\0"
.ascii "Equal Rites (Discworld, \0"
.ascii "Terry Pratchett\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780345527780\0"
.ascii "Wicked Business (Lizzy &\0"
.ascii "Janet Evanovich\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9788433914260\0"
.ascii "Hollywood\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Charles Bukowski\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9780312577220\0"
.ascii "Fly Away (Firefly Lane, \0"
.ascii "Kristin Hannah\0\0\0\0\0\0\0\0\0\0\0"
.word 0
# Book struct start
.align 2
.ascii "9781620610090\0"
.ascii "Opal (Lux, #3)\0\0\0\0\0\0\0\0\0\0\0"
.ascii "Jennifer L. Armentrout\0\0\0"
.word 0




.text
.globl main
main:
la $a0, books
la $a1, isbn
jal delete_book

# Write code to check the correctness of your code!
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
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
	
li $v0, 10
syscall

.include "hwk4.asm"

