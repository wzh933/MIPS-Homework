		.data
array:		.word 6,8,3,5,4
mid:		.word 0
		.globl main
		.text
main:		
		la	$a0, array
		li	$a1, 0
		li	$a2, 4
		addiu	$sp, $sp, -24
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 20($sp)
		jal	QuickSort
		lw	$ra, 20($sp)
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 8($sp)
		addiu	$sp, $sp, 24
		
		addiu	$sp, $sp, -16
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 12($sp)
		jal	PrintArray
		lw	$ra, 12($sp)
		addiu	$sp, $sp, 16
		
		li	$v0, 10
		syscall
		
		
QuickSort:	
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 8($sp)
		bge	$a1, $a2, qs_ret
		
		addiu	$sp, $sp, -20
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 16($sp)
		jal	Split
		lw	$ra, 16($sp)
		lw	$v0, 12($sp)
		addiu	$sp, $sp, 20
		
		addi	$t0, $v0, -1
		addi	$t1, $v0, 1
		sw	$t0, 12($sp)
		sw	$t1, 16($sp)
		
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 12($sp)
		addiu	$sp, $sp, -24
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 20($sp)
		jal	QuickSort
		lw	$ra, 20($sp)
		addiu	$sp, $sp, 24
		
		
		lw	$a0, 0($sp)
		lw	$a1, 16($sp)
		lw	$a2, 8($sp)
		addiu	$sp, $sp, -24
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 20($sp)
		jal	QuickSort
		lw	$ra, 20($sp)
		addiu	$sp, $sp, 24
				
qs_ret:		
		jr	$ra
		
	
			
Split:		
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 8($sp)
		li	$t0, 1				# 标志左划分还是右划分
loop:		beq	$a1, $a2, ret
		beqz	$t0, right
left:		beq	$a1, $a2, out_left		# while语句条件判断
		sll	$t1, $a1, 2			
		sll	$t2, $a2, 2			
		add	$t1, $t1, $a0			# t1 = &array + i
		add	$t2, $t2, $a0			# t2 = &array + j
		lw	$t3, ($t1)			# t3 = array[i]  *(t1)
		lw	$t4, ($t2)			# t4 = array[j]  *(t2)
		bgt	$t3, $t4, out_left		# while语句条件判断
		addi	$a2, $a2, -1			# j--
		b	left			
out_left:	sll	$t2, $a2, 2			# 更新j
		add	$t2, $t2, $a0
		lw	$t4, ($t2)			# t4 = array[j]
		sw	$t3, ($t2)			# &array + j = array[i]
		sw	$t4, ($t1)			# &array + i = array[j]
		li	$t0, 0
		b	loop
right:		beq	$a1, $a2, out_right		# while语句条件判断
		sll	$t1, $a1, 2			
		sll	$t2, $a2, 2			
		add	$t1, $t1, $a0			# t1 = &array + i
		add	$t2, $t2, $a0			# t2 = &array + j
		lw	$t3, ($t1)			# t3 = array[i]  *(t1)
		lw	$t4, ($t2)			# t4 = array[j]  *(t2)
		bgt	$t3, $t4, out_right		# while语句条件判断
		addi	$a1, $a1, 1			# i++
		b	right
out_right:	sll	$t1, $a1, 2			# 更新i
		add	$t1, $t1, $a0	
		lw	$t3, ($t1)			# t3 = array[i]
		sw	$t3, ($t2)			# &array + j = array[i]
		sw	$t4, ($t1)			# &array + i = array[j]
		li	$t0, 1
		b	loop
ret:		move	$v0, $a1
		sw	$v0, 12($sp)
		jr	$ra


PrintArray:
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 8($sp)
p_loop:		bgt	$a1, $a2, p_ret
		lw	$t0, ($a0)
		addiu	$sp, $sp, -4
		sw	$a0, 0($sp)
		move	$a0, $t0
		li	$v0, 1
		syscall
		lw	$a0, 0($sp)
		addiu	$sp, $sp, 4
		addi	$a0, $a0, 4
		addi	$a1, $a1, 1
		b	p_loop
p_ret:		jr	$ra
		
				


				
