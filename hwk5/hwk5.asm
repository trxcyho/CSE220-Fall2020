# Tracy Ho
# trcho
# 112646529

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################

.text

init_list:
	#preserve registers
	sw $zero, 0($a0)
	sw $zero, 4($a0)
    jr $ra

append_card:
	#preserve registers
	addi $sp, $sp, -12
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)

	move $s0, $a0										#s0 = addr of card_list
	move $s1, $a1										#s1 = word of card_num
	
	append_card_loop:
	lw $s2, 4($a0)									#s2 = addr of node
	beqz $s2, append_card_loop_done
	move $a0, $s2
	addi $t0, $t0, -1
	j append_card_loop
	
	append_card_loop_done:
	addi $s2, $a0, 4								#s2 = addr of new Card Node
	
	#create a cardNode object
	li $a0, 8
	li $v0, 9
	syscall
	
	sw $v0, 0($s2)
	sw $s1, 0($v0)
	sw $zero, 4($v0)
	
	#increase size of CardList
	lw $v0, 0($s0)
	addi $v0, $v0, 1
	sw $v0, 0($s0)
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	addi $sp, $sp, 12
    jr $ra

create_deck:
	#preserve registers
	addi $sp, $sp, -16
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $ra, 12($sp)

	#create a card_list
	li $a0, 8
	li $v0, 9
	syscall
	
	#v0 = addr of buffer 8bytes
	move $s0, $v0										#s0 = addr of cardlist
	
	move $a0, $v0
	jal init_list
	
	li $s1, 0x00645330
	li $s2, 80
	
	create_deck_loop:
		beqz $s2, create_deck_loop_done
	move $a0, $s0
	move $a1, $s1
	jal append_card
	li $t0, 0x00645339
	beq $s1, $t0, create_deck_loop_reset
	addi $s1, $s1, 1
	addi $s2, $s2, -1
	j create_deck_loop
	
	create_deck_loop_reset:
	li $s1, 0x00645330
	addi $s2, $s2, -1
	j create_deck_loop
	
	create_deck_loop_done:
	move $v0, $s0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
    jr $ra

deal_starting_cards:
	#preserve registers
	addi $sp, $sp, -24
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)

	move $s0, $a0			#s0 = array of 9 pointers to cardlist
	move $s1, $a1			#s1 = a cardlist of 80 facedown cards
	
	move $s3, $s0			
	lw $s4, 4($a1)			#$s4 = addr of CardNode head
	li $s2, 35				#s2 = counter
	
	deal_starting_cards_loop_d:
	beqz $s2, deal_starting_cards_loop_d_done
	lw $a0, 0($s3)
	lw $a1, 0($s4)
	jal append_card
	
	li $t1, 32
	add $t0, $s0, $t1
	beq $t0, $s3, deal_starting_cards_loop_d_reset
	
	addi $s3, $s3, 4					#s3 = addr of next cardlist
	lw $s4, 4($s4)						#s4 = addr of next CardNode
	addi $s2, $s2, -1
	j deal_starting_cards_loop_d
	
	# tiny function for loop
	deal_starting_cards_loop_d_reset:
	move $s3, $s0
	lw $s4, 4($s4)
	addi $s2, $s2, -1
	j deal_starting_cards_loop_d	
	
	deal_starting_cards_loop_d_done:
	#s3 = pointer of next board[i]
	#s4 = addr of next CardNode
	li $s2, 9
	
	#deal with 9 faceup cards
	deal_starting_cards_up_loop:
	beqz $s2, deal_starting_cards_up_loop_done
	lw $a0, 0($s3)
	lw $t0, 0($s4)
	li $t1, 0x00110000
	add $a1, $t0, $t1
	jal append_card
	
	li $t1, 32
	add $t0, $s0, $t1
	beq $t0, $s3, deal_starting_cards_up_loop_reset
	
	addi $s3, $s3, 4					#s3 = addr of next cardlist
	lw $s4, 4($s4)						#s4 = addr of next CardNode
	addi $s2, $s2, -1
	j deal_starting_cards_up_loop
	
	#little function for loop
	deal_starting_cards_up_loop_reset:
	move $s3, $s0
	lw $s4, 4($s4)
	addi $s2, $s2, -1	
	j deal_starting_cards_up_loop
	
	deal_starting_cards_up_loop_done:
	#update deck
	lw $t0, 0($s1)
	addi $t0, $t0, -44 #the total number of cards we used
	sw $t0, 0($s1)
	sw $s4, 4($s1)					#update the cardnode* head of deck struct
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
    jr $ra

get_card:
	lw $t0, 0($a0)
	beqz $t0, invalid_get_card_args			#size of cardlist is 0
	bltz $a1, invalid_get_card_args			#invalid index
	bge $a1, $t0, invalid_get_card_args	
	
	get_card_loop:	
	lw $a0, 4($a0)									#s2 = addr of node
	beqz $a1, get_card_loop_done
	addi $a1, $a1, -1
	j get_card_loop
	
	get_card_loop_done:
	lw $v1, 0($a0)
	lb $t0, 2($a0)	
	li $t1, 'u'
	beq $t0, $t1, get_card_up
	li $v0, 1
	jr $ra
	
	get_card_up:
	li $v0, 2
	jr $ra
	
	invalid_get_card_args:
	li $v0, -1
	li $v1, -1
	jr $ra

check_move:
	#preserve registers
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
	move $s2, $a2

	srl $s3, $a2, 24	#s3 = byte 3
	sll $s4, $a2, 8
	srl $s4, $s4, 24	#s4 = byte 2
	sll $s5, $a2, 16
	srl $s5, $s5, 24	#s5 = byte 1
	sll $s6, $a2, 24
	srl $s6, $s6, 24	#s6 = byte 0
	
	
	#check for errors
	#-1: invalid deal-move 
	li $v0, -1
	beqz $s3, check_move_error3 	#not a deal move
	li $t1, 1
	bne $s3, $t1, check_move_end		#byte 3 is not 1 or 0
	bnez $s6, check_move_end			#rest of bytes has to be 0 or else invalid
	bnez $s5, check_move_end
	bnez $s4, check_move_end
	
	#-2: valid deal move but deck is empty or if at least one column of the board is empty
	li $v0, -2
	lw $t0, 0($s1)
	beqz $t0, check_move_end	#deck is empty
	li $t0, 9
	check_move_board_sizes_loop:
	lw $a0, 0($s0)
	lw $t1, 0($a0)
	beqz $t1, check_move_end		#size of board[i] is empty
	addi $t0, $t0, -1
	bnez $t0, check_move_board_sizes_loop
	#1: deal_move is valid
	li $v0, 1
	j check_move_end
	
	check_move_error3:
	#-3: donor column or the recipient column encoded in the move argument is invalid
	li $v0, -3
	bltz $s6, check_move_end			
	bltz $s4, check_move_end
	li $t2, 8
	bgt $s6, $t2, check_move_end
	bgt $s4, $t2, check_move_end
				
	#-4: donor row encoded in the move argument is invalid
	li $v0, -4
	#s6 = donor column
	bltz $s5, check_move_end			#invalid row(row is less than 0)
	
	sll $t0, $s6, 2							#multiplies it by 4 to get board[donor]
	add $t0, $t0, $s0						#t0 = address of Cardlist* board[donor]
	lw $t1, 0($t0)							#t1 = board[donor]
	lw $t0, 0($t1)							#t0 = size of board[donor]
	bge $s5, $t0, check_move_end			#row is greater or equal to size 
	
	#-5: donor and recipient columns same number
	li $v0, -5
	beq $s6, $s4, check_move_end			#recipient and donor is same row
	
	#-6: card at the donor column and row encoded in the move argument is face-down
	#use get card at donor[row] and see if card = face down
	sll $t0, $s6, 2 						
	add $t0, $t0, $s0
	
	lw $a0, 0($t0)
	move $a1, $s5 
	jal get_card
	
	move $t0, $v0		#t0 = 1 for facedown  2 = faceup
	li $v0, -6
	li $t1, 1
	beq $t0, $t1, check_move_end
	
	#-7: cards in the donor column that would be moved are not listed in descending, continuous order
	sll $t0, $s6, 2
	add $t0, $t0, $s0
	lw $s3, 0($t0)				#s3 = board[donor]
	lw $s2, 0($s3)
	addi $s2, $s2, -1			#s2 = index of last card
	#beq $s2, $s5, check_move_error8					#moving last card in board[donor]
	
	move $a0, $s3
	move $a1, $s2
	jal get_card
	move $s1, $v1									#s1 = card number of last card
	
	check_move_error7_loop:
	beq $s2, $s5, check_move_error8
	move $a0, $s3
	addi $s2, $s2, -1
	move $a1, $s2
	jal get_card
	addi $s1, $s1, 1
	bne $s1, $v1, check_move_load_error7
	j check_move_error7_loop
	
	check_move_load_error7:
	li $v0, -7
	j check_move_end
	
	check_move_error8:
	#2: check if recipient column is empty(size = 0)
	sll $t0, $s4, 2
	add $t0, $t0, $s0
	lw $t1, 0($t0)				#t1 = board[recipient]
	lw $t0, 0($t1)				#t0 = size of board[recipient]
	li $v0, 2
	beqz $t0, check_move_end			#recipient column is empty
	
	#-8: recipient column is not empty
	#the rank of the selected card is not one less than the rank of the top card in the recipient column
	#s1 = card of board[donor].row
	move $a0, $t1
	addi $t0, $t0, -1
	move $a1, $t0
	jal get_card
	
	addi $s1, $s1, 1
	li $v0, -8
	bne $v1, $s1, check_move_end
	
	#otherwise last card in recipient is one bigger than selected card
	li $v0, 3
	
	check_move_end:
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

clear_full_straight:
	#preserve registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)
	
	move $s0, $a0
	move $s1, $a1
	
	#col_num_invalid
	bltz $s1, invalid_clear_full_straight1
	li $t0, 8
	bgt $s1, $t0, invalid_clear_full_straight1
	
	#board[col_num] contains fewer than 10 cards 
	sll $t0, $s1, 2
	add $t0, $t0, $s0
	lw $s2, 0($t0)						#s2 = board[col_num]
	lw $t0, 0($s2)
	li $t1, 10
	blt $t0, $t1, invalid_clear_full_straight2
	
	#board contains 10 cards but not full straight can be cleared
	addi $s3, $t0, -1					#s3 = index of last card in column
	li $s0, 0x00755330					#s0 = 0Su (card 0 Space face-up)
	
	clear_full_straight_loop:
	move $a0, $s2
	move $a1, $s3
	jal get_card
	bne $v1, $s0, invalid_clear_full_straight3		
	li $t0, 0x00755339
	beq $s0, $t0, clear_full_straight_loop_done
	addi $s0, $s0, 1
	addi $s3, $s3, -1
	j clear_full_straight_loop								
	
	#cards is a straight
	clear_full_straight_loop_done:
	lw $t0, 0($s2)
	addi $t0, $t0, -10					#decrease size of board[col_num]
	sw $t0, 0($s2)
	
	li $v0, 2
	beqz $t0, clear_full_straight_fix_col_done	#column of empty cards
	
	li $v0, 1
	clear_full_straight_fix_col:
	lw $s0, 4($s2)
	move $s2, $s0
	addi $t0, $t0, -1
	bnez $t0, clear_full_straight_fix_col	
	
	clear_full_straight_fix_col_done:
	sw $zero, 4($s2)
	#flip top card if downwards
	lbu $t0, 2($s2)
	li $t1, 'd'
	bne $t0, $t1, clear_full_straight_end
	li $t1, 'u'
	sb $t1, 2($s2)
	j clear_full_straight_end
	
	#invalid arguments for function
	invalid_clear_full_straight1:
	li $v0, -1
	j clear_full_straight_end
	
	invalid_clear_full_straight2:
	li $v0, -2
	j clear_full_straight_end
	
	invalid_clear_full_straight3:
	li $v0, -3

	clear_full_straight_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
    jr $ra

deal_move:
	#preserve registers
	addi $sp, $sp, -20
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $ra, 16($sp)

	move $s0, $a0
	move $s1, $a1
	
	lw $s2, 4($s1)					#s2 = head node of deck
	li $s3, 9
	deal_move_loop:
	lw $a0, 0($s0)
	lw $t0, 0($s2)
	li $t1, 0x00110000
	add $a1, $t0, $t1
	jal append_card
	
	addi $s0, $s0, 4 				#s0 moves to next column
	lw $s2, 4($s2)					#s2 = next node
	addi $s3, $s3, -1				#decrease counter
	bnez $s3, deal_move_loop
	
	#update deck
	lw $t0, 0($s1)	
	addi $t0, $t0, -9				#updates size
	sw $t0, 0($s1)
	sw $s2, 4($s1)
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
    jr $ra

move_card:
	#preserve registers
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
	
	#check move
	jal check_move
	bltz $v0, invalid_move_card_args
	li $t0, 2
	bge $v0, $t0, move_card_not_deal_moves
	
	#move is a deal move
	move $a0, $s0
	move $a1, $s1
	jal deal_move
	
	#call clear full straight on every column
	li $s3, 9
	check_move_deal_move_loop:	
	move $a0, $s0
	addi $a1, $s3, -1
	jal clear_full_straight		#clears if any col has full straight
	addi $s3, $s3, -1
	bnez $s3, check_move_deal_move_loop
	j move_card_sucessful
	
	move_card_not_deal_moves:
	#move cards from donor[row] to column (2: recipient empty, 3:recipient has card/s)
	sll $s5, $s2, 8
	srl $s5, $s5, 24	#s5 = byte 2		(recipient col)
	sll $s4, $s2, 16
	srl $s4, $s4, 24	#s4 = byte 1		(row)
	sll $s3, $s2, 24
	srl $s3, $s3, 24	#s3 = byte 0		(donor col)
	move $s2, $s5		#s2 = copy of recipient column
	
	#convert recipient col num to board[recipient]
	sll $s5, $s5, 2
	add $s5, $s5, $s0
	lw $s5, 0($s5)				#s5 = board[recipient]
	
	sll $s3, $s3, 2
	add $s3, $s3, $s0
	lw $s3, 0($s3)				#s3 = board[donor]
		
	move $t0, $s4				#t0 = counter for loop
	move $t2, $s3				#t2 = addr for looping board[donor]
	move_card_not_deal_moves_donor_loop:
	beqz $t0, move_card_not_deal_moves_donor_loop_done
	lw $t2, 4($t2)				#t2 = next cardnode
	addi $t0, $t0, -1
	j move_card_not_deal_moves_donor_loop
	
	move_card_not_deal_moves_donor_loop_done:
	lw $t9, 4($t2)								#t9 = link to following cards
	sw $zero, 4($t2)			#destroy that link to that column
	
	#change size of board[donor]
	lw $t0, 0($s3)				#t0 = size of board[donor]
	sub $t1, $t0, $s4			#t1 = number of cards moving
	sub $t0, $t0, $t1			#t0 = size of board - number of cards moving
	sw $t0, 0($s3)
	
	#flip facedown cards to faceup
	beqz $t0, move_card_not_deal_moves_recipient_size			#moving all of the cards in the donor column
	lbu $t7, 2($t2)
	li $t6, 'u'
	beq $t6, $t7, move_card_not_deal_moves_recipient_size
	li $t8, 0x00110000
	lw $t7, 0($t2)
	add $t7, $t7, $t8
	sw $t7, 0($t2)						#t2 = last cardnode of board[donor]
	
	move_card_not_deal_moves_recipient_size:
	lw $t0, 0($s5) 				#t0 = size of board[recipient]
	add $t0, $t0, $t1
	sw $t0, 0($s5) 				#update size of board[recipient]
	
	#append cards to board[recipient]
	move $t0, $s5
	move_card_not_deal_moves_recipient_loop:
	lw $t1, 4($t0)
	beqz $t1, move_card_not_deal_moves_recipient_loop_done
	move $t0, $t1
	j move_card_not_deal_moves_recipient_loop
	
	move_card_not_deal_moves_recipient_loop_done:
	sw $t9, 4($t0)				#appends the cards to end of board[recipient]	
	
	#call clear full straight to see if a straight is formed in recipient column
	move $a0, $s0
	move $a1, $s2
	jal clear_full_straight
	j move_card_sucessful
	
	#invalid or valid args
	invalid_move_card_args:
	li $v0, -1
	j move_card_end
	
	move_card_sucessful:
	li $v0, 1
	
	move_card_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

load_game:
	#preserve registers
	addi $sp, $sp, -28
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)

	move $s0, $a1
	move $s1, $a2
	move $s2, $a3
	
	#open file
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	
	bltz $v0, file_does_not_exist
	move $s3, $v0 							#s3 = file descriptor
	
	move $a0, $s1
	jal init_list				#initialize deck
	
	addi $sp, $sp, -4
	li $s5, 0						#s5 = number of moves
	load_game_deck_loop:
	move $a0, $s3
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall									
	
	li $t0, '\n'
	lbu $t1, 0($sp)
	beq $t1, $t0, load_game_deck_loop_done
	move $s4, $t1
	
	move $a0, $s3
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall		
	
	li $a1, 0x00005300						
	lbu $t0, 0($sp)
	sll $t0, $t0, 16
	or $a1, $a1, $t0
	or $a1, $a1, $s4					#a1 = cardnum
	
	#call append_card
	move $a0, $s1
	jal append_card
	j load_game_deck_loop
	
	load_game_deck_loop_done:
	#reading moves line
	move $a0, $s3
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall									
	
	li $t0, ' '
	lbu $t1, 0($sp)
	beq $t1, $t0, load_game_deck_loop_done
	li $t0, '\n'
	beq $t1, $t0, load_game_moves_done
	move $s4, $t1
	
	move $a0, $s3
	move $a1, $sp
	li $a2, 3
	li $v0, 14
	syscall
	
	lbu $t0, 0($sp)
	sll $t0, $t0, 8
	or $s4, $s4, $t0
	
	lbu $t0, 1($sp)
	sll $t0, $t0, 16
	or $s4, $s4, $t0
	
	lbu $t0, 2($sp)
	sll $t0, $t0, 24
	or $s4, $s4, $t0
	li $t0, 0x30303030
	sub $s4, $s4, $t0
	
	#s4 = integer move
	addi $s5, $s5, 1				#increase number of moves
	sw $s4, 0($s2)
	addi $s2, $s2, 4			#move to next moves slot
	j load_game_deck_loop_done
	
	load_game_moves_done:
	#call init_list for each board
	li $s4, 9
	load_game_initialize_board:
	addi $t0, $s4, -1
	sll $t0, $t0, 2
	add $t0, $t0, $s0
	lw $a0, 0($t0)
	jal init_list
	addi $s4, $s4, -1
	bnez $s4, load_game_initialize_board
	
	li $s4, 0
	load_game_board_setup:
	#get character from file
	move $a0, $s3
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	
	beqz $v0, load_game_board_setup_end
	lbu $s1, 0($sp)
	li $t0, ' '
	beq $t0, $s1, load_game_board_setup_empty
	li $t0, '\n'
	beq $s1, $t0, load_game_board_setup_reset
	
	ori $s1, $s1, 0x00005300
	
	move $a0, $s3
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	
	lbu $t0, 0($sp)
	sll $t0, $t0, 16
	or $s1, $s1, $t0				#s1 = cardnumber
	
	sll $t0, $s4, 2
	add $t0, $t0, $s0				#moves it to the right board
	lw $a0, 0($t0)
	move $a1, $s1
	jal append_card
	
	addi $s4, $s4, 1
	j load_game_board_setup
	
	load_game_board_setup_empty:
	move $a0, $s3
	move $a1, $sp
	li $a2, 1
	li $v0, 14
	syscall
	addi $s4, $s4, 1
	j load_game_board_setup
	
	load_game_board_setup_reset:
	li $s4, 0
	j load_game_board_setup
	
	load_game_board_setup_end:
	addi $sp, $sp, 4
	move $v1, $s5
	li $v0, 1
	j load_game_end
	
	#invalid args
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
	lw $ra, 24($sp)
	addi $sp, $sp, 28
    jr $ra

simulate_game:
	#preserve registers
	addi $sp, $sp, -24
	sw $s0, 0($sp)								
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)

	move $s0, $a1
	move $s1, $a2
	move $s2, $a3
	
	jal load_game
	bltz $v0, simulate_game_end		#file cant be opened
	move $s3, $v1					#s3 = counter 
	
	li $s4, 0
	simulate_game_loop_moves:
	beqz $s3, simulate_game_loop_moves_done
	move $a0, $s0
	move $a1, $s1
	lw $a2, 0($s2)				#gets move from moves[]
	jal move_card
	
	addi $s3, $s3, -1
	addi $s2, $s2, 4				#moves to next move
	bltz $v0, simulate_game_loop_moves
	addi $s4, $s4, 1			#s4 = number of valid moves that were executed
	j simulate_game_loop_moves
	
	simulate_game_loop_moves_done:
	#check if deck.size = 0
	#check if size in all columns in board is = 0
	move $v0, $s4
	lw $t0, 0($s1)		#t0 = size of deck
	bnez $t0, simulate_game_not_won
	
	li $s4, 9
	simulate_game_board_loop:
	addi $t0, $s4, -1
	sll $t0, $t0, 2
	add $t0, $t0, $s0
	lw $t0, 0($t0)
	lw $t1, 0($t0)
	bnez $t1, simulate_game_not_won
	addi $s4, $s4, -1
	bnez $s4, simulate_game_board_loop
	
	li $v1, 1
	j simulate_game_end
	
	simulate_game_not_won:
	li $v1, -2
	
	simulate_game_end:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
    jr $ra

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
