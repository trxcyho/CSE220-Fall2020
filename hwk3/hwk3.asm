# Tracy Ho
# trcho
# 112646529

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text
load_game:
	#preserve registers
	addi $sp, $sp, -28
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)

	move $s0, $a0							#s0 = address of state
	
	#open file
	move $a0, $a1
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	bltz $v0, file_does_not_exist			#otherwise v0 = file descriptor
	move $s1, $v0 							#s1 = file descriptor
	
	addi $sp, $sp, -1 						#buffer to store character						
#read contents of file
	#read number of rows
	li $s3, 0								#s3 = number of rows
	
	read_num_rows_loop:
	li $v0, 14
	move $a0, $s1						
	move $a1, $sp
	li $a2, 1
	syscall
	lbu $s2, 0($sp)
	li $t0, '\r'
	beq $t0, $s2, read_num_rows_loop		#if \r then skip
	li $t0, '\n'
	beq $t0, $s2, append_num_rows			#if \n break loop
	addi $s2, $s2, -48 								#converts s2 ascii value to deciaml
	li $t0, 10
	mul $s3, $s3, $t0						#s3 = s3*10
	add $s3, $s3, $s2	
	j read_num_rows_loop
	
	append_num_rows:
	sb $s3, 0($s0)							#sets game number of rows
	#read number of columns
	li $s3, 0
	
	read_num_cols_loop:
	li $v0, 14
	move $a0, $s1						
	move $a1, $sp
	li $a2, 1
	syscall
	lbu $s2, 0($sp)
	li $t0, '\r'
	beq $t0, $s2, read_num_cols_loop		#if \r then skip
	li $t0, '\n'
	beq $t0, $s2, append_num_cols			#if \n break loop
	addi $s2, $s2, -48 								#converts s2 ascii value to deciaml
	li $t0, 10
	mul $s3, $s3, $t0						#s3 = s3*10
	add $s3, $s3, $s2	
	j read_num_cols_loop
	
	append_num_cols:
	sb $s3, 1($s0)							#sets game number of cols
	
	li $t0, 0								#row counter
	li $t1, -1 								#cols counter
	move $s3, $s0							#s3 = copy of state
	addi $s3, $s3, 5						#moves s3 to grid 
	li $s4, 0								#s4 = number of walls
	li $s5, 0								#s5 = an apple
	li $s6, 0								#s6 = length of snake
	
	read_grid_from_textfile:
	li $v0, 14
	move $a0, $s1						
	move $a1, $sp
	li $a2, 1
	syscall
	lbu $s2, 0($sp)							#reads character into s2
	
	beqz $v0, end_of_grid_from_txtfile
	li $t2, '\r'
	beq $t2, $s2, read_grid_from_textfile		#if \r then skip to next char
	li $t2, '\n'
	beq $t2, $s2, increase_row_count_reset_col_count			#if \n reset row counter and column counter
	sb $s2, 0($s3)
	addi $s3, $s3, 1									#increase to next char for state.grid
	addi $t1, $t1, 1									#increase col counter
		#find out what s2 is
	li $t2, 'a'
	beq $t2, $s2, apple_found_in_textfile
	li $t2, '#'
	beq $t2, $s2, wall_found_in_textfile
	li $t2, '1'
	beq $t2, $s2, snake_h_found_in_textfile
		read_grid_from_textfile_contd:
	li $t2, '.'
	beq $t2, $s2, read_grid_from_textfile
	addi $s6, $s6, 1
	j read_grid_from_textfile
	
#little things for loop "read_grid_from_textfile"#
		#next row, reset col
	increase_row_count_reset_col_count:
	addi $t0, $t0, 1
	li $t1, -1
	j read_grid_from_textfile
		#apple found in textfile
	apple_found_in_textfile:
	addi $s5, $s5, 1
	j read_grid_from_textfile
		#wall found in textfile
	wall_found_in_textfile:
	addi $s4, $s4, 1
	j read_grid_from_textfile
		#append snake head row and snake head col
	snake_h_found_in_textfile:
	sb $t0, 2($s0)
	sb $t1, 3($s0)
	j read_grid_from_textfile_contd
###################################################
	end_of_grid_from_txtfile:
	li $t0, 0
	sb $t0, 0($s3)
	move $v1, $s4
	move $v0, $s5
	sb $s6, 4($s0)						#sets length into state ###############################################################
	addi $sp, $sp, 1						#offset back the buffer used to hold char				
	j load_game_end
	
	file_does_not_exist:
	li $v0, -1
	li $v1, -1
	
	load_game_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	addi $sp, $sp, 28
    jr $ra

get_slot:
	#preserve registers
	addi $sp, $sp, -4
	sw $s0, 0($sp)								
	
	bltz $a1, invalid_get_slot_args
	bltz $a2, invalid_get_slot_args
	lbu $s0, 0($a0) 						#s0 = grids num of rows
	bge $a1, $s0, invalid_get_slot_args
	lbu $s0, 1($a0)							#s0 = grids num of cols
	bge $a2, $s0, invalid_get_slot_args
	
	addi $a0, $a0, 5						#moves adr to start of grid
	mul $s0, $s0, $a1						#s0 = num cols * i
	add $s0, $s0, $a2						# s0 = num cols * i + j
	add $a0, $a0, $s0 						#a0 = addr of grid[i][j]
	lbu $s0, 0($a0)
	
	move $v0, $s0
	j get_slot_end
		
	invalid_get_slot_args:
	li $v0, -1
	
	get_slot_end:
	lw $s0, 0($sp)
	addi $sp, $sp, 4
    jr $ra

set_slot:
#preserve registers
	addi $sp, $sp, -4
	sw $s0, 0($sp)								
	
	bltz $a1, invalid_set_slot_args
	bltz $a2, invalid_set_slot_args
	lbu $s0, 0($a0) 						#s0 = grids num of rows
	bge $a1, $s0, invalid_set_slot_args
	lbu $s0, 1($a0)							#s0 = grids num of cols
	bge $a2, $s0, invalid_set_slot_args
	
	addi $a0, $a0, 5						#moves adr to start of grid
	mul $s0, $s0, $a1						#s0 = num cols * i
	add $s0, $s0, $a2						# s0 = num cols * i + j
	add $a0, $a0, $s0 						#a0 = addr of grid[i][j]
	sb $a3, 0($a0)
	
	move $v0, $a3
	j set_slot_end
	
	invalid_set_slot_args:
	li $v0, -1
	
	set_slot_end:
	lw $s0, 0($sp)
	addi $sp, $sp, 4
    jr $ra

place_next_apple:
	#preserve registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)

	move $s0, $a0								#s0 = state original addr
	move $s1, $a1								#s1 = byte[] apple
	#move $s2, $a2								#s2 = length of apple array######################################
	
	place_next_apple_loop:
	move $a0, $s0
	lbu $a1, 0($s1) 							#first byte row
	lbu $a2, 1($s1)								#second byte col
	jal get_slot
	
	addi $s1, $s1, 2
	li $t0, '.'
	bne $t0, $v0, place_next_apple_loop
	
	addi $s1, $s1, -2
	move $s2, $s1
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	li $a3, 'a'
	jal set_slot
	
	lbu $v0, 0($s2)
	lbu $v1, 1($s2)
	
	li $t0, -1
	sb $t0, 0($s2)
	sb $t0, 1($s2)
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
    jr $ra

find_next_body_part:
	#preserve registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)

	#make sure row and col is valid
	bltz $a1, invalid_find_next_body_part_args
	bltz $a2, invalid_find_next_body_part_args
	lbu $s0, 0($a0) 						#s0 = grids num of rows
	bge $a1, $s0, invalid_find_next_body_part_args
	lbu $s0, 1($a0)							#s0 = grids num of cols
	bge $a2, $s0, invalid_find_next_body_part_args
	
	#make a copy of arguements
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	#check if up is target
	move $a0, $s0
	move $a1, $s1
	addi $a1, $a1, -1
	move $a2, $s2
	jal get_slot
	beq $v0, $s3, target_part_is_up
	
	#check if down is target
	move $a0, $s0
	move $a1, $s1
	addi $a1, $a1, 1
	move $a2, $s2
	jal get_slot
	beq $v0, $s3, target_part_is_down
	
	#check if left is target
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	addi $a2, $a2, -1
	jal get_slot
	beq $v0, $s3, target_part_is_left
	
	#check if right is target
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	addi $a2, $a2, 1
	jal get_slot
	beq $v0, $s3, target_part_is_right
	j invalid_find_next_body_part_args
	
	
	#LOCATION OF TARGET PART#######################################
	target_part_is_up:
	move $v0, $s1
	addi $v0, $v0, -1
	move $v1, $s2
	j find_next_body_part_end
	
	target_part_is_down:
	move $v0, $s1
	addi $v0, $v0, 1
	move $v1, $s2
	j find_next_body_part_end
	
	target_part_is_left:
	move $v0, $s1
	move $v1, $s2
	addi $v1, $v1, -1
	j find_next_body_part_end
	
	target_part_is_right:
	move $v0, $s1
	move $v1, $s2
	addi $v1, $v1, 1
	j find_next_body_part_end
	####################################################################
	
	invalid_find_next_body_part_args:
	li $v0, -1
	li $v1, -1
	
	find_next_body_part_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
    jr $ra

slide_body:
	lw $t0, 0($sp)
	#preserve registers
	addi $sp, $sp, -28
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)

	move $s0, $a0									#make a copy of all the arguements
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	move $s4, $t0
	li $s5, 0										#v0 = s5
	
	#get_slot: make sure head goes to valid space
	lbu $a1, 2($s0)
	add $a1, $a1, $s1 								#a1 = head_row + head row delta
		move $s1, $a1										#s1 = row of new head
	lbu $a2, 3($s0)
	add $a2, $a2, $s2 								#a2 = head_col + head col delta
		move $s2, $a2										#s2 = col of new head
	jal get_slot
	
	li $t0, '.'
	beq $v0, $t0, slide_body_move_snake
	li $t0, 'a'
	beq $v0, $t0, slide_body_place_next_apple
	j invalid_slide_body_args
	
	slide_body_place_next_apple:
	move $a0, $s0
	move $a1, $s3
	move $a2, $s4
	jal place_next_apple	
	li $s5, 1
	
	slide_body_move_snake:
	#change state to update new row and col for head
	sb $s1, 2($s0)
	sb $s2, 3($s0)
	li $s4, '1'
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	move $a3, $s4
	jal set_slot
	
	
		slide_body_move_snake_loop:
		#find the location of that char in the snake body
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $s4
		jal find_next_body_part
		
		bltz $v0, slide_body_end_of_snake
		move $s1, $v0
		move $s2, $v1
			li $t0, '9'
			beq $s4, $t0, slide_body_snake_A
		addi $s4, $s4, 1
			
			slide_body_move_snake_loop_contd:
		#set s4 to location [s1][s2]
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		move $a3, $s4
		jal set_slot
		j slide_body_move_snake_loop
		
	slide_body_snake_A:
	li $s4, 'A'
	j slide_body_move_snake_loop_contd
	
	slide_body_end_of_snake:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	li $a3, '.'
	jal set_slot
	
	move $v0, $s5					
	j slide_body_end
	
	invalid_slide_body_args:
	li $v0, -1
	
	slide_body_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

add_tail_segment:					#######################################################################
	#preserve registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)

	#check and make sure length is under 35
	move $s0, $a0
	li $t0, 35
	lbu $t1, 4($a0)
	beq $t1, $t0, invalid_add_tail_segment_args
	
	#read direction and get location of where to put new tail
	li $t0, 'U'
	beq $a1, $t0, add_tail_segment_up
	li $t0, 'D'
	beq $a1, $t0, add_tail_segment_down
	li $t0, 'L'
	beq $a1, $t0, add_tail_segment_left
	li $t0, 'R'
	beq $a1, $t0, add_tail_segment_right
	j invalid_add_tail_segment_args								#direction char is invalid
	
	#makes s1 = tail's placement row and s2 = tails's placement col ##########
	add_tail_segment_up:
		addi $s1, $a2, -1
		move $s2, $a3
		j check_direction_add_tail_segment
	add_tail_segment_down:
		addi $s1, $a2, 1
		move $s2, $a3		
		j check_direction_add_tail_segment
	add_tail_segment_left:
		move $s1, $a2
		addi $s2, $a3, -1
		j check_direction_add_tail_segment
	add_tail_segment_right:
		move $s1, $a2
		addi $s2, $a3, 1
		j check_direction_add_tail_segment
	###########################################################################
	#get slot of where tail is supposed to be
	check_direction_add_tail_segment:
	move $a1, $s1
	move $a2, $s2
	jal get_slot
	
	li $t0, '.'
	bne $t0, $v0, invalid_add_tail_segment_args
	
	lbu $t0, 4($s0)
	addi $t0, $t0, 1
	sb $t0, 4($s0) 									#add 1 to the length of the snake
	
	li $t1, 9
	bgt $t0, $t1, add_tail_segment_is_letter
	addi $a3, $t0, 48
	j add_tail_segment_update_grid
	
	add_tail_segment_is_letter:
	addi $a3, $t0, 55
	
	add_tail_segment_update_grid:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal set_slot
	
	lbu $v0, 4($s0)
	j add_tail_segment_end
	
	invalid_add_tail_segment_args:
	li $v0, -1

	add_tail_segment_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
    jr $ra

increase_snake_length:
#preserve registers
	addi $sp, $sp, -24
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)

	#save state and direction
	move $s0, $a0								#s0 = state
	move $s1, $a1								#s1 = direction
	
	lbu $s2, 2($s0)								#s2 = row of snake head
	lbu $s3, 3($s0)								#s3 = col of snake head
	
	li $s4, '2' 								#starting char to find 
	increase_snake_length_find_tail_loop:
	#keep calling find_next_body_part until v0 = -1 (keep reference to row and col)
	move $a0, $s0
	move $a1, $s2								#move row and col into find_next_body_part
	move $a2, $s3
	move $a3, $s4
	jal find_next_body_part
	
	bltz $v0, increase_snake_length_tail_found
	move $s2, $v0								#s2 + s3 = new location of next body part
	move $s3, $v1
		li $t0, '9'
		beq $t0, $s4, increase_snake_length_next_body_letter
	addi $s4, $s4, 1
	j increase_snake_length_find_tail_loop
	
	#little branch for finding the location of the tail #############
	increase_snake_length_next_body_letter:
	li $s4, 'A'
	j increase_snake_length_find_tail_loop
	#################################################################
	
	increase_snake_length_tail_found:
	#s2 and s3 = location of tail on grid
	move $t1, $s1
	li $s1, 4																#s1 = counter for loop(in checking all 4 directions)
	li $t0, 'U'
	beq $t0, $t1, increase_snake_length_direction_check_down
	li $t0, 'D'
	beq $t0, $t1, increase_snake_length_direction_check_up
	li $t0, 'L'
	beq $t0, $t1, increase_snake_length_direction_up_check_right
	li $t0, 'R'
	beq $t0, $t1, increase_snake_length_direction_up_check_left
	j invalid_increase_snake_length_args
	
	increase_snake_length_place_tail_loop:
		increase_snake_length_direction_check_up:
			move $a0, $s0
			li $a1, 'U'
			move $a2, $s2
			move $a3, $s3
			jal add_tail_segment
			
			bgez $v0, increase_snake_length_end
			addi $s1, $s1, -1
			beqz $s1, invalid_increase_snake_length_args
		increase_snake_length_direction_up_check_left:
			move $a0, $s0
			li $a1, 'L'
			move $a2, $s2
			move $a3, $s3
			jal add_tail_segment
			
			bgez $v0, increase_snake_length_end
			addi $s1, $s1, -1
			beqz $s1, invalid_increase_snake_length_args
		increase_snake_length_direction_check_down:
			move $a0, $s0
			li $a1, 'D'
			move $a2, $s2
			move $a3, $s3
			jal add_tail_segment
			
			bgez $v0, increase_snake_length_end
			addi $s1, $s1, -1
			beqz $s1, invalid_increase_snake_length_args
		increase_snake_length_direction_up_check_right:
			move $a0, $s0
			li $a1, 'R'
			move $a2, $s2
			move $a3, $s3
			jal add_tail_segment
			
			bgez $v0, increase_snake_length_end
			addi $s1, $s1, -1
			beqz $s1, invalid_increase_snake_length_args
	j increase_snake_length_place_tail_loop
	
	invalid_increase_snake_length_args:
	li $v0, -1
	
	increase_snake_length_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
    jr $ra

move_snake:
#preserve registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)

	move $s0, $a0												#s0= state
	move $s1, $a1												#s1 = direction of snake head
	move $s2, $a2												#s2 = apples[]													
	
	li $t0, 'U'
	beq $s1, $t0, move_snake_up
	li $t0, 'D'
	beq $s1, $t0, move_snake_down
	li $t0, 'L'
	beq $s1, $t0, move_snake_left
	li $t0, 'R'
	beq $s1, $t0, move_snake_right
	j invalid_move_snake_arg
	
	move_snake_up:
	li $a1, -1
	li $a2, 0
	j move_snake_call_slide_body
	move_snake_down:
	li $a1, 1
	li $a2, 0
	j move_snake_call_slide_body
	move_snake_left:
	li $a1, 0
	li $a2, -1
	j move_snake_call_slide_body
	move_snake_right:
	li $a1, 0
	li $a2, 1
	
	move_snake_call_slide_body:
	addi $sp, $sp, -4
	sw $a3, 0($sp)
	move $a3, $s2 
	jal slide_body
	
	addi $sp, $sp, 4 									#deallocate that space
	bltz $v0, invalid_move_snake_arg					#slide body returned -1
	bgtz $v0, move_snake_ate_apple
	li $v1, 1
	j move_snake_end									#slide body returned 0
	
	move_snake_ate_apple:
	move $a0, $s0
	move $a1, $s1
	jal increase_snake_length
	
	bltz, $v0, invalid_move_snake_arg
	li $v0, 100
	li $v1, 1
	j move_snake_end
	
	invalid_move_snake_arg:
	li $v0, 0
	li $v1, -1
	
	move_snake_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
    jr $ra

simulate_game:
#preserve registers
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

	#save important arguments
	move $s0, $a0										#s0 = state			
	move $s1, $a2										#s1 = string directions
	move $s2, $a3										#s2 = num_moves_to_execute
	move $s3, $t0										#s3 = apples[]
	move $s4, $t1										#s4 = apples_length
	
	#call load game
	jal load_game
	bltz $v0, simulate_game_end							#v0 = -1 from load game and v1 = -1 from load game
	li $s5, 0
	li $s6, 0
	bnez $v0, simulate_game_while_loop
		#since v0 = 0(no apple in file), call place_next_apple
	move $a0, $s0										#a0 = state
	move $a1, $s3										#a1 = apples[]
	move $a2, $s4										#a2 = apples_length
	jal place_next_apple
	
	simulate_game_while_loop:
	beqz $s2, simulate_game_while_loop_done				# no more moves
	lbu $t0, 4($s0)
	li $t1, 35
	beq $t0, $t1, simulate_game_while_loop_done			#length = 35 (jump out of loop)
	lbu $a1, 0($s1) 								#a1 = char from directions
	beqz $a1, simulate_game_while_loop_done				# reached the end of string directions
	move $a0, $s0									#a0 = state
	move $a2, $s3									#a2 = apples[]
	move $a3, $s4									#a3 = apples_length
	jal move_snake
	
	bltz $v1, simulate_game_while_loop_done				#player has lost(unable to move in that direction)
	beqz $v0, simulate_game_while_loop_contd
	#player has scored 100 points
	lbu $t0, 4($s0)
	addi $t0, $t0, -1
	mul $t0, $v0, $t0
	add $s5, $s5, $t0
			simulate_game_while_loop_contd:
	addi $s2, $s2, -1									#decrement num of moves
	addi $s6, $s6, 1 									#s6 = num of moves executed
	addi $s1, $s1, 1									# shift to next direction
	j simulate_game_while_loop
	
	simulate_game_while_loop_done:
	move $v0, $s6
	move $v1, $s5

	simulate_game_end:
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

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
