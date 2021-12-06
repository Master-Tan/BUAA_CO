.data

array: .space 400               # char a[101];
# char: .space 100
size: .word 100

.text

li $v0, 5
syscall                         # scanf("%d",&N);
move $s0, $v0                   # int N;

# $t0 = i,  $t1 = j

li $t0, 0                       # i = 0

loop1:
	
	li $v0, 12
	syscall
	move $t2, $v0
	
##	la $a0, char
##	li $a1, 10
##	li $v0, 8
##	syscall
##	lb $t2, 0($a0)
	
	la $t3, array
	sll $t4, $t0, 2 
	addu $t3, $t3, $t4          # scanf("%c",&a[i]);
	sw $t2, 0($t3)
	
	addi $t0, $t0 ,1            # i++
	bne $s0, $t0, loop1         # i < N
	nop
	
addi $t0, $s0, -1                 # i = N - 1

loop2:
	
	# $t2 = a[j], $t3 = a[i]
	
	la $t4, array
	sll $t5, $t1, 2
	addu $t5, $t4, $t5
	lw $t2, 0($t5)               # $t2 = a[j]
	sll $t5, $t0, 2
	addu $t5, $t4, $t5
	lw $t3, 0($t5)               # $t3 = a[i] 
	
	beq $t2, $t3, out1
	nop
	
	li $a0, 0
	li $v0, 1
	syscall                      # printf("0");
	j end                        # break
	
out1:
	
	
	addi $t1, $t1, 1              # j++ 
	
	blt $t1, $t0, out2            # if(j>=i)
	nop
	
	li $a0, 1
	li $v0, 1
	syscall                      # printf("1");
	j end                        # break
	
out2:
	
	addi $t0, $t0, -1             # i--
	bne $t0, 0, loop2             # i>0
	nop
	
end:

li $v0, 10
syscall
