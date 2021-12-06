.data
	array: .space 10000
	str_enter:  .asciiz "\n"
	str_space:  .asciiz " "
	
.text

li $v0, 5
syscall
move $s0, $v0              #read $s0=n

li $v0, 5
syscall
move $s1, $v0              #read $s1=m



li $t0 0                   # $t0 = i
li $t1 0                   # $t1 = j
li $t2 0                   # $t2 = cnt

loop1:
loop2:
bne $t1, $s1, do2
sub $t1, $t1, $s1
do2:

li $v0, 5
syscall
move $t3, $v0              #read $t3=a

beq $t3, $0, do

la $t5, array
li $t4, 12
mult $t2, $t4
mflo $t4
addu $t5, $t5, $t4
addi $t2, $t2, 1
sw $t0 ,0($t5)
sw $t1 ,4($t5)
sw $t3 ,8($t5)

do:

addi $t1, $t1, 1
bne $s1, $t1, loop2        #if j!=m -> loop2
addi $t0, $t0, 1
bne $s0, $t0, loop1        #if i!=n -> loop1


move $s0, $t2

la $t1, array
move $t0, $t2
li $t3, 12
mult $t0, $t3
mflo $t0
addu $t1, $t1, $t0

loop3:
addi $t1, $t1, -12
lw $a0, 0($t1)
addi $a0, $a0 ,1
li $v0, 1
syscall
la $a0, str_space
li $v0, 4
syscall
lw $a0, 4($t1)
addi $a0, $a0 ,1
li $v0, 1
syscall
la $a0, str_space
li $v0, 4
syscall
lw $a0, 8($t1)
li $v0, 1
syscall
la $a0, str_space
li $v0, 4
syscall
la $a0, str_enter
li $v0, 4
syscall

bne $t1, $0, loop3

li $v0, 10
syscall
