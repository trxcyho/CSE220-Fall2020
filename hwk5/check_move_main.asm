.data
.align 2
move: .word 197382
##### Deck #####
.align 2
deck:
.word 36  # list's size
.word node565654 # address of list's head
node491599:
.word 6574904
.word node568725
node30258:
.word 6574899
.word node960696
node389676:
.word 6574898
.word node660985
node542423:
.word 6574903
.word node519054
node885638:
.word 6574905
.word node327956
node842468:
.word 6574896
.word node810708
node425271:
.word 6574900
.word node119970
node810708:
.word 6574902
.word node55539
node960696:
.word 6574903
.word node491599
node645758:
.word 6574896
.word node930604
node392533:
.word 6574899
.word node645758
node270436:
.word 6574900
.word node842468
node930604:
.word 6574901
.word node216239
node327956:
.word 6574900
.word node573053
node991130:
.word 6574899
.word node389676
node569612:
.word 6574897
.word node912265
node654794:
.word 6574901
.word node991130
node660985:
.word 6574902
.word node84011
node889889:
.word 6574904
.word node30258
node84011:
.word 6574901
.word node270436
node709262:
.word 6574899
.word node686132
node565654:
.word 6574905
.word node885638
node686132:
.word 6574904
.word node877253
node573053:
.word 6574904
.word node709262
node12639:
.word 6574905
.word node104256
node104256:
.word 6574900
.word node654794
node877253:
.word 6574897
.word node146751
node470166:
.word 6574896
.word node425271
node519054:
.word 6574905
.word node569612
node216239:
.word 6574904
.word node470166
node55539:
.word 6574905
.word node462734
node462734:
.word 6574900
.word node392533
node119970:
.word 6574897
.word 0
node568725:
.word 6574902
.word node542423
node912265:
.word 6574898
.word node12639
node146751:
.word 6574896
.word node889889
##### Board #####
.data
.align 2
board:
.word card_list78915 card_list688577 card_list231351 card_list238730 card_list365927 card_list361474 card_list397379 card_list926440 card_list498583 
# column #2
.align 2
card_list231351:
.word 5  # list's size
.word node78915 # address of list's head
node115767:
.word 7689017
.word 0
node397379:
.word 6574902
.word node676440
node78915:
.word 6574896
.word node238730
node238730:
.word 6574899
.word node397379
node676440:
.word 6574905
.word node115767
# column #1
.align 2
card_list688577:
.word 5  # list's size
.word node900563 # address of list's head
node987175:
.word 6574900
.word node803929
node854559:
.word 7689015
.word 0
node803929:
.word 6574897
.word node364590
node364590:
.word 6574898
.word node854559
node900563:
.word 6574902
.word node987175
# column #6
.align 2
card_list397379:
.word 5  # list's size
.word node586146 # address of list's head
node759406:
.word 6574896
.word node660134
node578498:
.word 6574902
.word node759406
node675400:
.word 7689010
.word 0
node586146:
.word 6574896
.word node578498
node660134:
.word 7689011
.word node675400
# column #4
.align 2
card_list365927:
.word 5  # list's size
.word node888233 # address of list's head
node888233:
.word 6574899
.word node28766
node244854:
.word 7689017
.word 0
node530884:
.word 6574901
.word node244854
node28766:
.word 6574903
.word node204701
node204701:
.word 6574897
.word node530884
# column #8
.align 2
card_list498583:
.word 4  # list's size
.word node231351 # address of list's head
node841365:
.word 7689016
.word 0
node361474:
.word 6574904
.word node498583
node498583:
.word 6574898
.word node841365
node231351:
.word 6574901
.word node361474
# column #5
.align 2
card_list361474:
.word 5  # list's size
.word node688577 # address of list's head
node688577:
.word 6574897
.word node365927
node796802:
.word 6574902
.word node255386
node365927:
.word 6574896
.word node926440
node255386:
.word 7689010
.word 0
node926440:
.word 6574903
.word node796802
# column #0
.align 2
card_list78915:
.word 5  # list's size
.word node343243 # address of list's head
node801411:
.word 6574901
.word node118446
node343243:
.word 6574900
.word node801411
node118446:
.word 6574903
.word node414155
node414155:
.word 6574897
.word node4330
node4330:
.word 7689010
.word 0
# column #7
.align 2
card_list926440:
.word 5  # list's size
.word node123449 # address of list's head
node437746:
.word 7689016
.word 0
node203138:
.word 6574903
.word node575879
node575879:
.word 6574897
.word node437746
node254892:
.word 6574901
.word node203138
node123449:
.word 6574898
.word node254892
# column #3
.align 2
card_list238730:
.word 5  # list's size
.word node889531 # address of list's head
node307169:
.word 6574903
.word node172449
node262656:
.word 6574899
.word node495619
node495619:
.word 6574901
.word node307169
node889531:
.word 6574902
.word node262656
node172449:
.word 7689012
.word 0


.text
.globl main
main:
la $a0, board
la $a1, deck
lw $a2, move
jal check_move

# Write code to check the correctness of your code!

	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
li $v0, 10
syscall

.include "hwk5.asm"
