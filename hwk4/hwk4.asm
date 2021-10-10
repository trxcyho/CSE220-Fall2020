# Tracy Ho
# trcho
# 112646529

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
memcpy:	
	#if n <= 0
	blez $a2, invalid_memcpy_args
	
	move $v0, $a2 							#v0 = n
	
	memcpy_loop:
		beqz $a2, memcpy_end
	lbu $t0, 0($a1)
	sb $t0, 0($a0)
	addi $a1, $a1, 1
	addi $a0, $a0, 1
	addi $a2, $a2, -1
	j memcpy_loop
	
	invalid_memcpy_args:
	li $v0, -1
	
	memcpy_end:
    jr $ra

strcmp:
	#check if either string is null	
	lbu $t0, 0($a0)
	beqz $t0, strcmp_str1_empty
	lbu $t1, 0($a1)
	beqz $t1, strcmp_str2_empty
	
	#both strings are not null
	strcmp_loop:
	bne $t0, $t1, strcmp_loop_done
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	lbu $t0, 0($a0)
	lbu $t1, 0($a1)
	beqz $t0, strcmp_loop_done		#if both string is identical
	j strcmp_loop
	
	strcmp_loop_done:
	beq $t0, $t1, strcmp_same_empty				#would only branch if both are null(identical strings)
	sub $v0, $t0, $t1					#v0 = str1[n] - str2[n]
	j strcmp_end
	
	#str1 = null
	strcmp_str1_empty:
	lbu $t1, 0($a1)
	beqz $t1, strcmp_same_empty
	#calculate length of str2
	li $v0, -1
		strcmp_len_str2_loop:
	addi $a1, $a1, 1	#move to the next char
	lbu $t1, 0($a1)								#t1 holds characters
	beqz $t1, strcmp_end
	addi $v0, $v0, -1				
	j strcmp_len_str2_loop
	
	#str2 = null
	strcmp_str2_empty:
	li $v0, 1
		strcmp_len_str1_loop:
	addi $a0, $a0, 1
	lbu $t0, 0($a0)
	beqz $t0, strcmp_end
	addi $v0, $v0, 1
	j strcmp_len_str1_loop
	
	strcmp_same_empty:
	li $v0, 0	
	
	strcmp_end:
    jr $ra

initialize_hashtable:					###################CHECK OUTPUT WITH JENNIFER #################################
	addi $sp, $sp, -12
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	
	blez $a1, invalid_initialize_hashtable_arg			#invalid capacity arg
	blez $a2, invalid_initialize_hashtable_arg			#invalid element_size_arg
	
	#set capacity, size, elem_size arg
	sw $a1, 0($a0)
	sw $zero, 4($a0)
	sw $a2, 8($a0)
	
	#fill struct elements to all 0
	mul $t0, $a1, $a2									#t0 = counter = capacity*element_size
	li $v0, 0											#initialize_hashtable = valid initiation
	addi $a0, $a0, 12
	
	initialize_hastable_loop:
	beqz $t0, initialize_hashtable_end					#jump out of loop
	sb $zero, 0($a0)									#store 0 into hashtable
	addi $a0, $a0, 1
	addi $t0, $t0, -1									#decrease counter
	j initialize_hastable_loop
	
	invalid_initialize_hashtable_arg:
	li $v0, -1
	
	initialize_hashtable_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
    jr $ra

hash_book:
	addi $sp, $sp, -4
	sw $s0, 0($sp)								
	
	li $s0, 0									#s0 = all ascii values added
	#loop isbn till null
	hash_book_loop_isbn:
	lbu $t0, 0($a1)
	beqz $t0, hash_book_loop_isbn_done
	add $s0, $s0, $t0
	addi $a1, $a1, 1
	j hash_book_loop_isbn
	
	#value of all ascii % capacity
	hash_book_loop_isbn_done:
	lw $t0, 0($a0) 								#t0 = capacity of hashtable
	div $s0, $t0
	mfhi $v0
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
    jr $ra

get_book:
	addi $sp, $sp, -24
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0									#s0 = starting addr of books
	move $s1, $a1									#s1 = string isbn
	
	jal hash_book
	#v0 = first index to check
	move $s3, $v0									#s3 = index of elements
	li $s4, 0										#s4 = number of elements checked
	
	lw $a0, 8($s0)									#a0 = element_size
	mul $a0, $v0, $a0								#a0 = index * element_size
	addi $a0, $a0, 12 								
	
	add $s2, $s0, $a0								#s2 = starting addr of element[index]
	
	get_book_loop:
	lw $t0, 0($s0)									#t0 = capacity
	beq $s4, $t0, get_book_not_found
	addi $s4, $s4, 1
	lb $t0, 0($s2)									#t0 = value of 1 byte of isbn
	beqz $t0, get_book_not_found					#element[index] is empty
	bltz $t0, get_book_loop_contd
	
	move $a0, $s1
	move $a1, $s2
	jal strcmp
	
	beqz $v0, get_book_found
		get_book_loop_contd:
	addi $s3, $s3, 1								#increase index
	lw $t0, 0($s0)									#t0 = capacity
	beq $s3, $t0, get_book_reset_index				#reset index back to 0 and s2 = bookaddr + 12
	lw $t0, 8($s0)				
	add $s2, $s2, $t0								#s2 = next addr of next index
	j get_book_loop
	
	## small function thingy for loop##
	get_book_reset_index:
	li $s3, 0
	addi $s2, $s0, 12								#s2 = starting addr of element[0]
	j get_book_loop
	####################################################################
	
	get_book_found:
	move $v0, $s3
	j get_book_end
	
	get_book_not_found:
	li $v0, -1
	
	get_book_end:
	move $v1, $s4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
    jr $ra

add_book:
	addi $sp, $sp, -28
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	lw $t0, 0($a0)							#t0 = capacity
	lw $t1, 4($a0)							#t1 = size
	beq $t0, $t1, invalid_add_book_args			#size = capacity : hashtable full (cant add new book)
	
	jal get_book
	bgez $v0, add_book_end					#return values from get_book
	
	#call hash_book and try adding from that index and foward
	move $a0, $s0
	move $a1, $s1
	jal hash_book
	
	move $s5, $v0 							#s5 = copy of starting index
	lw $a0, 8($s0)
	mul $a0, $v0, $a0
	addi $a0, $a0, 12
	add $a0, $s0, $a0						#a0 = starting address of element[index]
	li $t1, 0
	
	add_book_loop_open_index:
	addi $t1, $t1, 1
	lb $t0, 0($a0)									#first byte of element[index]
	blez $t0, add_book_loop_open_found				#0 or -1, book can be added at index
	addi $s5, $s5, 1
	lw $t0, 0($s0)
	beq $s5, $t0, add_book_loop_open_reset
	lw $t0, 8($s0)
	add $a0, $a0, $t0
	j add_book_loop_open_index
	
	## little function for loop##
	add_book_loop_open_reset:
	li $s5, 0	
	addi $a0, $s0, 12	
	j add_book_loop_open_index
	###############################
	
	add_book_loop_open_found:
	move $v1, $t1 							#v1 = number of elements accessed !!!!!!!!!!!!!!!!!!! 
											#a0 = starting addr of free element[index]
	lw $t1, 4($s0)
	addi $t1, $t1, 1
	sw $t1, 4($s0)									
	#update isbn
	move $s0, $a0 							#s0 = starting addr of free element[index]
	move $a1, $s1
	li $a2, 13								#t0 = counter to loop isbn
	jal memcpy
	
	move $v0, $s5							#v0 = index of current element 
	
	addi $s0, $s0, 13
	sb $zero, 0($s0)
	addi $s0, $s0, 1
	
	#copying title
	li $t0, 24
	add_book_loop_title:
	lbu $t1, 0($s2)
	beqz $t1, add_book_loop_null_title
	sb $t1, 0($s0)
	addi $t0, $t0, -1
	addi $s2, $s2, 1
	addi $s0, $s0, 1
	bnez $t0, add_book_loop_title
	j add_book_loop_title_done
	
	#if there is less than 24 chars in title
	add_book_loop_null_title:
	sb $zero, 0($s0)
	addi $t0, $t0, -1
	addi $s0, $s0, 1
	bnez $t0, add_book_loop_null_title	
	
	add_book_loop_title_done:
	sb $zero, 0($s0)
	addi $s0, $s0, 1
	
	#copying author
	li $t0, 24
	add_book_loop_author:
	lbu $t1, 0($s3)
	beqz $t1, add_book_loop_null_author
	sb $t1, 0($s0)
	addi $t0, $t0, -1
	addi $s3, $s3, 1
	addi $s0, $s0, 1
	bnez $t0, add_book_loop_author
	j add_book_loop_author_done
	
	add_book_loop_null_author:
	sb $zero, 0($s0)
	addi $t0, $t0, -1
	addi $s0, $s0, 1
	bnez $t0, add_book_loop_null_author
	
	add_book_loop_author_done:
	sb $zero, 0($s0)
	addi $s0, $s0, 1
	#store 0 into times sold
	sw $zero, 0($s0)
	
	j add_book_end
	
	invalid_add_book_args:
	li $v0, -1
	li $v1, -1
	
	add_book_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

delete_book:
	addi $sp, $sp, -32
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	
	move $s0, $a0
	move $s1, $a1
	jal get_book
	
	bltz $v0, delete_book_end
	#-1 to size
	lw $t0, 4($s0)
	addi, $t0, $t0, -1
	sw $t0, 4($s0)
	#convert element to -1
	lw $t0, 8($s0)
	mul $s1, $v0, $t0
	addi $s1, $s1, 12
	add $s0, $s0, $s1
	
	li $t1, -1
	delete_book_loop:
	sb $t1, 0($s0)
	addi $s0, $s0, 1
	addi $t0, $t0, -1
	bnez $t0, delete_book_loop
	
	delete_book_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
    jr $ra

hash_booksale:
	addi $sp, $sp, -4
	sw $s0, 0($sp)								
	
	li $s0, 0											#t0 = all ASCII numbers and customer_id
	
	#loop isbn till null
	hash_booksale_loop_isbn:
	lbu $t0, 0($a1)
	beqz $t0, hash_booksale_loop_isbn_done
	add $s0, $s0, $t0
	addi $a1, $a1, 1
	j hash_booksale_loop_isbn
	
	hash_booksale_loop_isbn_done:
	move $t0, $a2
	li $t1, 10
	
	hash_booksale_loop_customerID:
	div $t0, $t1
	mflo $t0
	mfhi $t2
	add $s0, $s0, $t2
	beqz $t0, hash_booksale_calculate_value
	j hash_booksale_loop_customerID
	
	hash_booksale_calculate_value:
	lw $t0, 0($a0)
	div $s0, $t0
	mfhi $v0
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
    jr $ra

is_leap_year:
	addi $sp, $sp, -8
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	
	li $s0, 1582
	blt $a0, $s0, invalid_is_leap_year_args
	li $v0, 1
	
	#check if year is centenary first
	li $s0, 100
	div $a0, $s0
	mfhi $s1
	beqz $s1, is_current_leap_year_centenary
	#then check if leap year is divisible by 4
	li $s0, 4
	div $a0, $s0										#doesn't change the value of s0, t1
	mfhi $s1											#s1 = remainder
	beqz $s1, is_leap_year_end							#remainder is equal 0	
	
	is_leap_year_loop:
	li $v0, 0
	
	is_leap_year_loop_find_next_leap:
	addi $v0, $v0, -1									#decrease counter of v0
	addi $a0, $a0, 1									#move to check if next year is a leap year
		#check if leap year is centenary
	li $s0, 100
	div $a0, $s0
	mfhi $s1
	beqz $s1, is_leap_year_centenary
		#check if year is divisible by 4
	li $s0, 4
	div $a0, $s0										#doesn't change the value of s0, t1
	mfhi $s1											#s1 = remainder
	beqz $s1, is_leap_year_end							#remainder is equal 0	
	j is_leap_year_loop_find_next_leap
	
	#this one is for looping where a0 wasnt a leap year at first
	is_leap_year_centenary:
	li $s0, 400
	div $a0, $s0										#doesn't change the value of s0, t1
	mfhi $s1											#s1 = remainder
	beqz $s1, is_leap_year_end							#remainder is equal 0
	j is_leap_year_loop_find_next_leap
	
	#a0 is centenary and a leap year
	is_current_leap_year_centenary:
	li $s0, 400
	div $a0, $s0										#doesn't change the value of s0, t1
	mfhi $s1											#s1 = remainder
	beqz $s1, is_leap_year_end							#remainder is equal 0
	j is_leap_year_loop
	
	invalid_is_leap_year_args:
	li $v0, 0
	
	is_leap_year_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
    jr $ra

datestring_to_num_days:
	addi $sp, $sp, -28
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	li $s0, 0
	li $t8, 4
	datestring_to_num_days_convert_start_year:
	lbu $t0, 0($a0)
	addi $t0, $t0, -48
	li $t9, 10
	mul $s0, $s0, $t9
	add $s0, $s0, $t0
	addi $a0, $a0, 1
	addi $t8, $t8, -1
	bnez $t8, datestring_to_num_days_convert_start_year
	
	addi $a0, $a0, 1
	li $s1, 0 
	li $t8, 2
	datestring_to_num_days_convert_start_month:
	lbu $t0, 0($a0)
	addi $t0, $t0, -48
	li $t9, 10
	mul $s1, $s1, $t9
	add $s1, $s1, $t0
	addi $a0, $a0, 1
	addi $t8, $t8, -1
	bnez $t8, datestring_to_num_days_convert_start_month
	
	addi $a0, $a0, 1
	li $s2, 0
	li $t8, 2
	datestring_to_num_days_convert_start_day:
	lbu $t0, 0($a0)
	addi $t0, $t0, -48
	li $t9, 10
	mul $s2, $s2, $t9
	add $s2, $s2, $t0
	addi $a0, $a0, 1
	addi $t8, $t8, -1
	bnez $t8, datestring_to_num_days_convert_start_day
	move $s3, $a1
	
	#s0 = start year
	#s1 = start month
	#s2 = start day
	#s3 = end_date string
	li $s5, 0
	j dtnd_calculate_days
	
	dtnd_calculate_days_return:
	#be careful
	li $s0, 0
	li $t8, 4
	datestring_to_num_days_convert_end_year:
	lbu $t0, 0($s3)
	addi $t0, $t0, -48
	li $t9, 10
	mul $s0, $s0, $t9
	add $s0, $s0, $t0
	addi $s3, $s3, 1
	addi $t8, $t8, -1
	bnez $t8, datestring_to_num_days_convert_end_year
	
	addi $s3, $s3, 1
	li $s1, 0 
	li $t8, 2
	datestring_to_num_days_convert_end_month:
	lbu $t0, 0($s3)
	addi $t0, $t0, -48
	li $t9, 10
	mul $s1, $s1, $t9
	add $s1, $s1, $t0
	addi $s3, $s3, 1
	addi $t8, $t8, -1
	bnez $t8, datestring_to_num_days_convert_end_month
	
	addi $s3, $s3, 1
	li $s2, 0
	li $t8, 2
	datestring_to_num_days_convert_end_day:
	lbu $t0, 0($s3)
	addi $t0, $t0, -48
	li $t9, 10
	mul $s2, $s2, $t9
	add $s2, $s2, $t0
	addi $s3, $s3, 1
	addi $t8, $t8, -1
	bnez $t8, datestring_to_num_days_convert_end_day
	#s0 = end year
	#s1 = end month
	#s2 = end day
	move $s3, $s4
	#s3 = start date number of days from 1600-01-01
	li $s5, 1
	j dtnd_calculate_days
	
	dtnd_calculate_difference:
	sub $v0, $s4, $s3
	bgez $v0, datestring_to_num_days_end
	li $v0, -1
	
	datestring_to_num_days_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra
    
    dtnd_calculate_days:
    li $t0, 1600
    sub $t9, $s0, $t0								#t9 = end- start
    li $t0, 4
    div $t9, $t0
    mflo $t8 										#t8 = potential leap years
    
    li $t0, 1600
    li $t1, 400
    div $t0, $t1
    mfhi $t7
    add $t7, $t7, $t9								
    div $t7, $t1
    mflo $t7 										#t7 = difference
    
    li $t1, 100
    div $t0, $t1
    mfhi $t6
    add $t6, $t6, $t9
    div $t6, $t1
    mflo $t6 										#t6 = other difference
    
    sub $t7, $t6, $t7
    sub $t8, $t8, $t7								#t8 = number of leap years between two years
    addi $t8, $t8, 1
	
    li $t0, 366
    mul $s4, $t0, $t8 								#s4 = number of days between date and 1600-01-01
    
    sub $t9, $t9, $t8
    li $t0, 365
    mul $t8, $t9, $t0
    add $s4, $s4, $t8								#s4 = adds the number of days in nonleap year
    
    #add number of days in month
    li $t0, 1				#jan
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 31
    
    addi $t0, $t0, 1		#feb
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 28
    
    addi $t0, $t0, 1		#march
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 31
    
    addi $t0, $t0, 1		#april
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 30
    
    addi $t0, $t0, 1		#may
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 31
    
    addi $t0, $t0, 1		#june
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 30
    
    addi $t0, $t0, 1		#july
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 31
    
    addi $t0, $t0, 1		#aug
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 31
    
    addi $t0, $t0, 1		#sept
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 30
    
    addi $t0, $t0, 1		#oct
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 31
    
    addi $t0, $t0, 1		#nov
    beq $s1, $t0, dtnd_calculate_days_day
    addi $s4, $s4, 30
    
    dtnd_calculate_days_day: #add number of days to current day
    add $s4, $s4, $s2
    addi $s4, $s4, -1
    move $a0, $s0
    jal is_leap_year
    bltz $v0, dtnd_calculate_days_finished				#s4 = number of days since 1600-01-01
    li $t0, 2
    bgt $s1, $t0, dtnd_calculate_days_finished
    addi $s4, $s4, -1
    
    dtnd_calculate_days_finished:
    beqz $s5, dtnd_calculate_days_return
    j dtnd_calculate_difference

sell_book:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, -32
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $ra, 28($sp)
	
	move $s0, $a0 #s0 = addr of sales
	move $s1, $a1 #s1 = addr of books
	move $s2, $a2 #s2 = addr of isbn
	move $s3, $a3 #s3 = word customerid
	move $s4, $t0 #s4 = addr of sale_date
	move $s5, $t1 #s5 = word sale_price
	
	#check if sales full
	lw $t0, 0($a0)
	lw $t1, 4($a0)
	beq $t0, $t1, sell_book_sales_full
	
	#check if books exists in books
	move $a0, $s1
	move $a1, $s2
	jal get_book
	bltz $v0, sell_book_books_dne
	#increment times_sold in corresponding book
	lw $t0, 8($s1)
	mul $a0, $t0, $v0
	addi $a0, $a0, 12 
	add $a0, $a0, $s1 #a0 = starting index of element[index]
	addi $a0, $a0, 64 #moves a0 to times sold
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	
	#call hash_booksale to get starting index
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	jal hash_booksale
	
	move $s6, $v0									#s6 = copy of starting index
	lw $a0, 8($s0)
	mul $a0, $v0, $a0
	addi $a0, $a0, 12
	add $a0, $s0, $a0								#a0 = starting addr of element[index]
	
	li $t1, 0
	
	sell_book_loop_open_index:
	addi $t1, $t1, 1
	lb $t0, 0($a0)
	beqz $t0, sell_book_loop_open_found
	addi $s6, $s6, 1
	lw $t0, 0($s0)
	beq $s6, $t0, sell_book_loop_open_reset
	lw $t0, 8($s0)
	add $a0, $a0, $t0
	j sell_book_loop_open_index
	
	sell_book_loop_open_reset:
	li $s6, 0
	addi $a0, $s0, 12
	j sell_book_loop_open_index
	
	sell_book_loop_open_found:
	move $v1, $t1							#v1 = number of elements accessed
	#copy things in to elements[index] of sales
	
	#increases size of sales struct
	lw $t1, 4($s0)
	addi $t1, $t1, 1
	sw $t1, 4($s0)
	
	#update isbn
	move $s0, $a0									#s0 = starting addr of free element[index]
	move $a1, $s2
	li $a2, 13
	jal memcpy
	
	addi $s0, $s0, 13
	sb $zero, 0($s0)
	addi $s0, $s0, 3 			#move after null (14) and 2 byte padding
	
	#customer_id
	sw $s3, 0($s0)
	addi $s0, $s0, 4
	
	#sale date date_to_num_days: figure out how to make 1600-01-01 string 
	addi $sp, $sp, -12
	li $t0, '1'
	sb $t0, 0($sp)
	li $t0, '6'
	sb $t0, 1($sp)
	li $t0, '0'
	sb $t0, 2($sp)
	li $t0, '0'
	sb $t0, 3($sp)
	li $t0, '-'
	sb $t0, 4($sp)
	li $t0, '0'
	sb $t0, 5($sp)
	li $t0, '1'
	sb $t0, 6($sp)
	li $t0, '-'
	sb $t0, 7($sp)
	li $t0, '0'
	sb $t0, 8($sp)
	li $t0, '1'
	sb $t0, 9($sp)
	
	#sp = address of start date
	move $a0, $sp
	move $a1, $s4
	jal datestring_to_num_days
	
	addi $sp, $sp, 12
	sw $v0, 0($s0)	
	addi $s0, $s0, 4
	move $v0, $s6							#v0 = index of current element
	#sale price
	sw $s5, 0($s0)
	j sell_book_end
	
	sell_book_sales_full:
	li $v0, -1
	li $v1, -1
	j sell_book_end
	
	sell_book_books_dne:
	li $v0, -2
	li $v1, -2
	
	sell_book_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
    jr $ra

compute_scenario_revenue:
	addi $sp, $sp, -20
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	li $v0, 0
	move $s0, $a0
	li $s4, 1
	li $s1, 0x1
	sllv $s1, $s1, $a1
	li $s2, 0
	addi $s3, $a1, -1
	
	compute_scenario_revenue_loop:
	beqz $a1, compute_scenario_revenue_end
	srl $s1, $s1, 1
	and $t0, $s1, $a2
	beqz $t0, compute_scenario_revenue_calulate_min
	#curent bit is 1 (get rightmost)
	li $t0, 28
	mul $a0, $s3, $t0
	add $a0, $a0, $s0						#a0 = starting index of rightmost sales element
	lw $t0, 24($a0)							#sale_price offset is 24
	mul $t0, $t0, $s4
	add $v0, $v0, $t0						#v0 = adds the sum of price*counter
	
	addi $s4, $s4, 1						#increase counter
	addi $a1, $a1, -1						#decrease num sales
	addi $s3, $s3, -1						#decrease max by 1	
	j compute_scenario_revenue_loop
	
	compute_scenario_revenue_calulate_min:
	#current bit is 0 (get leftmost)
	li $t0, 28
	mul $a0, $s2, $t0
	add $a0, $a0, $s0						#a0 = starting index of leftmost sales element
	
	lw $t0, 24($a0)							#sale_price offset is 24
	mul $t0, $t0, $s4
	add $v0, $v0, $t0						#v0 = adds the sum of price*counter
	
	addi $s4, $s4, 1						#increase counter
	addi $a1, $a1, -1						#decrease num sales
	addi $s2, $s2, 1						#decrease max by 1	
	j compute_scenario_revenue_loop
	
	compute_scenario_revenue_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20
    jr $ra

maximize_revenue:
	addi $sp, $sp, -20
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	li $s2, 0
	li $s3, 0x1
	sllv $s3, $s3, $a1
	addi $s3, $s3, -1
	
	maximize_revenue_loop:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s3
	jal compute_scenario_revenue
	
	ble $v0, $s2, maximize_revenue_loop_contd
	move $s2, $v0
		maximize_revenue_loop_contd:
	beqz $s3, maximize_revenue__end
	addi $s3, $s3, -1	
	j maximize_revenue_loop
	
	maximize_revenue__end:
	move $v0, $s2
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
