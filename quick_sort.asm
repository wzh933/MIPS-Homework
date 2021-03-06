		.data
result:		.asciiz "Sorted array:"
		.align 2
array:		.word 40

		.globl main
		.text
main:		# 输入数组元素
		la	$t0, array
		li	$t1, 5
input:		beqz	$t1, end_input
		li	$v0, 5
		syscall
		sw	$v0, ($t0)
		addi	$t0, $t0, 4
		addi	$t1, $t1, -1
		b 	input

		# 输入参数
end_input:	la	$a0, array		# a0：数组首地址
		li	$a1, 0			# a1：low
		li	$a2, 4			# a2：high
		
		# 调用QuickSort
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
		
		# 调用PrintArray
		addiu	$sp, $sp, -16
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 12($sp)
		jal	PrintArray
		lw	$ra, 12($sp)
		addiu	$sp, $sp, 16
		
		# 结束
		li	$v0, 10
		syscall
		
		
QuickSort:	
		# 加载参数
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 8($sp)
		
		# 递归边界
		bge	$a1, $a2, qs_ret
		
		# 调用Split进行划分
		addiu	$sp, $sp, -20
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 16($sp)
		jal	Split
		lw	$ra, 16($sp)
		lw	$v0, 12($sp)
		addiu	$sp, $sp, 20
		
		# 堆栈中存储mid - 1和mid + 1
		addi	$t0, $v0, -1
		addi	$t1, $v0, 1
		sw	$t0, 12($sp)		# mid - 1
		sw	$t1, 16($sp)		# mid + 1
		
		# 调用QuickSort
		lw	$a0, 0($sp)		# a0：数组首地址
		lw	$a1, 4($sp)		# a1：low
		lw	$a2, 12($sp)		# a2：mid - 1
		addiu	$sp, $sp, -24
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 20($sp)
		jal	QuickSort
		lw	$ra, 20($sp)
		addiu	$sp, $sp, 24
		
		# 调用QuickSort
		lw	$a0, 0($sp)		# a0：数组首地址
		lw	$a1, 16($sp)		# a1：mid + 1
		lw	$a2, 8($sp)		# a2：high
		addiu	$sp, $sp, -24
		sw	$a0, 0($sp)
		sw	$a1, 4($sp)
		sw	$a2, 8($sp)
		sw	$ra, 20($sp)
		jal	QuickSort
		lw	$ra, 20($sp)
		addiu	$sp, $sp, 24
				
qs_ret:		jr	$ra
		
	
			
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
		addiu	$sp, $sp, -4
		sw	$a0, 0($sp)
		la	$a0, result
		li	$v0, 4
		syscall
		lw	$a0, 0($sp)
		addiu	$sp, $sp, 4
p_loop:		bgt	$a1, $a2, p_ret
		lw	$t0, ($a0)
		addiu	$sp, $sp, -4
		sw	$a0, 0($sp)
		move	$a0, $t0
		li	$v0, 1
		syscall
		# 输出空格
		li	$a0, 32
		li	$v0, 11
		syscall
		lw	$a0, 0($sp)
		addiu	$sp, $sp, 4
		addi	$a0, $a0, 4
		addi	$a1, $a1, 1
		b	p_loop
p_ret:		jr	$ra
		
				


				

