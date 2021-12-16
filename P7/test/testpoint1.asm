.ktext 0x4180
	mfc0 $k0, $12
	mfc0 $k0, $13
	mfc0 $k0, $14
	addiu $k1, $k1, 8
	mtc0 $k1, $14
	eret
	mfc0 $k0, $14

.text	
	ori $s0, $0, 0x1001
	ori $s1, $0, 0x1
	mtc0 $s0, $12
	
	# AdEL_Instr
	ori $k1, $0, 0x301c
	ori $1, $0, 0x300e
	ori $2, $0, 0x2fff
	ori $3, $0, 0x6ffd
	jr $1
	nop
	mtc0 $s1, $12
	jr $2
	nop
	mtc0 $s0, $12
	jr $3
	nop
	jalr $31, $1
	nop
	jalr $31, $2
	nop
	jalr $31, $3
	nop

	end:
	beq $0, $0, end
	nop
