.data 
arg0: .asciiz "game04.txt"
arg1: .word card_list541949 card_list144045 card_list109868 card_list386926 card_list597883 card_list284952 card_list255055 card_list337702 card_list45115 
# column #7
.align 2
card_list337702:
.word 213147  # list's size
.word 929558 # address of list's head
# column #2
.align 2
card_list109868:
.word 360261  # list's size
.word 524417 # address of list's head
# column #0
.align 2
card_list541949:
.word 340637  # list's size
.word 913724 # address of list's head
# column #5
.align 2
card_list284952:
.word 356601  # list's size
.word 97368 # address of list's head
# column #1
.align 2
card_list144045:
.word 539723  # list's size
.word 583615 # address of list's head
# column #4
.align 2
card_list597883:
.word 235830  # list's size
.word 936833 # address of list's head
# column #6
.align 2
card_list255055:
.word 974983  # list's size
.word 530896 # address of list's head
# column #3
.align 2
card_list386926:
.word 571954  # list's size
.word 761609 # address of list's head
# column #8
.align 2
card_list45115:
.word 277400  # list's size
.word 417512 # address of list's head



.align 2
arg2: .word 19159058 60556872
arg3: .ascii "f3rXNtgppaRqx6x4hpG6taZeSVTrfXQSHPYHzpx2v6D3NnJBFceYXd1gg5EzmH1SHTVa6JUQn9wU5ji9S24KkN3LPSt2qe783Cb3fr2GeqAQUZQDvhiDQiYN6I7MNtIVJ5u4FOP37K8skmXoYPDuefE43pCzpSytuIW6IT8rQ4JLJUbUHgCRiiE4Bi9QDU9h34riZpfgN91L7sviu7RBsfp63KVd4HzxBX0Ocq32osDQInDenn3RkG3Rtiulsfzw0pA8U0CWkasGNa2ToCBk0sttX9XdU5p4Coa2cxs1j4B51VQ14KemWD1kb0Jjhjl9YJ2J6I1Had4fpD8EQ089X1HGwlSA3Fgb2SMqn5OyMOvVGKbIllm5sYlFbz2iuNFY5IDUs1jZhXoZLESu4e4nxQUbntF99QAcW2WT05M0W89EDon2yhKJMywgPmmcoHX1P2ZXH7VmlqAsWQVRlLgatJqBQfauQzA04PK2wKt9DX9Fyj9VXl8f6BRfxn5UdS21a6AlMP77g"
.text
.globl main
main:
move $a0, $sp
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg0
la $a1, arg1
la $a2, arg2
la $a3, arg3
li $s0, 800
li $s1, 801
li $s2, 802
li $s3, 803
li $s4, 804
li $s5, 805
li $s6, 806
li $s7, 807
jal simulate_game
move $t0, $v0
move $t1, $v1
move $a0, $sp
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s2
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s3
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s4
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s5
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s6
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $s7
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $t0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
move $a0, $t1
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 0($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg10:
beqz $t9, rec_looparg10_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg10_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg10
rec_looparg10_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 4($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg14:
beqz $t9, rec_looparg14_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg14_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg14
rec_looparg14_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 8($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg18:
beqz $t9, rec_looparg18_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg18_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg18
rec_looparg18_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 12($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg112:
beqz $t9, rec_looparg112_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg112_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg112
rec_looparg112_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 16($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg116:
beqz $t9, rec_looparg116_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg116_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg116
rec_looparg116_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 20($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg120:
beqz $t9, rec_looparg120_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg120_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg120
rec_looparg120_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 24($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg124:
beqz $t9, rec_looparg124_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg124_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg124
rec_looparg124_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 28($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg128:
beqz $t9, rec_looparg128_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg128_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg128
rec_looparg128_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg1
lw $a0, 32($a0)
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg132:
beqz $t9, rec_looparg132_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg132_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg132
rec_looparg132_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
la $a0, arg2
lw $t8, 0($a0)
lw $t9, 4($a0)
li $a0, 'S'
li $v0, 11
syscall
li $a0, 'I'
li $v0, 11
syscall
li $a0, 'Z'
li $v0, 11
syscall
li $a0, 'E'
li $v0, 11
syscall
li $a0, ' '
li $v0, 11
syscall
move $a0, $t8
li $v0, 1
syscall
li $a0, ' '
li $v0, 11
syscall
li $a0, '|'
li $v0, 11
syscall
rec_looparg2:
beqz $t9, rec_looparg2_done
lw $a0, 0($t9)
lb $a0, 0($t9)
li $v0, 11
syscall
lb $a0, 1($t9)
li $v0, 11
syscall
lb $a0, 2($t9)
li $v0, 11
syscall
addi $t8, $t8, -1 
lw $t9, 4($t9)
beqz $t9, rec_looparg2_done
li $a0, ' '
li $v0, 11
syscall
j rec_looparg2
rec_looparg2_done:
li $a0, '|'
li $v0, 11
syscall
li $a0, '\n'
li $v0, 11
syscall
li $v0, 10
syscall

.include "hwk5.asm"