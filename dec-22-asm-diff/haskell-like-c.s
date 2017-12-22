	.text
	.file	"test.c"
	.globl	pushReturn              # -- Begin function pushReturn
	.p2align	4, 0x90
	.type	pushReturn,@function
pushReturn:                             # @pushReturn
	.cfi_startproc
# %bb.0:
	movq	g_ret_stack(%rip), %rax
	movslq	g_ret_sp(%rip), %rcx
	leal	1(%rcx), %edx
	movl	%edx, g_ret_sp(%rip)
	shlq	$4, %rcx
	movq	%rdi, (%rax,%rcx)
	movq	%rsi, 8(%rax,%rcx)
	retq
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
	movslq	g_ret_sp(%rip), %rcx
	addq	$-1, %rcx
	movl	%ecx, g_ret_sp(%rip)
	movq	g_ret_stack(%rip), %rdx
	shlq	$4, %rcx
	movq	(%rdx,%rcx), %rax
	movq	8(%rdx,%rcx), %rdx
	retq
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
	movl	$.L.str, %edi
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
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	pushq	%rax
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -24
	.cfi_offset %rbp, -16
	movl	%esi, %ebx
	movl	%edi, %ebp
	testl	%ebp, %ebp
	jne	.LBB6_2
	jmp	.LBB6_4
	.p2align	4, 0x90
.LBB6_3:                                #   in Loop: Header=BB6_2 Depth=1
	movl	$1, %ebx
	testl	%ebp, %ebp
	je	.LBB6_4
.LBB6_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_5 Depth 2
	addl	$-1, %ebp
	testl	%ebx, %ebx
	je	.LBB6_3
	.p2align	4, 0x90
.LBB6_5:                                #   Parent Loop BB6_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$case_ackerman_aval_bdec, %edi
	movl	%ebp, %esi
	callq	mkclosure1
	movq	%rax, %rdi
	movq	%rdx, %rsi
	callq	pushReturn
	addl	$-1, %ebx
	jne	.LBB6_5
	jmp	.LBB6_3
.LBB6_4:
	callq	popReturn
	addl	$1, %ebx
	movq	%rax, %rdi
	movq	%rdx, %rsi
	movl	%ebx, %edx
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	jmpq	*%rax                   # TAILCALL
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
	movl	$main_return, %edi
	callq	mkclosure0
	movabsq	$223338299444, %rsi     # imm = 0x3400000034
	movq	%rax, %rdi
	callq	pushReturn
	movl	$3, %edi
	movl	$11, %esi
	callq	ackerman
	xorl	%eax, %eax
	popq	%rcx
	retq
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

	.type	g_ret_stack,@object     # @g_ret_stack
	.comm	g_ret_stack,8,8
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3


	.ident	"clang version 6.0.0 (https://github.com/llvm-mirror/clang.git 40e9a74cba88c271af3407dad30006386881097b) (https://github.com/llvm-mirror/llvm.git 981877461a4a4387994841065d35f4897fe8dfeb)"
	.section	".note.GNU-stack","",@progbits
