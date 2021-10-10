# Tracy Ho
# trcho
# 112646529

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
addr_arg4: .word 0
addr_arg5: .word 0
addr_arg6: .word 0
addr_arg7: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Output messages
big_bobtail_str: .asciiz "BIG_BOBTAIL\n"
full_house_str: .asciiz "FULL_HOUSE\n"
five_and_dime_str: .asciiz "FIVE_AND_DIME\n"
skeet_str: .asciiz "SKEET\n"
blaze_str: .asciiz "BLAZE\n"
high_card_str: .asciiz "HIGH_CARD\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Put your additional .data declarations here, if any.


# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beqz $a0, zero_args
    li $t0, 1
    beq $a0, $t0, one_arg
    li $t0, 2
    beq $a0, $t0, two_args
    li $t0, 3
    beq $a0, $t0, three_args
    li $t0, 4
    beq $a0, $t0, four_args
    li $t0, 5
    beq $a0, $t0, five_args
    li $t0, 6
    beq $a0, $t0, six_args
seven_args:
    lw $t0, 24($a1)
    sw $t0, addr_arg6
six_args:
    lw $t0, 20($a1)
    sw $t0, addr_arg5
five_args:
    lw $t0, 16($a1)
    sw $t0, addr_arg4
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
    # Start the assignment by writing your code here
    lw $t0, num_args								#$t0 = number of arguements
    lw $s1, addr_arg0
    lbu $t1, 0($s1) 								#first char of arg 1
    
    li $t9, '1'
    beq $t1, $t9, operation_1_2_S
    li $t9, '2'
    beq $t1, $t9, operation_1_2_S
    li $t9, 'S'
    beq $t1, $t9, operation_1_2_S
    li $t9, 'F'
    beq $t1, $t9, operation_F
    li $t9, 'R'
    beq $t1, $t9, operation_R
    li $t9, 'P'
    beq $t1, $t9, operation_P
    j invalid_operation					
    									
operation_1_2_S:
	li $t9, 3
	bne $t0, $t9, invalid_args    															
    addi $s1, $s1, 1
    lbu $t2, 0($s1)									#gets 2 byte of argument 1
    beqz $t2, part_two								#if 2 byte equal 0, go to part 3
    j invalid_operation																		
    																							
operation_F:
    li $t9, 2							
    bne $t0, $t9, invalid_args						#checks if 2 arguements
    addi $s1, $s1, 1
    lbu $t2, 0($s1)									#gets 2 byte of argument 1
    beqz $t2, part_three							#if 2 byte equal 0, go to part 3
    j invalid_operation

operation_R:
    li $t9, 7							
    bne $t0, $t9, invalid_args						#checks if 7 arguements
    addi $s1, $s1, 1
    lbu $t2, 0($s1)									#gets 2 byte of argument 1
    beqz $t2, part_four								#if 2 byte equal 0, go to part 4
    j invalid_operation

operation_P:							
    li $t9, 2							
    bne $t0, $t9, invalid_args						#checks if 2 arguements
    addi $s1, $s1, 1
    lbu $t2, 0($s1)									#gets 2 byte of argument 1
    beqz $t2, part_five								#if 2 byte equal 0, go to part 5
    j invalid_operation
    
#part 2
part_two:			#1, 2, or S(process a string of 4 hex digits that represents a signed int
    lw $s1, addr_arg1							#loads address of 2 arg into s1
    li $t9, 0								#t9 = counter = 0
    li $t8, 4								#$t8 = stopping arg for for loop(4)
    		
    second_arg_loop:					#checks if second argument has 4 chars and is valid hexadecimal
    lbu $t2, 0($s1)    							#$t2 = first character of second argument; then iterate through
    bge $t9, $t8, part_2_contd					#stopping scenario (made sure all 4 chars are valid
    li $t7, 'F'									
    bgt $t2, $t7, invalid_args					#invalid if char is greater than F
    li $t7, '0'	
    blt $t2, $t7, invalid_args					#invalid if char less than 0
    li $t7, '9'	
    bgt $t2, $t7, check_if_letter				#if greater than 9, make sure valid letter
    	second_arg_loop_contd:
    addi $t9, $t9, 1			
    addi $s1, $s1, 1
    j second_arg_loop
    
    check_if_letter:
    	li $t7, 'A'								
    	blt $t2, $t7, invalid_args				#if char less than A, invalid
    	j second_arg_loop_contd
    
part_2_contd:							#check if third arg valid (16 to 32)
	lw $s2, addr_arg2
    lbu $t3, 0($s2)							#gets first char of 3 arg
    li $t6, 0
    add $t6, $t6, $t3						#$t6 = first digit of third arg
    li $t8, '1'
    beq $t3, $t8, check_1_range
    li $t8, '2'
    beq $t3, $t8, check_2_range
    li $t8, '3'
    beq $t3, $t8, check_3_range
    j invalid_args
    
    check_1_range:						#check if 2 char of 3 arg is 6-9
    addi $s2, $s2, 1
    lbu $t3, 0($s2)							#iterates to next char
    li $t8, '6'
    blt $t3, $t8, invalid_args
    li $t8, '9'
    ble $t3, $t8, part_two_contd2			
    j invalid_args
    
    check_2_range:						#check if 2 char of 3 arg is 0-9
    addi $s2, $s2, 1						
    lbu $t3, 0($s2)						#iterates to next char
    li $t8, '0'
    blt $t3, $t8, invalid_args
    li $t8, '9'
    ble $t3, $t8, part_two_contd2
    j invalid_args
    
    check_3_range:						#check if 2 char of 3 arg is 0-2
    addi $s2, $s2, 1	
    lbu $t3, 0($s2)						#iterates to next char
    li $t8, '0'
    blt $t3, $t8, invalid_args
    li $t8, '2'
    ble $t3, $t8, part_two_contd2
    j invalid_args
    
part_two_contd2:    
	#convert third arg into one register
	addi $t6, $t6, -48						#get respective digit
	addi $t3, $t3, -48
	li $t9, 10
	mul $t6, $t6, $t9						#makes it 10 digit
	add $t3, $t6, $t3 						#third arg in $t3
	
	#convert hex to bin
	lw $s1, addr_arg1						#loads address of 2 arg into s1
	li $t4, 0							#$t4 = binary version of hex
	
	#convert from sign bit to  
	lbu $t9, 0($s1)							#saves a copy for later when branching btw + and -
	li $t8, 4
	
	convert_to_bin:
	beqz $t8, compare_sign
	sll $t4, $t4, 4							#shift left 4 for next number
	lbu $t2, 0($s1)    						#$t2 = first character of second argument
	li $t7, 'A'
	blt $t2, $t7, offset_number
	li $t7, -55
	add $t2, $t2, $t7
		after_offset:
	or $t4, $t4, $t2						
	addi $s1, $s1, 1
	addi $t8, $t8, -1
	j convert_to_bin
	
	offset_number:
	li $t7, '0'
	sub $t2, $t2, $t7
	j after_offset	
	
	compare_sign:
	li $t8, '8'	
	bge $t9, $t8, sign_negative
	j printing_bin_2comp
	
	sign_negative:
	li $t8, 'S'
	bne $t1, $t8, left_pad
	#flip if in sign mag
	li $t8, 0x0007fff
	xor $t4, $t4, $t8									#flip all bits excluding sign
		left_pad:
	li $t8, 0xffff0000									
	or $t4, $t4, $t8										#left pad with 1 since negative
	li $t8, '2'
	bne $t1, $t8, add_one
	j printing_bin_2comp
	
	add_one:
	addi $t4, $t4, 1				
				
	printing_bin_2comp:		#t3 = 3rd argument as decimal
	li $t9, 0x1 # 0000000000000000000000001
	li $a0, 0
	addi $t3, $t3, -1
	
	sllv $t9, $t9, $t3
	li $v0, 1
	
	printing_bin_loop:
	bltz $t3, print_newline
	and $a0, $t9, $t4										#masking
	srlv $a0, $a0, $t3
	syscall
	srl $t9, $t9, 1
	addi, $t3, $t3, -1
	j printing_bin_loop
    
#part 3   
part_three:			#F(print decimal fixed point as binary fixed point)
    lw $s1, addr_arg1							#loads address of 2 arg into s1
    li $t3, 0
    
    lbu $t2, 0($s1)
    li $t9, 100
    addi $t2, $t2, -48 							#to offset
    mul $t3, $t2, $t9
    addi $s1, $s1, 1
    
    lbu $t2, 0($s1)
    li $t9, 10
    addi $t2, $t2, -48 							#to offset
    mul $t2, $t2, $t9
    add $t3, $t3, $t2
    addi $s1, $s1, 1
    
    lbu $t2, 0($s1)
    addi $t2, $t2, -48 							#to offset
    add $t3, $t3, $t2							#$t3 stores binary rep of first 3 numbers
    
    li $t9, 0
    bnez $t3, print_three_digits					#if $t3 = 0
    li $v0, 1
    li $a0, 0
    syscall
    j print_radix_point
    
    #prints the first 3 numbers in binary
    print_three_digits:
    li $t9, 0x1
    li $a0, 0										
    li $t8, 10										#max number of digits for bin
    sllv $t9, $t9, $t8 
    
    #loops through until it reaches first non-0
    first_valid_number:
    and $a0, $t9, $t3
    srlv $a0, $a0, $t8
    bnez $a0, print_bin_3_digit
    srl $t9, $t9, 1
    addi $t8, $t8, -1
    j first_valid_number
    
    print_bin_3_digit:
    li $v0, 1
    	printing_loop:
    bltz $t8, print_radix_point
    and $a0, $t9, $t3
    srlv $a0, $a0, $t8
    syscall
    srl $t9, $t9, 1
    addi $t8, $t8, -1
    j printing_loop
    
    print_radix_point:
    addi $s1, $s1, 1
    li $v0, 11										#print char . 
    lbu $a0, 0($s1)
    syscall
    
	li $t9, 10 										#mult by ten when adding next digit
	li $t8, 5										#counter for loop
	li $t3, 0										#$t3 = decimal part of number
	
	convert_decimal:
	beqz $t8, print_decimal
	addi $s1, $s1, 1								#shift to next digit
    lbu $t2, 0($s1)
    addi $t2, $t2, -48								#offset $t2
    mul $t3, $t3, $t9
    add $t3, $t3, $t2
	addi $t8, $t8, -1								#decrease counter
	j convert_decimal
	
	print_decimal:
	li $v0, 1
	li $t9, 50000
	li $t8, 2
	li $t7, 5
	
	print_decimal2:
	beqz $t7, print_newline
	blt $t3, $t9, print_zero
	li $a0, 1
	syscall
		reset_numbers:
	sub $t3, $t3, $t9
	div $t9, $t8
	mflo $t9
	addi $t7, $t7, -1
	j print_decimal2
	
	print_zero:
	li $a0, 0
	syscall
	div $t9, $t8
	mflo $t9
	addi $t7, $t7, -1
	j print_decimal2
    
#part 4
part_four:			#R(encode 6 numerical field as R-type instruction)
    li $s0, 0 									#output hexadecimal number
    
    #3arg
    lw $s1, addr_arg2
    
    lbu $t2 0($s1)								#forms 3 arg into decimal
    addi $t2, $t2, -48
    li $t9, 10
    mul $t3, $t2, $t9
    addi $s1, $s1, 1
    lbu $t2, 0($s1)
    addi $t2, $t2, -48
    add $t3, $t3, $t2							#$t3 = 3arg
    
    li $t9, 31									#check if 3 arg is in range
    bgt $t3, $t9, invalid_args
    
    or $s0, $s0, $t3							#combines to form the R type hexadecimal
    
    #4 arg
    lw $s1, addr_arg3
    
    lbu $t2 0($s1)								#forms arg into decimal
    addi $t2, $t2, -48
    li $t9, 10
    mul $t3, $t2, $t9
    addi $s1, $s1, 1
    lbu $t2, 0($s1)
    addi $t2, $t2, -48
    add $t3, $t3, $t2							#$t3 = arg
    
    li $t9, 31									#check if arg is in range
    bgt $t3, $t9, invalid_args
    
    sll $s0, $s0, 5
    or $s0, $s0, $t3							#combines to form the R type hexadecimal
    
    #5 arg
	lw $s1, addr_arg4
    
    lbu $t2 0($s1)								#forms arg into decimal
    addi $t2, $t2, -48
    li $t9, 10
    mul $t3, $t2, $t9
    addi $s1, $s1, 1
    lbu $t2, 0($s1)
    addi $t2, $t2, -48
    add $t3, $t3, $t2							#$t3 = arg
    
    li $t9, 31									#check if arg is in range
    bgt $t3, $t9, invalid_args
    
    sll $s0, $s0, 5
    or $s0, $s0, $t3							#combines to form the R type hexadecimal
    
    #6 arg
    lw $s1, addr_arg5
    
    lbu $t2 0($s1)								#forms arg into decimal
    addi $t2, $t2, -48
    li $t9, 10
    mul $t3, $t2, $t9
    addi $s1, $s1, 1
    lbu $t2, 0($s1)
    addi $t2, $t2, -48
    add $t3, $t3, $t2							#$t3 = arg
    
    li $t9, 31									#check if arg is in range
    bgt $t3, $t9, invalid_args
    
    sll $s0, $s0, 5
    or $s0, $s0, $t3							#combines to form the R type hexadecimal
    
    #7 arg
	lw $s1, addr_arg6
	
	lbu $t2 0($s1)								#forms arg into decimal
	addi $t2, $t2, -48
    li $t9, 10
    mul $t3, $t2, $t9
    addi $s1, $s1, 1
    lbu $t2, 0($s1)
    addi $t2, $t2, -48
    add $t3, $t3, $t2
	
    li $t9, 63									#check if arg is in range
    bgt $t3, $t9, invalid_args
    
    sll $s0, $s0, 6
    or $s0, $s0, $t3							#combines to form the R type hexadecimal
    
   #print in hexadecimal
	li $v0, 34
	move $a0, $s0
	syscall
	j print_newline
	
#part 5
part_five:			#P(identify non-standard, 5 card poker hands)
    lw $t2, addr_arg1
    lbu $s1, 0($t2)
    addi $t2, $t2, 1
    lbu $s2, 0($t2)
    addi $t2, $t2, 1
    lbu $s3 0($t2)
    addi $t2, $t2, 1
    lbu $s4, 0($t2)
    addi $t2, $t2, 1
    lbu $s5, 0($t2)

	#sort the cards from smallest to largest
	li $t9, 25									#counter for amount of swaps to bubble sort
	
	five_sort_cards:
	beqz $t9, five_big_bobtail					#registers sorted
	bgt $s1, $s2, swap1
	bgt $s2, $s3, swap2
	bgt $s3, $s4, swap3
	bgt $s4, $s5, swap4
		five_sort_card_contd:
	addi $t9, $t9, -1
	j five_sort_cards
	
	swap1:
	move $t9, $s1
	move $s1, $s2
	move $s2, $t9
	j five_sort_card_contd
	
	swap2:
	move $t9, $s2
	move $s2, $s3
	move $s3, $t9
	j five_sort_card_contd
	
	swap3:
	move $t9, $s3
	move $s3, $s4
	move $s4, $t9
	j five_sort_card_contd
	
	swap4:
	move $t9, $s4
	move $s4, $s5
	move $s5, $t9
	j five_sort_card_contd
	
five_big_bobtail:
	move $t1, $s1								#copies into other register so we never alter actual number
	move $t2, $s2
	move $t3, $s3
	move $t4, $s4
	move $t5, $s5
	
	#case 1(first 4 cards)
	addi $t1, $t1, 1
	bne $t1, $t2, bobtail_case2				# card1 + 1 not equal card 2
	addi $t2, $t2, 1
	bne $t2, $t3, five_full_house				#card 2 + 1 not equal card 3
	addi $t3, $t3, 1
	bne $t3, $t4, five_full_house				#card 3 + 1 not equal card 4
			#card 1-4 all increment of one equal
	li $v0, 4
	la $a0, big_bobtail_str
	syscall
	j exit
	
	bobtail_case2:
	addi $t2, $t2, 1
	bne $t2, $t3, five_full_house				#card 2 + 1 not equal card 3
	addi $t3, $t3, 1
	bne $t3, $t4, five_full_house				#card 3 + 1 not equal card 4
	addi $t4, $t4, 1
	bne $t4, $t5, five_full_house				#card 4 + 1 not equal card 5
			#card 2-5 all increment one equal
	li $v0, 4
	la $a0, big_bobtail_str
	syscall
	j exit
	
five_full_house:
		#convert all cards into just their numbers(ignore suits)
	sll $s1, $s1, 28							#shift all cards left by 28, then right to isolate number
	srl $s1, $s1, 28
	sll $s2, $s2, 28
	srl $s2, $s2, 28	
	sll $s3, $s3, 28
	srl $s3, $s3, 28
	sll $s4, $s4, 28
	srl $s4, $s4, 28
	sll $s5, $s5, 28
	srl $s5, $s5, 28	
	
		#sort the new cards
	li $t9, 25									#counter for amount of swaps to bubble sort
	
	five_sort_numbers:
	beqz $t9, full_house_contd					#registers sorted
	bgt $s1, $s2, n_swap1
	bgt $s2, $s3, n_swap2
	bgt $s3, $s4, n_swap3
	bgt $s4, $s5, n_swap4
		five_sort_numbers_contd:
	addi $t9, $t9, -1
	j five_sort_numbers
	
	n_swap1:
	move $t9, $s1
	move $s1, $s2
	move $s2, $t9
	j five_sort_numbers_contd
	
	n_swap2:
	move $t9, $s2
	move $s2, $s3
	move $s3, $t9
	j five_sort_numbers_contd
	
	n_swap3:
	move $t9, $s3
	move $s3, $s4
	move $s4, $t9
	j five_sort_numbers_contd
	
	n_swap4:
	move $t9, $s4
	move $s4, $s5
	move $s5, $t9
	j five_sort_numbers_contd
	
	full_house_contd:
	#case1: first 2 cards are equal, last three are equal
	bne $s1, $s2, five_five_and_dime		# first card equal second?
	bne $s3, $s4, full_house_case2
	bne $s4, $s5, five_five_and_dime
	li $v0, 4
	la $a0, full_house_str
	syscall
	j exit
	
	full_house_case2:
	#first 3 equal, last 2 equal
	bne $s2, $s3, five_five_and_dime
	bne $s4, $s5, five_five_and_dime
	li $v0, 4
	la $a0, full_house_str
	syscall
	j exit
	
five_five_and_dime:
	#check for 5 in cards
	li $t9, 5
	beq $s1, $t9, check_for_10
	beq $s2, $t9, check_for_10
	beq $s3, $t9, check_for_10
	beq $s4, $t9, check_for_10
	beq $s5, $t9, check_for_10
	j five_skeet
	
	check_for_10:
	li $t9, 10
	beq $s1, $t9, check_range_5_10
	beq $s2, $t9, check_range_5_10
	beq $s3, $t9, check_range_5_10
	beq $s4, $t9, check_range_5_10
	beq $s5, $t9, check_range_5_10
	j five_skeet
	
	check_range_5_10:
	li $t9, 10
	li $t8, 5
	blt $s1, $t8, five_skeet
	bgt $s1, $t9, five_skeet
	blt $s2, $t8, five_skeet
	bgt $s2, $t9, five_skeet
	blt $s3, $t8, five_skeet
	bgt $s3, $t9, five_skeet
	blt $s4, $t8, five_skeet
	bgt $s4, $t9, five_skeet
	blt $s5, $t8, five_skeet
	bgt $s5, $t9, five_skeet
	
	#make sure no matching cards in hand
	beq $s1, $s2, five_skeet
	beq $s2, $s3, five_skeet
	beq $s3, $s4, five_skeet
	beq $s4, $s5, five_skeet
	
	#print five & dime
	li $v0, 4
	la $a0, five_and_dime_str
	syscall
	j exit

five_skeet:
	#check for 2
	li $t9, 2
	beq $s1, $t9, check_for_5
	beq $s2, $t9, check_for_5
	beq $s3, $t9, check_for_5
	beq $s4, $t9, check_for_5
	beq $s5, $t9, check_for_5
	j five_blaze
	
	#check for 5
	check_for_5:
	li $t9, 5
	beq $s1, $t9, check_for_9
	beq $s2, $t9, check_for_9
	beq $s3, $t9, check_for_9
	beq $s4, $t9, check_for_9
	beq $s5, $t9, check_for_9
	j five_blaze

	check_for_9:
	li $t9, 9
	beq $s1, $t9, check_for_under_9
	beq $s2, $t9, check_for_under_9
	beq $s3, $t9, check_for_under_9
	beq $s4, $t9, check_for_under_9
	beq $s5, $t9, check_for_under_9
	j five_blaze

	check_for_under_9:
	bgt $s1, $t9, five_blaze
	bgt $s2, $t9, five_blaze
	bgt $s3, $t9, five_blaze
	bgt $s4, $t9, five_blaze
	bgt $s5, $t9, five_blaze
	
	#make sure no matching cards
	beq $s1, $s2, five_blaze
	beq $s2, $s3, five_blaze
	beq $s3, $s4, five_blaze
	beq $s4, $s5, five_blaze

	li $v0, 4
	la $a0, skeet_str
	syscall
	j exit

five_blaze:
		#make sure its all from J Q K
	li $t9, 13
	li $t8, 11
	blt $s1, $t8, print_highcard
	bgt $s1, $t9, print_highcard
	blt $s2, $t8, print_highcard
	bgt $s2, $t9, print_highcard
	blt $s3, $t8, print_highcard
	bgt $s3, $t9, print_highcard
	blt $s4, $t8, print_highcard
	bgt $s4, $t9, print_highcard
	blt $s5, $t8, print_highcard
	bgt $s5, $t9, print_highcard

	li $v0, 4
	la $a0, blaze_str
	syscall
	j exit

print_highcard:
	li $v0, 4
    la $a0, high_card_str
    syscall
    j exit

print_newline:
	li $v0, 11
    li $a0, '\n'
    syscall
    j exit
 
invalid_operation:								#prints INVALID OPERATION and exit program
    li $v0, 4
    la $a0, invalid_operation_error
    syscall
    j exit
    
invalid_args:									#prints INVALID ARGS and exit program
    li $v0, 4
    la $a0, invalid_args_error
    syscall
    j exit

exit:
    li $v0, 10
    syscall
