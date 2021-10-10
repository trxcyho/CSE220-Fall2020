# erase this line and type your first and last name here in a comment
# erase this line and type your Net ID here in a comment (e.g., jmsmith)
# erase this line and type your SBU ID number here in a comment (e.g., 111234567)

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

############################## Do not .include any files! #############################

.text
strlen:
	#preserve s register
	addi $sp, $sp, -4			
	sw $s0, 0($sp)
	
	#logic
	li $v0, 0
		str_len_loop:
	lbu $s0, 0($a0)								#s0 holds characters
	beqz $s0, str_len_loop_done
	addi $v0, $v0, 1	
	addi $a0, $a0, 1							#move to the next char
	j str_len_loop
	
	str_len_loop_done:					
	lw $s0, 0($sp)								#load back values of s register
	addi $sp, $sp, 4
    jr $ra

index_of:
	#preserve registers	
	addi $sp, $sp, -8
	sw $s0, 0($sp)								
	sw $ra, 4($sp)
	
	bltz $a2, char_not_found					#if index is less than 0, then -1 
	
	move $s0, $a0								#call strlen
	jal strlen
	move $a0, $s0								#move $a0 back to starting address
	
	bge $a2, $v0, char_not_found												
	add $a0, $a0, $a2							#shifts current address up to labeled index
	
	search_char_loop:
	lbu $s0, 0($a0)
	beq $s0, $a1, char_found
	beq $a2, $v0, char_not_found				#if index = len of str, then char not found
	addi $a2, $a2, 1							#goes to next index
	addi $a0, $a0, 1							#next char
	j search_char_loop	
	
	char_not_found:
	li $v0, -1
	j index_of_end
		char_found:
	move $v0, $a2
	
		index_of_end:	
	lw $s0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
    jr $ra

to_lowercase:
	#preserve registers	
	addi $sp, $sp, -8								
	sw $s1, 0($sp)
	sw $s2, 4($sp)	
	
	li $v0, 0									#v0 = how many uppercase changed
	to_lowercase_loop:  
	lbu $s1, 0($a0)								#get first char 
	beqz $s1, to_lowercase_end					#looped through the str
	li $s2, 'A'
	bge $s1, $s2, check_if_uppercase
		not_uppercase:
	addi $a0, $a0, 1							#next char
	j to_lowercase_loop	
	
	#compare to see if uppercase
	check_if_uppercase:
	li $s2, 'Z'
	bgt $s1, $s2, not_uppercase
	addi $s1, $s1, 32 							#converts uppercase to lowercase
	sb $s1, 0($a0)
	addi $v0, $v0, 1							#uppercase changed
	j not_uppercase	
	
		to_lowercase_end:
	lw $s1, 0($sp)
	lw $s2, 4($sp)	
	addi $sp, $sp, 8
    jr $ra

generate_ciphertext_alphabet:
	#preseve registers
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	move $s0, $a0								#copy address of ciphertxt

	li $s2, 63									#loop counter
	#initialize ciphertext to all null
	initialize_cipher_0:
	beqz $s2, generate_ciphertxt
	li $s1, 0
	sb $s1, 0($a0)
	addi $a0, $a0, 1
	addi $s2, $s2, -1
	j initialize_cipher_0
	
	generate_ciphertxt:
	move $a0, $s0								#s0 = a0 = whole ciphertext
	move $s1, $a1								#s1 = keyphrase
	li $s2, 0									#s2 = # of unique chars
	move $s5, $s0 								#s5 = updated char ciphertxt 
	
	#move unique char from keyphrase to cipher
		loop_keyphrase:
	lbu $s3, 0($s1)								#char from keyphrase
	beqz $s3, add_lowercase_to_cipher			#stop if end of keyphrase
	
	#check if char is number and letter
	li $s4, '0'
	blt $s3, $s4, loop_keyphrase_contd			#if less than '0'
	li $s4, 'z'
	bgt $s3, $s4, loop_keyphrase_contd			#greater than 'z'
	li $s4, 'a'
	bge $s3, $s4, check_if_unique				#char is lowercase
	li $s4, '9'
	ble $s3, $s4, check_if_unique				#char is number
	li $s4, 'A'
	blt $s3, $s4, loop_keyphrase_contd			#not valid char
	li $s4, 'Z'
	ble $s3, $s4, check_if_unique				#char is uppercase
	j loop_keyphrase_contd
	
		check_if_unique:
	move $a0, $s0								#ciphertxt
	move $a1, $s3								#char to find
	li $a2, 0									#when checking index_of, starting index always 0
	jal index_of
	 
	bltz $v0, add_char_to_ciphertxt
		loop_keyphrase_contd:
	addi $s1, $s1, 1							#next char
	j loop_keyphrase
	
	add_char_to_ciphertxt: #$s3 is holding a unique characters
	sb $s3, 0($s5)								#moves char into ciphertext
	addi $s5, $s5, 1							#goes to next null of cipher
	addi $s2, $s2, 1
	j loop_keyphrase_contd	
	
	#add missing lowercase letters to cipher
	add_lowercase_to_cipher:
	li $s1, 'a'									#starting character
	li $s3, 'z'
	
	#starting loop
	check_for_lowercase_letters_to_add:
	bgt $s1, $s3, add_uppercase_to_cipher		#iterated through all lowercase letters
	move $a0, $s0
	move $a1, $s1
	li $a2, 0									#when checking index_of, starting index always 0
	jal index_of								#check if current letter is in cipher
	
	bgez $v0, next_lower_case_letter
	sb $s1, 0($s5)					
	addi $s5, $s5, 1							#nect place value in cipher
	
	next_lower_case_letter:
	addi $s1, $s1, 1 							#iterates to next char
	j check_for_lowercase_letters_to_add
	
	#add missing uppercase letters to cipher
	add_uppercase_to_cipher:
	li $s1, 'A'
	li $s3, 'Z'
	
	#starting loop
	check_for_uppercase_to_add:
	bgt $s1, $s3, add_numbers_to_cipher
	move $a0, $s0
	move $a1, $s1
	li $a2, 0									#when checking index_of, starting index always 0
	jal index_of
	
	bgez $v0, next_upper_case_letter
	sb $s1, 0($s5)
	addi $s5, $s5, 1	
	
	next_upper_case_letter:
	addi $s1, $s1, 1
	j check_for_uppercase_to_add
	
	#add missing numbers to cipher
	add_numbers_to_cipher:
	li $s1, '0'
	li $s3, '9'
	
	#starting loop
	check_for_numbers_to_add:
	bgt $s1, $s3, cipher_text_alphabet_end
	move $a0, $s0
	move $a1, $s1
	li $a2, 0
	jal index_of
	
	bgez $v0, next_number
	sb $s1, 0($s5)
	addi $s5, $s5, 1
	
	next_number:
	addi $s1, $s1, 1
	j check_for_numbers_to_add

	#end of the function
	cipher_text_alphabet_end:
	move $v0, $s2
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

count_lowercase_letters:
	#preseve registers
	addi $sp, $sp, -12
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	
	#initialize counts to all 0
	move $s0, $a0
	li $s1, 26
	li $v0, 0
	
	count_lowercase_initialize_counts:
	beqz $s1, count_lc_message_loop
	li $s2, 0
	sw $s2, 0($a0)
	addi $a0, $a0, 4
	addi $s1, $s1, -1
	j count_lowercase_initialize_counts
	
	count_lc_message_loop:
	lbu $s1, 0($a1) 							#gets the char from msg
	beqz $s1, count_lc_end						#ends loop when hitting null terminator
	li $s2, 'a'
	blt $s1, $s2, count_lc_next_char_in_message #less than 'a'
	li $s2, 'z'
	bgt $s1, $s2, count_lc_next_char_in_message
	#s1 is lowercase
	move $a0, $s0								#return a0 back to original counts address
	li $s2, -97
	add $s1, $s1, $s2							#offset to tell you which index in counts to increase
	sll $s1, $s1, 2								#multiply it by 4
	add $a0, $s1, $a0							#address of counts[char]
	lw $s2, 0($a0)
	addi $s2, $s2, 1
	sw $s2 0($a0)
	addi $v0, $v0, 1							#increase counter for lowercase letter	
		count_lc_next_char_in_message:
	addi $a1, $a1, 1
	j count_lc_message_loop
	
	count_lc_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	addi $sp, $sp, 12
    jr $ra

sort_alphabet_by_count:
	#preseve registers
	addi $sp, $sp, -24							
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	#initialize sort alpha[26] = null
	move $s0, $a0								#s0 store sort alphabet starting addr
	addi $a0, $a0, 26
	li $s1, 0
	sb $s1, 0($a0)								#make sort alpha[26] = 0
	
	move $a0, $s0								#a0 = addr of sort alpha
	li $s0, 26
#loop 26 for 26 letters
	sort_alphabet_by_counts_loop:
	beqz $s0, sort_alphabet_by_counts_end		#if counter reach 0, end of function
	
	move $s1, $a1								#reset s1 to counts starting addr
	li $s2, -1									#reset s2 since s2 will hold highest number
	li $s5, 26									#counter for looping through counts array
		#loop through counts to get highest number
		loop_through_counts:
		lw $s3, 0($s1)								#s3 = first number from counts array
		ble $s3, $s2, next_word_from_count			#go to next number in array
		move $s2, $s3							#s1 = highest number
		move $s4, $s1							#s4 = address of highest number from counts
			next_word_from_count:
		addi $s1, $s1, 4						#iterates to the next number
		addi $s5, $s5, -1						#decrease counter for counts loop
		bnez $s5, loop_through_counts			#if counter = 0, continue
	
	#put -1 in address of highest count 
	li $s2, -1
	sw $s2, 0($s4)
	#find index of highest count
	sub $s4, $s4, $a1							#original - highest
	srl $s4, $s4, 2								#divide by 4 to get index
	
	addi $s4, $s4, 97 							#add to get character of that index
	sb $s4, 0($a0) 								#store that char in sort_alphabet
	addi $a0, $a0, 1							#next char in sort_alphabet
	addi $s0, $s0, -1							#decrease counter for sorting alphabet
	j sort_alphabet_by_counts_loop
	
	sort_alphabet_by_counts_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	addi $sp, $sp, 24
    jr $ra							

generate_plaintext_alphabet:	
	#preseve registers
	addi $sp, $sp, -28							
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)

	#overwrite plaintext alpha[62] to 0
	move $s0, $a0									#s0 = plaintext alpha starting addr
	addi $a0, $a0, 62
	li $s1, 0
	sb $s1, 0($a0)
	
#generate plaintext alphabet
	move $s5, $a1									#s5 = sorted alphabet starting addr
	li $s1, 'a'										#starting char to look for
	li $s2, 'z'
	
	generate_plaintext_alphabet_loop:
	#call index_of
	move $a0, $s5									#a0 = sorted alpha
	move $a1, $s1 									#a1 = letter from alphabet to find
	li $a2, 0 										#a2 = start from 0 index
	jal index_of
	
	#use v0 to determine how many times to loop into plaintext
	li $s3, 9
	li $s4, 1
	bge $v0, $s3, overwrite_plaintext_n_times
	sub $s4, $s3, $v0
	
	overwrite_plaintext_n_times:					#s4 = number of times to loop
	sb $s1, 0($s0)
	addi $s0, $s0, 1								#next place in plaintext
	addi $s4, $s4, -1
	bnez $s4, overwrite_plaintext_n_times
	
	addi $s1, $s1, 1								#moves s1 to next character
	ble $s1, $s2, generate_plaintext_alphabet_loop
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

encrypt_letter:
	#preseve registers 				
	addi $sp, $sp, -28							
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	
	#check if a0 is lowercase and a1 is non-negative (v- = -1)
	li $s0, 'a'
	li $v0, -1
	blt $a0, $s0, encrypt_letter_end
	li $s0, 'z'
	bgt $a0, $s0, encrypt_letter_end
	bltz $a1, encrypt_letter_end
	
	move $s0, $a0 								#makes a copy of all the args to call index_of
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	#get index for ciphertextalpha
	move $a0, $s2			
	move $a1, $s0
	li $a2, 0
	jal index_of
	
	add $s2, $s2, $v0 							#moves plaintext to first index of letter
	addi $s2, $s2, 1							#moves addr to check next char
	li $s4, 0									#s4 = k
	
	loop_check_for_k:							
	lbu $s5, 0($s2) 							#s5 = next character
	bne $s5, $s0, calculate_index_to_get_from_cipher
	addi $s4, $s4, 1						
	addi $s2, $s2, 1
	j loop_check_for_k
	
	calculate_index_to_get_from_cipher:
	addi $s4, $s4, 1							#s4 = k+1
	div $s1, $s4
	mfhi $s4									#store remainder in s4 (index mod k+1)
	add $s4, $s4, $v0							#index from ciphertext
	
	add $s3, $s3, $s4							#cipher address plus index
	lbu $v0, 0($s3)
		
	encrypt_letter_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

encrypt:											
	#preseve registers
	addi $sp, $sp, -40							
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	sw $fp, 36($sp)
	move $fp, $sp									#fp(framepointer) at location to offset back
	
	move $s0, $a0									# s0 = ciphertext
	move $s1, $a1									# s1 = plaintext
	move $s2, $a2									# s2 = keyphrase
	move $s3, $a3									# s3 = corpus
	
	#step 1 call to_lowercase on plaintext and corpus
	move $a0, $s1									#plaintext to lowercase
	jal to_lowercase
	
	move $a0, $s3									#corpus to lowercase
	jal to_lowercase
	
	#step 2 and step 3 get counts of each lowercase letter
	addi $sp, $sp, -104								#save memory for counts(counts addr = sp)(26*4 = 104)
	move $a0, $sp
	move $a1, $s3
	jal count_lowercase_letters
	
	move $s6, $sp 									#s6 = begin addr for counts array
	#step 4 and 5 sort alphabet by count
	addi $sp, $sp, -28								#28 makes it word aligned
	move $a0, $sp									#sp = lowercase_letters
	move $a1, $s6									#counts array as arg 2
	jal sort_alphabet_by_count
	
	move $s6, $sp									#s6 = lowercase letters
	#step 6 and 7: generate plaintext alphabet
	addi $sp, $sp, -64
	move $a0, $sp
	move $a1, $s6
	jal generate_plaintext_alphabet
	
	move $s6, $sp							#s6 = plaintext (aaaaabcdeeeeeeeeefghhhhhhhiijklmnnnnoooooopqrsssttttttttuvwxyz)
	#step 8, 9: get ciphertext alphabet 
	addi $sp, $sp, -64
	move $a0, $sp
	move $a1, $s2
	jal generate_ciphertext_alphabet		#sp = ciphertext (Ilhaveyouknwtsbdmcrif20gjpqxzABCDEFGHJKLMNOPQRSTUVWXYZ13456789)
	
	#step 10, 11: encrypt each letter
	move $s5, $sp 							#s5 = ciphertext alphabet
	li $s3, 0								#s3 = return for v0
	li $s4, 0								#s4 = return for v1
	li $s7, 0								#s7 = letter index
	
	encrypt_helper_loop:
	lbu $s2, 0($s1)							#get letter from plaintext
	beqz $s2, null_terminate_cipher
	addi $s4, $s4, 1
	li $t9, 'a'
	blt $s2, $t9, append_char_to_ciphertext
	li $t9, 'z'
	bgt $s2, $t9, append_char_to_ciphertext
			#s2 = lowercase letter
	addi $s4, $s4, -1
	addi $s3, $s3, 1
			#get encrypted letter
	move $a0, $s2
	move $a1, $s7
	move $a2, $s6
	move $a3, $s5
	jal encrypt_letter
	move $s2, $v0
		append_char_to_ciphertext:
	sb $s2, 0($s0)
	addi $s1, $s1, 1
	addi $s0, $s0, 1
	addi $s7, $s7, 1
	j encrypt_helper_loop
	
	null_terminate_cipher:
	li $t9, 0
	sb $t9, 0($s0)
	
	move $v0, $s3
	move $v1, $s4
	
	move $sp, $fp									#deallocate all the memory added to stack pointer
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	lw $fp, 36($sp)
	addi $sp, $sp, 40
    jr $ra

decrypt:											
	#preseve registers
	addi $sp, $sp, -36							
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)	
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)
	sw $s6, 28($sp)
	sw $fp, 32($sp)
	move $fp, $sp									#fp(framepointer) at location to offset back
	
	move $s0, $a0									#s0 = plaintext 
	move $s1, $a1									#s1 = ciphertext 
	move $s2, $a2									#s2 = keyphrase
	move $s3, $a3									#s3 = corpus
	
	#step1: to lowercase(corpus)
	move $a0, $s3
	jal to_lowercase
	
	#step 2+3: make counts array
	addi $sp, $sp, -104								#allocate space for counts array 
	move $a0, $sp									#pass in counts addr
	move $a1, $s3									#pass in the corpus
	jal count_lowercase_letters
	
	move $s4, $sp 									#s4 = counts array addr
	#step 4+5: sort alphabet by count
	addi $sp, $sp, -28								#to store the sorted alphabet
	move $a0, $sp									#sorted alpha
	move $a1, $s4
	jal sort_alphabet_by_count
	
	move $s4, $sp
	#step 6+7: plaintext alphabet
	addi $sp, $sp, -64
	move $a0, $sp
	move $a1, $s4
	jal generate_plaintext_alphabet
	
	move $s4, $sp									#s4 = plaintext alphabet
	#step 8+9: ciphertext alphabet
	addi $sp, $sp, -64
	move $a0, $sp
	move $a1, $s2
	jal generate_ciphertext_alphabet
	
	move $s5, $sp 									#s5 = ciphertext alphabet
	#step 10: decrypt ciphertext
	li $s2, 0										#s2 = v0 (keyphrase not needed anymore)
	li $s3, 0										#s3 = v1 (corpus not needed)
	
	loop_through_ciphertext:
	lbu $s6, 0($s1)
	beqz $s6, null_term_plaintext
	addi $s3, $s3, 1
										#compare to see if char is alphanumerical
	li $t0, '0'
	blt $s6, $t0, append_to_plaintext
	li $t0, '9'
	ble $s6, $t0, get_plaintext_char_to_append
	li $t0, 'A'
	blt $s6, $t0, append_to_plaintext
	li $t0, 'Z'
	ble $s6, $t0, get_plaintext_char_to_append
	li $t0, 'a'
	blt $s6, $t0, append_to_plaintext
	li $t0, 'z'
	ble $s6, $t0, get_plaintext_char_to_append
	j append_to_plaintext
	
										#converts char from cipher to char in plaintext
	get_plaintext_char_to_append:
	addi $s2, $s2, 1
	addi $s3, $s3, -1					#to offset if s6 was actually alphanumerical
	move $a0, $s5						#arg0 = ciphertext alpha
	move $a1, $s6						#arg1 = char to be found
	li $a2, 0							#start at index 0
	jal index_of
	add $t0, $s4, $v0					#t0 = addr of plaintext_alpha[index of char]
	lbu $s6, 0($t0)						#s6 = char at plaintext_alpha[char index]
	
		append_to_plaintext:
	sb $s6, 0($s0)				
	addi $s0, $s0, 1					
	addi $s1, $s1, 1
	j loop_through_ciphertext
	
	null_term_plaintext:
	li $t0, 0
	sb $t0, 0($s0)
	move $v0, $s2
	move $v1, $s3
	
	move $sp, $fp									#deallocate all the memory added to stack pointer
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	lw $s6, 28($sp)
	lw $fp, 32($sp)
	addi $sp, $sp, 36
    jr $ra

############################## Do not .include any files! #############################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
