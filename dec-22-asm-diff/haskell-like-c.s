	.text
	.file	"test.c"
	.globl	pushReturn              # -- Begin function pushReturn
	.p2align	4, 0x90
	.type	pushReturn,@function
pushReturn:                             # @pushReturn
	.cfi_startproc
# %bb.0:
	movslq	g_ret_sp(%rip), %rax
	cmpq	$1000000, %rax          # imm = 0xF4240
	jae	.LBB0_2
# %bb.1:
	movq	g_ret_stack(%rip), %rcx
	leal	1(%rax), %edx
	movl	%edx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	%rdi, (%rcx,%rax)
	movq	%rsi, 8(%rcx,%rax)
	retq
.LBB0_2:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$.L.str, %edi
	movl	$.L.str.1, %esi
	movl	$47, %edx
	movl	$.L__PRETTY_FUNCTION__.pushReturn, %ecx
	callq	__assert_fail
.Lfunc_end0:
	.size	pushReturn, .Lfunc_end0-pushReturn
	.cfi_endproc
                                        # -- End function
	.globl	popReturn               # -- Begin function popReturn
	.p2align	4, 0x90
	.type	popReturn,@function
popReturn:                              # @popReturn
	.cfi_startproc
# %bb.0:
	movq	g_ret_stack(%rip), %rcx
	movslq	g_ret_sp(%rip), %rax
	leaq	-1(%rax), %rdx
	movl	%edx, g_ret_sp(%rip)
	testq	%rax, %rax
	jle	.LBB1_2
# %bb.1:
	shlq	$4, %rdx
	movq	(%rcx,%rdx), %rax
	movq	8(%rcx,%rdx), %rdx
	retq
.LBB1_2:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$.L.str.2, %edi
	movl	$.L.str.1, %esi
	movl	$54, %edx
	movl	$.L__PRETTY_FUNCTION__.popReturn, %ecx
	callq	__assert_fail
.Lfunc_end1:
	.size	popReturn, .Lfunc_end1-popReturn
	.cfi_endproc
                                        # -- End function
	.globl	mkclosure0              # -- Begin function mkclosure0
	.p2align	4, 0x90
	.type	mkclosure0,@function
mkclosure0:                             # @mkclosure0
	.cfi_startproc
# %bb.0:
	movabsq	$223338299444, %rdx     # imm = 0x3400000034
	movq	%rdi, %rax
	retq
.Lfunc_end2:
	.size	mkclosure0, .Lfunc_end2-mkclosure0
	.cfi_endproc
                                        # -- End function
	.globl	mkclosure1              # -- Begin function mkclosure1
	.p2align	4, 0x90
	.type	mkclosure1,@function
mkclosure1:                             # @mkclosure1
	.cfi_startproc
# %bb.0:
	movl	%esi, %edx
	movq	%rdi, %rax
	retq
.Lfunc_end3:
	.size	mkclosure1, .Lfunc_end3-mkclosure1
	.cfi_endproc
                                        # -- End function
	.globl	main_return             # -- Begin function main_return
	.p2align	4, 0x90
	.type	main_return,@function
main_return:                            # @main_return
	.cfi_startproc
# %bb.0:
	movl	$.L.str.3, %edi
	xorl	%eax, %eax
	movl	%edx, %esi
	jmp	printf                  # TAILCALL
.Lfunc_end4:
	.size	main_return, .Lfunc_end4-main_return
	.cfi_endproc
                                        # -- End function
	.globl	case_ackerman_aval_bdec # -- Begin function case_ackerman_aval_bdec
	.p2align	4, 0x90
	.type	case_ackerman_aval_bdec,@function
case_ackerman_aval_bdec:                # @case_ackerman_aval_bdec
	.cfi_startproc
# %bb.0:
	movl	%esi, %edi
	movl	%edx, %esi
	jmp	ackerman                # TAILCALL
.Lfunc_end5:
	.size	case_ackerman_aval_bdec, .Lfunc_end5-case_ackerman_aval_bdec
	.cfi_endproc
                                        # -- End function
	.globl	ackerman                # -- Begin function ackerman
	.p2align	4, 0x90
	.type	ackerman,@function
ackerman:                               # @ackerman
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%esi, %eax
	testl	%edi, %edi
	je	.LBB6_4
# %bb.1:
	movl	%edi, %r8d
	.p2align	4, 0x90
.LBB6_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_6 Depth 2
	leal	-1(%r8), %edx
	testl	%eax, %eax
	je	.LBB6_3
	.p2align	4, 0x90
.LBB6_6:                                #   Parent Loop BB6_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	g_ret_sp(%rip), %rsi
	cmpq	$1000000, %rsi          # imm = 0xF4240
	jae	.LBB6_9
# %bb.7:                                #   in Loop: Header=BB6_6 Depth=2
	movq	g_ret_stack(%rip), %rdi
	leal	1(%rsi), %ecx
	movl	%ecx, g_ret_sp(%rip)
	shlq	$4, %rsi
	movq	$case_ackerman_aval_bdec, (%rdi,%rsi)
	movq	%rdx, 8(%rdi,%rsi)
	addl	$-1, %eax
	jne	.LBB6_6
.LBB6_3:                                #   in Loop: Header=BB6_2 Depth=1
	addq	$-1, %r8
	movl	$1, %eax
	testl	%edx, %edx
	jne	.LBB6_2
.LBB6_4:
	movq	g_ret_stack(%rip), %rcx
	movslq	g_ret_sp(%rip), %rsi
	leaq	-1(%rsi), %rdx
	movl	%edx, g_ret_sp(%rip)
	testq	%rsi, %rsi
	jle	.LBB6_8
# %bb.5:
	shlq	$4, %rdx
	movq	(%rcx,%rdx), %rdi
	movq	8(%rcx,%rdx), %rsi
	addl	$1, %eax
	movl	%eax, %edx
	popq	%rax
	jmpq	*%rdi                   # TAILCALL
.LBB6_9:
	movl	$.L.str, %edi
	movl	$.L.str.1, %esi
	movl	$47, %edx
	movl	$.L__PRETTY_FUNCTION__.pushReturn, %ecx
	callq	__assert_fail
.LBB6_8:
	movl	$.L.str.2, %edi
	movl	$.L.str.1, %esi
	movl	$54, %edx
	movl	$.L__PRETTY_FUNCTION__.popReturn, %ecx
	callq	__assert_fail
.Lfunc_end6:
	.size	ackerman, .Lfunc_end6-ackerman
	.cfi_endproc
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$16000000, %edi         # imm = 0xF42400
	callq	malloc
	movq	%rax, g_ret_stack(%rip)
	movslq	g_ret_sp(%rip), %rcx
	cmpq	$1000000, %rcx          # imm = 0xF4240
	jae	.LBB7_15
# %bb.1:
	leaq	1(%rcx), %rdx
	movl	%edx, g_ret_sp(%rip)
	movq	%rcx, %rsi
	shlq	$4, %rsi
	movq	$main_return, (%rax,%rsi)
	movabsq	$223338299444, %rdi     # imm = 0x3400000034
	movq	%rdi, 8(%rax,%rsi)
	cmpl	$1000000, %edx          # imm = 0xF4240
	jae	.LBB7_15
# %bb.2:
	movq	g_ret_stack(%rip), %rsi
	leaq	2(%rcx), %rax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$1000000, %eax          # imm = 0xF4240
	jae	.LBB7_15
# %bb.3:
	movq	g_ret_stack(%rip), %rsi
	leaq	3(%rcx), %rdx
	movl	%edx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	$case_ackerman_aval_bdec, (%rsi,%rax)
	movq	$2, 8(%rsi,%rax)
	cmpl	$999999, %edx           # imm = 0xF423F
	ja	.LBB7_15
# %bb.4:
	movq	g_ret_stack(%rip), %rsi
	leaq	4(%rcx), %rax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$999999, %eax           # imm = 0xF423F
	ja	.LBB7_15
# %bb.5:
	movq	g_ret_stack(%rip), %rsi
	leaq	5(%rcx), %rdx
	movl	%edx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	$case_ackerman_aval_bdec, (%rsi,%rax)
	movq	$2, 8(%rsi,%rax)
	cmpl	$999999, %edx           # imm = 0xF423F
	ja	.LBB7_15
# %bb.6:
	movq	g_ret_stack(%rip), %rsi
	leaq	6(%rcx), %rax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$999999, %eax           # imm = 0xF423F
	ja	.LBB7_15
# %bb.7:
	movq	g_ret_stack(%rip), %rsi
	leal	7(%rcx), %edx
	movl	%edx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	$case_ackerman_aval_bdec, (%rsi,%rax)
	movq	$2, 8(%rsi,%rax)
	cmpl	$999999, %edx           # imm = 0xF423F
	ja	.LBB7_15
# %bb.8:
	movslq	%edx, %rdx
	movq	g_ret_stack(%rip), %rsi
	leal	8(%rcx), %eax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$999999, %eax           # imm = 0xF423F
	ja	.LBB7_15
# %bb.9:
	movslq	%eax, %rdx
	movq	g_ret_stack(%rip), %rsi
	leal	9(%rcx), %eax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$999999, %eax           # imm = 0xF423F
	ja	.LBB7_15
# %bb.10:
	movslq	%eax, %rdx
	movq	g_ret_stack(%rip), %rsi
	leal	10(%rcx), %eax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$999999, %eax           # imm = 0xF423F
	ja	.LBB7_15
# %bb.11:
	movslq	%eax, %rdx
	movq	g_ret_stack(%rip), %rsi
	leal	11(%rcx), %eax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$999999, %eax           # imm = 0xF423F
	ja	.LBB7_15
# %bb.12:
	movslq	%eax, %rdx
	movq	g_ret_stack(%rip), %rsi
	leal	12(%rcx), %eax
	movl	%eax, g_ret_sp(%rip)
	shlq	$4, %rdx
	movq	$case_ackerman_aval_bdec, (%rsi,%rdx)
	movq	$2, 8(%rsi,%rdx)
	cmpl	$1000000, %eax          # imm = 0xF4240
	jae	.LBB7_15
# %bb.13:
	cltq
	movq	g_ret_stack(%rip), %rdx
	addl	$13, %ecx
	movl	%ecx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	$case_ackerman_aval_bdec, (%rdx,%rax)
	movq	$1, 8(%rdx,%rax)
	cmpl	$1000000, %ecx          # imm = 0xF4240
	jae	.LBB7_15
# %bb.14:
	movslq	%ecx, %rax
	movq	g_ret_stack(%rip), %rdx
	shlq	$4, %rax
	movq	$case_ackerman_aval_bdec, (%rdx,%rax)
	movq	$0, 8(%rdx,%rax)
	movq	g_ret_stack(%rip), %rdx
	movl	%ecx, g_ret_sp(%rip)
	movq	(%rdx,%rax), %rdi
	movq	8(%rdx,%rax), %rsi
	movl	$2, %edx
	callq	*%rdi
	xorl	%eax, %eax
	popq	%rcx
	retq
.LBB7_15:
	movl	$.L.str, %edi
	movl	$.L.str.1, %esi
	movl	$47, %edx
	movl	$.L__PRETTY_FUNCTION__.pushReturn, %ecx
	callq	__assert_fail
.Lfunc_end7:
	.size	main, .Lfunc_end7-main
	.cfi_endproc
                                        # -- End function
	.type	g_ret_sp,@object        # @g_ret_sp
	.bss
	.globl	g_ret_sp
	.p2align	2
g_ret_sp:
	.long	0                       # 0x0
	.size	g_ret_sp, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"g_ret_sp <= STACK_SIZE - 1"
	.size	.L.str, 27

	.type	.L.str.1,@object        # @.str.1
.L.str.1:
	.asciz	"test.c"
	.size	.L.str.1, 7

	.type	.L__PRETTY_FUNCTION__.pushReturn,@object # @__PRETTY_FUNCTION__.pushReturn
.L__PRETTY_FUNCTION__.pushReturn:
	.asciz	"void pushReturn(Closure)"
	.size	.L__PRETTY_FUNCTION__.pushReturn, 25

	.type	g_ret_stack,@object     # @g_ret_stack
	.comm	g_ret_stack,8,8
	.type	.L.str.2,@object        # @.str.2
.L.str.2:
	.asciz	"g_ret_sp >= 0"
	.size	.L.str.2, 14

	.type	.L__PRETTY_FUNCTION__.popReturn,@object # @__PRETTY_FUNCTION__.popReturn
.L__PRETTY_FUNCTION__.popReturn:
	.asciz	"Closure popReturn()"
	.size	.L__PRETTY_FUNCTION__.popReturn, 20

	.type	.L.str.3,@object        # @.str.3
.L.str.3:
	.asciz	"%d"
	.size	.L.str.3, 3


	.ident	"clang version 6.0.0 (https://github.com/llvm-mirror/clang.git 40e9a74cba88c271af3407dad30006386881097b) (https://github.com/llvm-mirror/llvm.git 981877461a4a4387994841065d35f4897fe8dfeb)"
	.section	".note.GNU-stack","",@progbits
