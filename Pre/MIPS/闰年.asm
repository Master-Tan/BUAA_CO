.data

.text

li $v0, 5
syscall
move $s0, $v0              #read n

li $t0, 4
div $s0, $t0
mfhi $s1

li $t0, 100
div $s0, $t0
mfhi $s2

li $t0, 400
div $s0, $t0
mfhi $s3

li $t0, 0
li $a0, 0

bne $s3, $t0, do1
li $a0, 1

do1:
bne $s1, $t0, do2
beq $s2, $t0, do2
li $a0, 1

do2:
li $v0, 1
syscall

li $v0, 10
syscall