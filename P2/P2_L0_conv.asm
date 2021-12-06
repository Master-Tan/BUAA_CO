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

arrayA: .space 400
arrayB: .space 400
size: .word 100

space:.asciiz  " "         
enter:.asciiz "\n"

.text

li $s7, 10                        # columns

# $s0 = m1, $s1 = n1, $s2 = m2, $s3 = n2 

RI($s0)
RI($s1)
RI($s2)
RI($s3)

# $t0 = i, $t1 = j, $t2 = k, $t3 = l 

li $t0, 0					     # i = 0

loopx1:
	li $t1, 0					 # j = 0
	
	loopy1:
		
		RI($t4)
		
		index($t5, $t0, $t1, $s7)
		
		la $t3, arrayA
		addu $t3, $t3, $t5
		sw $t4, 0($t3)           # scanf("%d",&A[i][j]);
		
		addi $t1, $t1, 1         # j++
		bne $s1, $t1, loopy1     # j < n1
		nop
		
	addi $t0, $t0 ,1             # i++
	bne $s0, $t0, loopx1         # i < m1
	nop


li $t0, 0					     # i = 0

loopx2:
	li $t1, 0					 # j = 0
	
	loopy2:
	
		RI($t4)
		
		index($t5, $t0, $t1, $s7)
		
		la $t3, arrayB
		addu $t3, $t3, $t5
		sw $t4, 0($t3)           # scanf("%d",&B[i][j]);
		
		addi $t1, $t1, 1         # j++
		bne $s3, $t1, loopy2     # j < n2
		nop
		
	addi $t0, $t0 ,1             # i++
	bne $s2, $t0, loopx2         # i < m2
	nop
	
	
# $s4 = m3, $s5 = n3

sub $s4, $s0, $s2               # m3=m1-m2+1;
addi $s4, $s4, 1

sub $s5, $s1, $s3               # n3=n1-n2+1;
addi $s5, $s5, 1

# $t8 = sum

li $t0, 0					     # i = 0

loopx3:
	li $t1, 0					 # j = 0
	
	loopy3:
		li $t8, 0            # $sum =0
		
		li $t2, 0                # k = 0
		
		loopz1:
		  	
		  	li $t3, 0            # l = 0
		  	
		  	loopz2:
		  	
		  		add $t4, $t0, $t2
		  		add $t5, $t1, $t3
		  	
		  		index($t6, $t4, $t5, $s7)
		  		index($t7, $t2, $t3, $s7)
		  	
		  		la $t9, arrayA
				addu $t9, $t9, $t6
				lw $t6, 0($t9)           # A[i+k][j+l]
				la $t9, arrayB
				addu $t9, $t9, $t7
				lw $t7, 0($t9)           # B[k][l]
			
				multu $t6, $t7
				mflo $t9
				addu $t8, $t8, $t9       # sum+=A[i+k][j+l]*B[k][l];
   				
		  		addi $t3, $t3, 1         # l++
				bne $s3, $t3, loopz2      # l < n2
				nop
		  	
			addi $t2, $t2, 1         # k++
			bne $s2, $t2, loopz1      # k < m2
			nop
		
		PI($t8)
		  		
		la $a0, space
   		li $v0, 4
   		syscall
		
		addi $t1, $t1, 1             # j++
		bne $s5, $t1, loopy3         # j < n3
		nop
		
	la $a0, enter
   	li $v0, 4
   	syscall
		
	addi $t0, $t0 ,1                 # i++
	bne $s4, $t0, loopx3             # i < m3
	nop




li $v0, 10
syscall
