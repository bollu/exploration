	.text
	.file	"test.c"
	.globl	ackerman                # -- Begin function ackerman
	.p2align	4, 0x90
	.type	ackerman,@function
ackerman:                               # @ackerman
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
                                        # kill: def %edi killed %edi def %rdi
	testl	%edi, %edi
	je	.LBB0_1
	.p2align	4, 0x90
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	leal	-1(%rdi), %ebx
	testl	%edi, %edi
	jle	.LBB0_6
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=1
	movl	$1, %eax
	testl	%esi, %esi
	je	.LBB0_5
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	addl	$-1, %esi
                                        # kill: def %edi killed %edi killed %rdi
	callq	ackerman
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=1
	movl	%eax, %esi
	movl	%ebx, %edi
	testl	%ebx, %ebx
	jne	.LBB0_3
# %bb.2:
	addl	$1, %eax
	popq	%rbx
	retq
.LBB0_1:
	movl	%esi, %eax
	addl	$1, %eax
	popq	%rbx
	retq
.Lfunc_end0:
	.size	ackerman, .Lfunc_end0-ackerman
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
	movl	$3, %edi
	movl	$11, %esi
	callq	ackerman
	movl	%eax, %ecx
	movl	$.L.str, %edi
	xorl	%eax, %eax
	movl	%ecx, %esi
	callq	printf
	xorl	%eax, %eax
	popq	%rcx
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3


	.ident	"clang version 6.0.0 (https://github.com/llvm-mirror/clang.git 40e9a74cba88c271af3407dad30006386881097b) (https://github.com/llvm-mirror/llvm.git 981877461a4a4387994841065d35f4897fe8dfeb)"
	.section	".note.GNU-stack","",@progbits
