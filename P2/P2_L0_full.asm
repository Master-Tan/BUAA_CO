
.data

symbol: .space 40
array : .space 40

size: .word 10

space: .asciiz " "         
enter: .asciiz "\n"

.text

main:

# $s0 = n

li $v0, 5
syscall
move $s0, $v0                 # scanf("%d",&n);

li $a0, 0
jal FullArray                 # FullArray(0);
nop

li $v0, 10                    # return 0;
syscall


FullArray:
	# $t0 = i
	# $a0 = index
	# $s0 = n
	# $ra = return
	
	
# if (index >= n)
	blt $a0, $s0, out1
	nop
	
	# for (i = 0; i < n; i++)		
	li $t0, 0					     # i = 0
	
	loop:
	
		la $t2, array
		sll $t3, $t0, 2
		addu $t2, $t2, $t3
		lw $t4, 0($t2)
		
		move $a0, $t4
		li $v0, 1
		syscall
	
		la $a0, space
   		li $v0, 4
   		syscall
		
		addi $t0, $t0 ,1             # i++
		bne $s0, $t0, loop         # i < n
		nop
		
	la $a0, enter
   	li $v0, 4
   	syscall
	
	jr $ra
	nop
	
out1:


# for (i = 0; i < n; i++)		
	li $t0, 0					     # i = 0
	
for:
	
	la $t2, symbol
	sll $t3, $t0, 2
	addu $t2, $t2, $t3
	lw $t4, 0($t2)                   # symbol[i]
	
	bne $t4, $0, out2                # if (symbol[i] == 0)
	
	la $t2, array
	sll $t3, $a0, 2
	addu $t2, $t2, $t3
	addi $t4, $t0, 1
	sw $t4, 0($t2)                  # array[index] = i + 1
	
	la $t2, symbol
	sll $t3, $t0, 2
	addu $t2, $t2, $t3
	li $t4, 1
	sw $t4, 0($t2)                   # symbol[i] = 1
	
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	subi $sp, $sp, 4
	sw $t0, 0($sp)
	subi $sp, $sp, 4
	
	addi $a0, $a0 ,1
	jal FullArray                     # FullArray(i+1)
	nop
		
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	lw $ra, 0($sp)
	
	la $t2, symbol
	sll $t3, $t0, 2
	addu $t2, $t2, $t3
	li $t4, 0
	sw $t4, 0($t2)                   # symbol[i] = 0
	
	
out2:
		
	addi $t0, $t0 ,1             # i++
	bne $s0, $t0, for         # i < n
	nop
	
	
	jr $ra