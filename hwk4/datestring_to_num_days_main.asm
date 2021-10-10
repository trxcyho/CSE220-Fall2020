.data
start_date: .asciiz "3156-05-08" #2020-09-14 #2019-11-04
end_date: .asciiz "3156-05-08"

.text
.globl main
main:
la $a0, start_date
la $a1, end_date
jal datestring_to_num_days

# Write code to check the correctness of your code!
	move $a0, $v0
	li $v0, 1
	syscall
	
	
#"2020-10-12", "2020-10-25"
#"2020-10-25", "2020-10-12"
#2019-10-25", "2020-10-25"
#1692-11-28", "2602-09-13"
#2019-01-08", "8410-09-08"
#3156-05-08", "3156-05-08"

	
li $v0, 10
syscall

.include "hwk4.asm"

