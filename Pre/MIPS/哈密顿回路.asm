.data
array: .space 1000
flag: .space 100
.macro getindex(%v1, %v2, %a0, %a1)
	li $t9, 10
	mult $t9, %v1
	mflo %a0
	addu %a0, %a0, %v2
    mult $t9, %v2
	mflo %a1
	addu %a1, %a1, %v1
.end_macro
.text

li $v0, 5
syscall
move $s0, $v0              #read $s0=n

li $v0, 5
syscall
move $s1, $v0              #read $s1=m

li $t0 0                   # int i=0

loop1:

li $v0, 5
syscall
move $t1, $v0              #read $t1=V1
li $v0, 5
syscall
move $t2, $v0              #read $t2=V2

getindex($t1, $t2, $t3, $t4)


li $t6, 4
mult $t3, $t6
mflo $t3                    # index1 = $t3
mult $t4, $t6
mflo $t4                    # index2 = $t4

la $t5, array
addu $t5, $t5, $t3
li $t6, 1
sw $t6, 0($t5)			   # K[index1]=1

la $t5, array
addu $t5, $t5, $t4
li $t6, 1
sw $t6, 0($t5)             # K[index2]=1


addi $t0, $t0, 1
bne $t0, $s1, loop1        # for(i=0;i<m;i++)
nop

#####

# $a0=x $a1=cnt

li $s2, 0                  # $s2 = X
li $a0, 1
li $a1, 0

la $ra, out1
sw $ra, 0($sp)         # save $ra
subi $sp, $sp, 4

jal factorial
out1:
j out



factorial:                 # DFS

	bne $a0, 1, work       # if x == 1
	
	bne $a1, $s0, work1     # if cnt == n
	
	li $s2, 1              # X = 1
work1:
	beq $a1, 0, work
	
	jr $ra
	nop
	
work:
	sw $ra, 0($sp)         # save $ra
	subi $sp, $sp, 4
	 
	
	li $t0, 0              # int i=1
	
loop2:
	addi $t0, $t0, 1       # i++
	getindex($a0, $t0, $t1, $t2)
	li $t3, 4
	mult $t1, $t3
	mflo $t1                    # index = $t1
	la $t4, array
	addu $t4, $t4, $t1
	lw $t3, 0($t4)             # $t3 = K[index] 
	
	bne $t3, 1, do         # if K[x][i] == K[index] == 1
	
	li $t4, 4
	mult $t4, $t0
	mflo $t5               # $t5 = 4*i
	
	la $t2, flag
	addu $t2, $t2, $t5
	lw $t3, 0($t2)		  # $t3 = flag[i]	   
	bne $t3, 0, do         # if flag[i] == 0
	
	
	sw $t0, 0($sp)         # save i
	subi $sp, $sp ,4
	
	sw $a0, 0($sp)         # save a0
	subi $sp, $sp ,4
	
	sw $a1, 0($sp)         # save a1
	subi $sp, $sp ,4
	
	li $t4, 4
	mult $t4, $t0
	mflo $t5               # $t5 = 4*i
	
	la $t2, flag
	addu $t2, $t2, $t5
	li $t3, 1			   
	sw $t3, 0($t2)         # flag[i] = 1
	
	move $a0, $t0          # i
	addi $a1, $a1 ,1       # cnt + 1
	jal factorial          # DFS(i,cnt+1)
	nop
	
	li $t8, 1
	beq $t8, $s2, out
	
	addi $sp, $sp, 4       
	lw $a1, 0($sp)         # load a1
	
	addi $sp, $sp, 4       
	lw $a0, 0($sp)         # load a0
	
	addi $sp, $sp, 4       
	lw $t0, 0($sp)         # load i
	
	li $t4, 4
	mult $t4, $t0
	mflo $t5               # $t5 = 4*i
	
	la $t2, flag
	addu $t2, $t2, $t5
	li $t3, 0			   
	sw $t3, 0($t2)         # flag[i] = 0
	
	
do:
	li $t1, 10
	bne $t0, $t1, loop2        # for(i=1;i<10;i++)
	nop
	
	
	addi $sp, $sp, 4       
	lw $ra ,0($sp)         # load $ra
	
	jr $ra                 # return;
	
#####
out:
move $a0, $s2
li $v0, 1
syscall                    # printf("%d",X);


li $v0, 10
syscall
