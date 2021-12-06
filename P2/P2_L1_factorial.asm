
.data

array: .space 4000

enter: .asciiz "\n"
space: .asciiz " "

.text

# $s0 = n

li $v0, 5
syscall
move $s0, $v0                        # scanf("%d", &n);

la $t0, array
li $a1, 1
sw $a1, 0($t0)                      # a[0]=1;

# $t8 = max

li $t8, 1                           # max = 1


# $t0 = i, $t1 = j
# $t2 = cin, $t3 = sum


# for(i=1;i<=n;i++)

li $t0, 1                           # i = 1
li $s1, 1000

loopx1:

	li $t2, 0                       # cin = 0

	# for(j=0;j<1000;j++)
	li $t1, 0
	
	loopy1:
		
		la $t5, array
		sll $t4, $t1, 2
		add $t5, $t4, $t5
		lw $t4, 0($t5)              # a[j]
		
		
		mult $t4, $t0
		mflo $t3
		add $t3, $t3, $t2           # sum=a[j]*i+cin;
		
		li $t6, 10
		div $t3, $t6
		
		mfhi $t6
		sw $t6, 0($t5)              # a[j]=sum%10;
		mflo $t2                    # cin=sum/10;
		
	
		addi $t1, $t1, 1            # j++
		blt $t1, $t8, loopy1        # if(j<max)
		
	while:
	
		addi $t5, $t5, 4
		
		li $t6, 10
		div $t2, $t6
		
		mfhi $t6
		sw $t6, 0($t5)              # a[j++]=cin%10;
		mflo $t2                    # cin=cin/10;
		
		addi $t8, $t8, 1
	
		addi $t1, $t1, 1            # j++
		
		bne $t2, $0, while
		
		
	addi $t0, $t0, 1                # i++
	ble $t0, $s0, loopx1            # if(i<=n)
	
li $t1, 999

loop1:
	la $t2, array
	sll $t3, $t1, 2
	add $t2, $t3, $t2
	lw $t3, 0($t2)                  # a[j]
	
	beq $t3, $0 ,to                 # if(a[j]!=0)
	
	j out
	
to: 
	addi $t1, $t1, -1               # j--
	bnez $t1, loop1                 # while(j!=0)
	
out:

# for(i=j;i>=0;i--)

move $t0, $t1

loop2:
	
	la $t2,array
	sll $t3, $t0, 2
	add $t2, $t3, $t2
	lw $a0, 0($t2)
	
	li $v0, 1
	syscall

	addi $t0, $t0, -1
	bge $t0, $0, loop2

li $v0, 10
syscall

