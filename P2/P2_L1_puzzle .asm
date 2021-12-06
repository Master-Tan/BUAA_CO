.macro index(%sum, %x, %y, %size)
	multu %x, %size
	mflo %sum
	addu %sum, %sum, %y
	sll %sum, %sum, 2
.end_macro

.macro RI(%n)
    li $v0, 5
    syscall
    move %n, $v0
.end_macro

.macro PI(%n)
    li $v0, 1
    move $a0, %n
    syscall
.end_macro

.data

arrayA: .space 256                     # A[8][8]
flag: .space 256                       # flag[8][8]

size: .word 64

.text

li $s7, 8                               # columns
li $t9, 0                               # $t9 = X
# $s0 = n, $s1 = m, $s2 = x2, $s3 = y2
# $t0 = x1, $t1 = y1

RI($s0)
RI($s1)

# for(i=1;i<=n;i++)
li $t0, 1                          # i = 1

loopx1:
	li $t1, 1                      # j = 1
	
	loopy1:
		
		index($t2,$t0,$t1,$s7)
		
		la $t3, arrayA
		addu $t2, $t3, $t2
		
		RI($t3)
		sw $t3, 0($t2)
		
		addi $t1, $t1, 1               # j++
		ble $t1, $s1, loopy1           # if(j<=m)
		nop
	
	
	addi $t0, $t0, 1               # i++
	ble $t0, $s0, loopx1           # if(i<=n)
	nop

# $t0 = x1, $t1 = y1
RI($t0)
RI($t1)

# $s2 = x2, $s3 = y2
RI($s2)
RI($s3)

# flag[x1][y1]=1;
index($t2,$t0,$t1,$s7)

la $t3, flag
addu $t2, $t3, $t2
li $t3, 1
sw $t3, 0($t2)

# DFS(x1,y1);
move $a0, $t0
move $a1, $t1

jal DFS
nop

# printf("%d",X);
PI($t9)

# return 0;
li $v0, 10
syscall


DFS:
	# $a0 = x
	# $a1 = y
	# $ra = return
	
	# if(x==x2&&y==y2)
	bne $a0, $s2, out1
	nop
	bne $a1, $s3, out1
	nop
	
	addi $t9, $t9, 1                      # X++
	
	jr $ra                                # return;
out1:

	li $t0, 1
	beq $a0, $t0, out2
	nop
	
	addi $t1, $a0, -1
	index($t2,$t1,$a1,$s7)
	la $t3, arrayA
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out2
	nop
	
	index($t2,$t1,$a1,$s7)
	la $t3, flag
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out2
	nop
	
	li $t4, 1 
	sw $t4, 0($t2)              # flag[x-1][y]=1;
	
	sw $t2, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	subi $sp, $sp, 4
	sw $a1, 0($sp)
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	
	addi $a0, $a0 ,-1
	jal DFS                     # DFS(x-1,y);
	nop
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	
	li $t4, 0
	sw $t4, 0($t2)
	
out2:
	
	beq $a0, $s0, out3
	nop
	
	addi $t1, $a0, 1
	index($t2,$t1,$a1,$s7)
	la $t3, arrayA
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out3
	nop
	
	index($t2,$t1,$a1,$s7)
	la $t3, flag
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out3
	nop
	
	li $t4, 1 
	sw $t4, 0($t2)              # flag[x+1][y]=1;
	
	sw $t2, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	subi $sp, $sp, 4
	sw $a1, 0($sp)
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	
	addi $a0, $a0 ,1
	jal DFS                     # DFS(x+1,y);
	nop
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	
	li $t4, 0
	sw $t4, 0($t2)
	
out3:
	li $t0, 1
	beq $a1, $t0, out4
	nop
	
	addi $t1, $a1, -1
	index($t2,$a0,$t1,$s7)
	la $t3, arrayA
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out4
	nop
	
	index($t2,$a0,$t1,$s7)
	la $t3, flag
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out4
	nop
	
	li $t4, 1 
	sw $t4, 0($t2)              # flag[x][y-1]=1;
	
	sw $t2, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	subi $sp, $sp, 4
	sw $a1, 0($sp)
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	
	addi $a1, $a1 ,-1
	jal DFS                     # DFS(x,y-1);
	nop
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	
	li $t4, 0
	sw $t4, 0($t2)
	
out4:

	beq $a1, $s1, out5
	nop
	
	addi $t1, $a1, 1
	index($t2,$a0,$t1,$s7)
	la $t3, arrayA
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out5
	nop
	
	index($t2,$a0,$t1,$s7)
	la $t3, flag
	addu $t2, $t3, $t2
	lw $t3, 0($t2)
	bne $t3, $0, out5
	nop
	
	li $t4, 1 
	sw $t4, 0($t2)              # flag[x][y+1]=1;
	
	sw $t2, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	subi $sp, $sp, 4
	sw $a1, 0($sp)
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	
	addi $a1, $a1 ,1
	jal DFS                     # DFS(x,y+1);
	nop
	
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $t2, 0($sp)
	
	li $t4, 0
	sw $t4, 0($t2)
	
out5:
	 
	 jr $ra
	
