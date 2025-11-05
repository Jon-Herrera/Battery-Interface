	.file	"batt_update.c"
	.text
	.globl	set_batt_from_ports
	.type	set_batt_from_ports, @function
set_batt_from_ports:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movzwl	BATT_VOLTAGE_PORT(%rip), %eax
	cwtl
	movl	%eax, -12(%rbp)
	movzbl	BATT_STATUS_PORT(%rip), %eax
	movzbl	%al, %eax
	movl	%eax, -16(%rbp)
	cmpl	$0, -12(%rbp)
	jns	.L2
	movl	$1, %eax
	jmp	.L3
.L2:
	movl	-12(%rbp), %eax
	movl	%eax, -20(%rbp)
	sarl	-20(%rbp)
	movl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-20(%rbp), %eax
	subl	$3000, %eax
	sarl	$3, %eax
	movl	%eax, -8(%rbp)
	cmpl	$0, -8(%rbp)
	jns	.L4
	movl	$0, -8(%rbp)
.L4:
	cmpl	$100, -8(%rbp)
	jle	.L5
	movl	$100, -8(%rbp)
.L5:
	movl	-16(%rbp), %eax
	andl	$16, %eax
	testl	%eax, %eax
	je	.L6
	movb	$1, -1(%rbp)
	jmp	.L7
.L6:
	movb	$2, -1(%rbp)
.L7:
	movl	-20(%rbp), %eax
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movw	%dx, (%rax)
	movl	-8(%rbp), %eax
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movb	%dl, 2(%rax)
	movq	-40(%rbp), %rax
	movzbl	-1(%rbp), %edx
	movb	%dl, 3(%rax)
	movl	$0, %eax
.L3:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	set_batt_from_ports, .-set_batt_from_ports
	.globl	set_display_from_batt
	.type	set_display_from_batt, @function
set_display_from_batt:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -52(%rbp)
	movq	%rsi, -64(%rbp)
	movabsq	$539707816539784767, %rax
	movq	%rax, -34(%rbp)
	movw	$28543, -26(%rbp)
	movl	$0, -4(%rbp)
	movl	$0, -8(%rbp)
	movl	$0, -12(%rbp)
	movq	-64(%rbp), %rax
	movl	$0, (%rax)
	movzbl	-49(%rbp), %eax
	cmpb	$1, %al
	jne	.L9
	movzbl	-50(%rbp), %eax
	movsbl	%al, %eax
	movl	%eax, -24(%rbp)
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$1, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	movl	-24(%rbp), %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	movl	%eax, %ecx
	sarl	$2, %ecx
	movl	%edx, %eax
	sarl	$31, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -8(%rbp)
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	subl	%eax, %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	sarl	$2, %eax
	movl	%edx, %ecx
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -12(%rbp)
	movl	-24(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1374389535, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$5, %edx
	sarl	$31, %eax
	subl	%eax, %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	sarl	$2, %eax
	movl	%edx, %ecx
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L10
	movq	-64(%rbp), %rax
	movl	(%rax), %edx
	movl	-4(%rbp), %eax
	cltq
	movzbl	-34(%rbp,%rax), %eax
	movsbl	%al, %eax
	sall	$17, %eax
	orl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L10:
	cmpl	$0, -12(%rbp)
	jne	.L11
	cmpl	$0, -4(%rbp)
	je	.L12
.L11:
	movq	-64(%rbp), %rax
	movl	(%rax), %edx
	movl	-12(%rbp), %eax
	cltq
	movzbl	-34(%rbp,%rax), %eax
	movsbl	%al, %eax
	sall	$10, %eax
	orl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L12:
	movq	-64(%rbp), %rax
	movl	(%rax), %edx
	movl	-8(%rbp), %eax
	cltq
	movzbl	-34(%rbp,%rax), %eax
	movsbl	%al, %eax
	sall	$3, %eax
	orl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	jmp	.L13
.L9:
	movzbl	-49(%rbp), %eax
	cmpb	$2, %al
	jne	.L13
	movzwl	-52(%rbp), %eax
	cwtl
	movl	%eax, -20(%rbp)
	movl	$0, -16(%rbp)
	movl	-20(%rbp), %ecx
	movslq	%ecx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	movl	%eax, %edx
	sarl	$2, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	cmpl	$5, %edx
	jle	.L14
	movl	$1, -16(%rbp)
.L14:
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$2, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$4, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1717986919, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$2, %edx
	sarl	$31, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movslq	%ecx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	movl	%eax, %edx
	sarl	$2, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	addl	%eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -8(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$1374389535, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$5, %edx
	sarl	$31, %eax
	subl	%eax, %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	sarl	$2, %eax
	movl	%edx, %ecx
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, -12(%rbp)
	movl	-12(%rbp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -12(%rbp)
	movl	-20(%rbp), %eax
	movslq	%eax, %rdx
	imulq	$274877907, %rdx, %rdx
	shrq	$32, %rdx
	sarl	$6, %edx
	sarl	$31, %eax
	subl	%eax, %edx
	movslq	%edx, %rax
	imulq	$1717986919, %rax, %rax
	shrq	$32, %rax
	sarl	$2, %eax
	movl	%edx, %ecx
	sarl	$31, %ecx
	subl	%ecx, %eax
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %ecx
	movl	%ecx, %eax
	sall	$2, %eax
	addl	%ecx, %eax
	addl	%eax, %eax
	subl	%eax, %edx
	movl	%edx, -4(%rbp)
	cmpl	$10, -8(%rbp)
	jne	.L15
	movl	$0, -8(%rbp)
	addl	$1, -12(%rbp)
	cmpl	$10, -12(%rbp)
	jne	.L15
	movl	$0, -12(%rbp)
	addl	$1, -4(%rbp)
.L15:
	movq	-64(%rbp), %rax
	movl	(%rax), %edx
	movl	-4(%rbp), %eax
	cltq
	movzbl	-34(%rbp,%rax), %eax
	movsbl	%al, %eax
	sall	$17, %eax
	orl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	movq	-64(%rbp), %rax
	movl	(%rax), %edx
	movl	-12(%rbp), %eax
	cltq
	movzbl	-34(%rbp,%rax), %eax
	movsbl	%al, %eax
	sall	$10, %eax
	orl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	movq	-64(%rbp), %rax
	movl	(%rax), %edx
	movl	-8(%rbp), %eax
	cltq
	movzbl	-34(%rbp,%rax), %eax
	movsbl	%al, %eax
	sall	$3, %eax
	orl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L13:
	movzbl	-50(%rbp), %eax
	cmpb	$5, %al
	jle	.L16
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$16777216, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L16:
	movzbl	-50(%rbp), %eax
	cmpb	$29, %al
	jle	.L17
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$33554432, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L17:
	movzbl	-50(%rbp), %eax
	cmpb	$49, %al
	jle	.L18
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$67108864, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L18:
	movzbl	-50(%rbp), %eax
	cmpb	$69, %al
	jle	.L19
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$134217728, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L19:
	movzbl	-50(%rbp), %eax
	cmpb	$89, %al
	jle	.L20
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	orl	$268435456, %eax
	movl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
.L20:
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	set_display_from_batt, .-set_display_from_batt
	.globl	batt_update
	.type	batt_update, @function
batt_update:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	$0, -8(%rbp)
	leaq	-4(%rbp), %rax
	movq	%rax, %rdi
	call	set_batt_from_ports
	testl	%eax, %eax
	je	.L23
	movl	$1, %eax
	jmp	.L26
.L23:
	leaq	-8(%rbp), %rdx
	movl	-4(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	set_display_from_batt
	testl	%eax, %eax
	je	.L25
	movl	$1, %eax
	jmp	.L26
.L25:
	movl	-8(%rbp), %eax
	movl	%eax, BATT_DISPLAY_PORT(%rip)
	movl	$0, %eax
.L26:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	batt_update, .-batt_update
	.ident	"GCC: (GNU) 14.2.0"
	.section	.note.GNU-stack,"",@progbits
