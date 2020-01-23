.data
space: .asciiz  "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
head: .asciiz  " O  "
headm: .asciiz "<O  "
hand: .asciiz  "/|\\ "
foot: .asciiz  "/ \\ "
endl: .asciiz  "\n"
line: .asciiz  "--------------------------------"
mon1: .word 3
mon2: .word 0
hum1: .word 3
hum2: .word 0
error: .word 0
errorMsg: .asciiz "you can't make the movement"
errorBound: .asciiz "You have to play between 1-5"
choice: .asciiz "1-human 2-dou human 3-human monster 4-dou monster 5-monster: "
msg: .asciiz "\nclick ENTER to continue"
side1: .asciiz "side up \t"
side2: .asciiz "side down\t"
badEnding: .asciiz "Monsters has eaten your friend, poor friends :("
goodEnding: .asciiz "All humans and monsters went to second side happely, congrats:)"
turn: .word 1
.text 
main:
#s1,s2 people, s3,s4 monsters

start:
lw $t1,hum1
lw $t2,mon1
lw $t3,hum2
lw $t4,mon2
add $t0,$t1,$t2
beq $t0,$0,win
beq $t2,0,cont1
beq $t1,0,cont1
blt $t1,$t2,lose
cont1:
beq $t2,0,cont2
beq $t3,0,cont2
blt $t3,$t4,lose
cont2:
li $v0,4
la $a0, space
syscall
jal player1
jal player2
lw $t0,turn
beq $t0,2,step2
step1:
jal play
lw $t0,error
beq $t0,10,errBound
bgt $t0,0,errMsg
addi $t0,$0,2
la $t1,turn
sw $t0,0($t1)
j endPlay
step2:
jal play2
lw $t0,error
beq $t0,10,errBound
bgt $t0,0,errMsg
addi $t0,$0,1
la $t1,turn
sw $t0,0($t1)
j endPlay
endPlay:
j start
errBound:
li $t0,4
la $a0,errorBound
syscall
li $v0,4
la $a0, msg
syscall
li $v0,8
syscall
la $a0,endl
syscall
add $t0,$0,$0
la $t1,error
sw $t0,0($t1)
j start
errMsg:
li $t0,4
la $a0,errorMsg
syscall
li $v0,4
la $a0, msg
syscall
li $v0,8
syscall
li $v0,4
la $a0,endl
syscall
add $t0,$0,$0
la $t1,error
sw $t0,0($t1)
j start

win:
li $v0,4
la $a0,goodEnding
syscall
j endGame
lose:
li $v0,4
la $a0,badEnding
syscall
endGame:
addi $v0,$0,10
syscall


#-----------------------------------------------------------------------------------------------------------
player1:
lw $t0,hum1
lw $t1,mon1
li $v0,4
head1: #drawing head
ble $t0,$0,headMonster1
la $a0,head
syscall
addi $t0,$t0,-1
j head1
endHumanHead1:
headMonster1:
ble $t1,$0,endHeadMonster1
la $a0,headm
syscall
addi $t1,$t1,-1
j headMonster1
endHeadMonster1:
#-----------------------------------------------------
la $a0,endl
syscall
lw $t0,mon1
lw $t1,hum1
add $t0,$t0,$t1 #monsters and people has same body
hand1: #draw hand
ble $t0,$0,endHand1
la $a0,hand
syscall
addi $t0,$t0,-1
j hand1
endHand1:
#-----------------------------------------------------
la $a0,endl
syscall
lw $t0,mon1
lw $t1,hum1
add $t0,$t0,$t1 #monsters and people has same body
foot1: #draw hand
ble $t0,$0,endFoot1
la $a0,foot
syscall
addi $t0,$t0,-1
j foot1
endFoot1:
la $a0,endl
syscall
la $a0,line
syscall
la $a0,endl
syscall
jr $ra
#-------------------------------------------------------------------------------------------------------------------
player2:
lw $t0,hum2
lw $t1,mon2
li $v0,4
head2: #drawing head
ble $t0,$0,headMonster2
la $a0,head
syscall
addi $t0,$t0,-1
j head2
endHumanHead2:
headMonster2:
ble $t1,$0,endHeadMonster2
la $a0,headm
syscall
addi $t1,$t1,-1
j headMonster2
endHeadMonster2:
#-------------------------------------------------------------------------------------------------------------
la $a0,endl
syscall
lw $t0,mon2
lw $t1,hum2
add $t0,$t0,$t1 #monsters and people has same body
hand2: #draw hand
ble $t0,$0,endHand2
la $a0,hand
syscall
addi $t0,$t0,-1
j hand2
endHand2:
#-----------------------------------------------------
la $a0,endl
syscall
lw $t0,mon2
lw $t1,hum2
add $t0,$t0,$t1 #monsters and people has same body
foot2: #draw hand
ble $t0,$0,endFoot2
la $a0,foot
syscall
addi $t0,$t0,-1
j foot2
endFoot2:
la $a0,endl
syscall
jr $ra
#-------------------------------------------------------------------------------------------------------------
play:
li $v0,4
la $a0,side1
syscall
la $a0,choice
syscall
li $v0,5
syscall
lw $t0,hum1
lw $t1,hum2
lw $t2,mon1
lw $t3,mon2
add $t4,$v0,$0
beq $t4,1,switch1
beq $t4,2,switch2
beq $t4,3,switch3
beq $t4,4,switch4
beq $t4,5,switch5
j endSwitch
switch1:#"1-hum 2-humhum 3-hummon 4-monmon 5-mon "
addi $t0,$t0,-1
addi $t1,$t1,1
j endSwitch
switch2:
addi $t0,$t0,-2
addi $t1,$t1,2
j endSwitch
switch3:
addi $t0,$t0,-1
addi $t1,$t1,1
addi $t2,$t2,-1
addi $t3,$t3,1
j endSwitch
switch4:
addi $t2,$t2,-2
addi $t3,$t3,2
j endSwitch
switch5:
addi $t2,$t2,-1
addi $t3,$t3,1
endSwitch:
la $t5,hum1
la $t6,hum2
la $t7,mon1
la $t8,mon2
li $v0,4
bgt $t4,5,errPlay1
blt $t4,1,errPlay1
blt $t1,0,err1
blt $t2,0,err1
sw $t0,0($t5)
sw $t1,0($t6)
sw $t2,0($t7)
sw $t3,0($t8)
jr $ra
err1:
addi $t0,$0,1
la $t1,error
sw $t0,0($t1)
jr $ra
errPlay1:
addi $t0,$0,10
la $t1,error
sw $t0,0($t1)
jr $ra
#----------------------------------------------------
play2:
li $v0,4
la $a0,side2
syscall
la $a0,choice
syscall
li $v0,5
syscall
lw $t0,hum1
lw $t1,hum2
lw $t2,mon1
lw $t3,mon2
add $t4,$v0,$0
beq $t4,1,switch6
beq $t4,2,switch7
beq $t4,3,switch8
beq $t4,4,switch9
beq $t4,5,switch10
j endSwitch2
switch6:#"1-hum 2-humhum 3-hummon 4-monmon 5-mon "
addi $t0,$t0,1
addi $t1,$t1,-1
j endSwitch2
switch7:
addi $t0,$t0,2
addi $t1,$t1,-2
j endSwitch2
switch8:
addi $t0,$t0,1
addi $t1,$t1,-1
addi $t2,$t2,1
addi $t3,$t3,-1
j endSwitch2
switch9:
addi $t2,$t2,2
addi $t3,$t3,-2
j endSwitch2
switch10:
addi $t2,$t2,1
addi $t3,$t3,-1
endSwitch2:
la $t5,hum1
la $t6,hum2
la $t7,mon1
la $t8,mon2

li $v0,4
bgt $t4,5,errPlay2
blt $t4,1,errPlay2
blt $t1,0,err1
blt $t3,0,err1
sw $t0,0($t5)
sw $t1,0($t6)
sw $t2,0($t7)
sw $t3,0($t8)
jr $ra
err2:
addi $t0,$0,1
la $t1,error
sw $t0,0($t1)
jr $ra
errPlay2:
addi $t0,$0,10
la $t1,error
sw $t0,0($t1)
jr $ra