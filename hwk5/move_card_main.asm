# Moving all of the cards in the donor column to a nonempty recipient column
.data
##### Deck #####
.align 2
deck:
.word 36  # list's size
.word node711033 # address of list's head
node735186:
.word 6574901
.word node665938
node140166:
.word 6574898
.word node99399
node122946:
.word 6574904
.word node271247
node99399:
.word 6574903
.word node781943
node641161:
.word 6574901
.word node135060
node837251:
.word 6574897
.word node877961
node907090:
.word 6574901
.word node157284
node726674:
.word 6574900
.word node798688
node711033:
.word 6574896
.word node501283
node821322:
.word 6574902
.word node111591
node969744:
.word 6574896
.word node140166
node829820:
.word 6574905
.word node907090
node135060:
.word 6574905
.word node969744
node501283:
.word 6574903
.word node726674
node699024:
.word 6574904
.word node988906
node665938:
.word 6574902
.word node641161
node157284:
.word 6574905
.word node789791
node789791:
.word 6574896
.word node122946
node696679:
.word 6574901
.word 0
node111591:
.word 6574900
.word node699024
node877961:
.word 6574897
.word node829820
node200967:
.word 6574899
.word node903207
node658577:
.word 6574905
.word node735186
node627847:
.word 6574899
.word node362816
node362816:
.word 6574900
.word node644315
node271247:
.word 6574897
.word node821322
node548211:
.word 6574896
.word node272784
node52160:
.word 6574902
.word node658577
node988906:
.word 6574901
.word node13320
node644315:
.word 6574900
.word node52160
node272784:
.word 6574899
.word node200967
node856721:
.word 6574898
.word node837251
node798688:
.word 6574897
.word node856721
node13320:
.word 6574904
.word node627847
node781943:
.word 6574903
.word node548211
node903207:
.word 6574905
.word node696679
##### Board #####
.data
.align 2
board:
.word card_list872818 card_list780529 card_list557800 card_list473891 card_list194398 card_list717800 card_list957954 card_list647197 card_list801727 
# column #6
.align 2
card_list957954:
.word 1  # list's size
.word node808078 # address of list's head
node808078:
.word 7689016
.word 0
# column #1
.align 2
card_list780529:
.word 2  # list's size
.word node171535 # address of list's head
node197661:
.word 7689016
.word 0
node171535:
.word 6574905
.word node197661
# column #8
.align 2
card_list801727:
.word 3  # list's size
.word node267325 # address of list's head
node376650:
.word 7689015
.word 0
node243265:
.word 7689016
.word node376650
node267325:
.word 6574896
.word node243265
# column #4
.align 2
card_list194398:
.word 1  # list's size
.word node245407 # address of list's head
node245407:
.word 7689015
.word 0
# column #2
.align 2
card_list557800:
.word 9  # list's size
.word node420772 # address of list's head
node671189:
.word 7689009
.word node347006
node529757:
.word 7689012
.word node123852
node673069:
.word 7689013
.word node529757
node951061:
.word 7689015
.word node57980
node57980:
.word 7689014
.word node673069
node420772:
.word 7689016
.word node951061
node123852:
.word 7689011
.word node351708
node347006:
.word 7689008
.word 0
node351708:
.word 7689010
.word node671189
# column #0
.align 2
card_list872818:
.word 5  # list's size
.word node128452 # address of list's head
node128580:
.word 6574902
.word node441100
node128452:
.word 6574905
.word node128580
node514375:
.word 7689009
.word 0
node441100:
.word 7689011
.word node13678
node13678:
.word 7689010
.word node514375
# column #5
.align 2
card_list717800:
.word 6  # list's size
.word node353202 # address of list's head
node274993:
.word 7689011
.word node170811
node110241:
.word 7689013
.word node930616
node170811:
.word 7689010
.word 0
node353202:
.word 7689015
.word node207896
node930616:
.word 7689012
.word node274993
node207896:
.word 7689014
.word node110241
# column #7
.align 2
card_list647197:
.word 6  # list's size
.word node573876 # address of list's head
node964793:
.word 7689012
.word node787957
node573876:
.word 6574902
.word node964793
node423622:
.word 7689009
.word node204171
node204171:
.word 7689008
.word 0
node958812:
.word 7689010
.word node423622
node787957:
.word 7689011
.word node958812
# column #3
.align 2
card_list473891:
.word 1  # list's size
.word node592201 # address of list's head
node592201:
.word 7689010
.word 0
##### Move #####
move: .word 393221




.text
.globl main
main:
la $a0, board
la $a1, deck
lw $a2, move
jal move_card

# Write code to check the correctness of your code!
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	la $t0, board
	lw $t1, move
	move $s2, $t1
	sll $s5, $s2, 8
	srl $s5, $s5, 24	#s5 = byte 2		(recipient col)
	sll $s4, $s2, 16
	srl $s4, $s4, 24	#s4 = byte 1		(row)
	sll $s3, $s2, 24
	srl $s3, $s3, 24	#s3 = byte 0		(donor col)
	
	sll $t9, $s5, 2
	add $t9, $t9, $t0
	lw $t8, 0($t9)
	lw $a0, 0($t8)
	li $v0, 1
	syscall	#recpient size
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	sll $t9, $s3, 2
	add $t9, $t9, $t0
	lw $t8, 0($t9)
	lw $a0, 0($t8)
	li $v0, 1
	syscall		#donor size
	
	
	
li $v0, 10
syscall

.include "hwk5.asm"
