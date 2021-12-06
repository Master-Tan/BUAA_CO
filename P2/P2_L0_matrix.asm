.macro index(%sum, %x, %y, %size)
	multu %x, %size
	mflo %sum
	addu %sum, %sum, %y
	sll %sum, %sum, 2
.end_macro

.data
arrayA: .space 256          # int A[8][8]
arrayB: .space 256          # int B[8][8]
arrayC: .space 256          # int C[8][8]

size: .word  64             # size of "array"

space:.asciiz  " "         
enter:.asciiz "\n"

.text
li $v0, 5
syscall                           # scanf("%d",&N);
move $s0, $v0                     # $s0 = N

li $s1, 8                         # columns

# $t0 = i, $t1 = j, $t2 = l

li $t0, 0					     # i = 0

loopx1:
	li $t1, 0					 # j = 0
	
	loopy1:
		li $v0, 5
		syscall
		move $t4, $v0
		
		index($t5, $t0, $t1, $s1)
		
		la $t3, arrayA
		addu $t3, $t3, $t5
		sw $t4, 0($t3)           # scanf("%d",&A[i][j]);
		
		addi $t1, $t1, 1         # j++
		bne $s0, $t1, loopy1     # j < N
		nop
		
	addi $t0, $t0 ,1             # i++
	bne $s0, $t0, loopx1         # i < N
	nop
	
	
li $t0, 0					     # i = 0

loopx2:
	li $t1, 0					 # j = 0
	
	loopy2:
		li $v0, 5
		syscall
		move $t4, $v0
		
		index($t5, $t0, $t1, $s1)
		
		la $t3, arrayB
		addu $t3, $t3, $t5
		sw $t4, 0($t3)           # scanf("%d",&B[i][j]);
		
		addi $t1, $t1, 1         # j++
		bne $s0, $t1, loopy2     # j < N
		nop
		
	addi $t0, $t0 ,1             # i++
	bne $s0, $t0, loopx2         # i < N
	nop
	

li $t0, 0					     # i = 0

loopx3:
	li $t1, 0					 # j = 0
	
	loopy3:
		li $t2, 0                # l = 0
		
		# $t6 = sum
		li $t6, 0            # $sum =0
		
		loopz:
		  	
		  	index($t7, $t0, $t2, $s1)
		  	index($t8, $t2, $t1, $s1)
		  	la $t9, arrayA
			addu $t9, $t9, $t7
			lw $t7, 0($t9)           # A[i][l]
			la $t9, arrayB
			addu $t9, $t9, $t8
			lw $t8, 0($t9)           # B[l][j]
			
			multu $t7, $t8
			mflo $t9
			addu $t6, $t6, $t9       # sum+=A[i][l]*B[l][j];
		  	
			addi $t2, $t2, 1         # l++
			bne $s0, $t2, loopz      # l < N
			nop
		
		index($t7, $t0, $t1, $s1)    # C[i][j]
		la $t8, arrayC
		addu $t8, $t8, $t7
		sw $t6, 0($t8)               # C[i][j]=sum;
		
		addi $t1, $t1, 1             # j++
		bne $s0, $t1, loopy3         # j < N
		nop
		
	addi $t0, $t0 ,1                 # i++
	bne $s0, $t0, loopx3             # i < N
	nop


li $t0, 0					     # i = 0

loopx4:
	li $t1, 0					 # j = 0
	
	loopy4:
		
		index($t2, $t0, $t1, $s1)
		
		la $t3, arrayC
		addu $t3, $t3, $t2
		lw $t4, 0($t3)           # C[i][j]
		
		move $a0, $t4
		li $v0, 1
		syscall
		
		la $a0, space            
		li $v0, 4                
		syscall                     
		
		addi $t1, $t1, 1         # j++
		bne $s0, $t1, loopy4     # j < N
		nop
	
	la $a0, enter           
	li $v0, 4                
	syscall   	
				
	addi $t0, $t0 ,1             # i++
	bne $s0, $t0, loopx4         # i < N
	nop
	


li $v0,10
syscall
