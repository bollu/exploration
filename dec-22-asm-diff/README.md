Checking out difference in ASM:

Investigating code generation in GHC.
In GHC, we tend to manage our own call stack as a "return stack".
Benchmarking this versus having an actual stack.

In the PNGs, the first is *always* the C version (optimal) and the second
is haskell-like-C.

- https://gist.github.com/bollu/66a445df8e419735b1dab044b5fd0553

# Sources
### C source
```c
#include <stdio.h>

int ackerman(int m, int n) {
    if (m == 0) return n + 1;
    if (m > 0 && n  == 0) return ackerman(m - 1, 1);
    return ackerman(m - 1, ackerman(m, n - 1));
}

int main() {
    printf("%d", ackerman(3, 11));
    return 0;
}

```

### Haskell like C Source

# Perf
### C performance on `-O1`
```
╭─bollu@cantordust ~/work/sxhc/haskell-microbenchmarks/ackerman/c  ‹master*› 
╰─$ sudo perf stat -d ./a.out                   
[sudo] password for bollu: 
16381
 Performance counter stats for './a.out':

        216.792392      task-clock (msec)         #    0.998 CPUs utilized          
                 1      context-switches          #    0.005 K/sec                  
                 0      cpu-migrations            #    0.000 K/sec                  
               110      page-faults               #    0.507 K/sec                  
      64,76,73,623      cycles                    #    2.988 GHz                      (48.41%)
    1,78,49,43,817      instructions              #    2.76  insn per cycle           (61.32%)
      61,55,63,749      branches                  # 2839.416 M/sec                    (61.27%)
          4,01,246      branch-misses             #    0.07% of all branches          (62.82%)
      17,89,24,775      L1-dcache-loads           #  825.328 M/sec                    (60.61%)
       3,29,16,161      L1-dcache-load-misses     #   18.40% of all L1-dcache hits    (26.02%)
            63,958      LLC-loads                 #    0.295 M/sec                    (24.75%)
             5,780      LLC-load-misses           #    9.04% of all LL-cache hits     (35.81%)

       0.217306155 seconds time elapsed
```

### Haskell like C performance on `-O1`

```
╭─bollu@cantordust ~/exploration/dec-22-asm-diff/haskell-like-c  ‹master*› 
╰─$ sudo perf  stat -d ./a.out                                                                                                                                   255 ↵
[sudo] password for bollu: 
16381
 Performance counter stats for './a.out':

        368.344137      task-clock (msec)         #    0.998 CPUs utilized          
                 0      context-switches          #    0.000 K/sec                  
                 0      cpu-migrations            #    0.000 K/sec                  
               112      page-faults               #    0.304 K/sec                  
    1,17,08,87,766      cycles                    #    3.179 GHz                      (50.43%)
    2,01,29,81,158      instructions              #    1.72  insn per cycle           (63.24%)
      35,10,07,332      branches                  #  952.933 M/sec                    (63.64%)
            42,870      branch-misses             #    0.01% of all branches          (64.04%)
      36,08,12,951      L1-dcache-loads           #  979.554 M/sec                    (61.20%)
       3,22,51,684      L1-dcache-load-misses     #    8.94% of all L1-dcache hits    (24.31%)
            63,103      LLC-loads                 #    0.171 M/sec                    (23.97%)
               346      LLC-load-misses           #    0.55% of all LL-cache hits     (37.60%)

       0.369129171 seconds time elapsed
```
# Asm

### C
```asm
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
	jmp	.LBB0_2
.LBB0_1:
	movl	%esi, %eax
.LBB0_2:
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

```

### Haskell like C
```asm
	.text
	.file	"test.c"
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
.Lfunc_end0:
	.size	main_return, .Lfunc_end0-main_return
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
.Lfunc_end1:
	.size	case_ackerman_aval_bdec, .Lfunc_end1-case_ackerman_aval_bdec
	.cfi_endproc
                                        # -- End function
	.globl	ackerman                # -- Begin function ackerman
	.p2align	4, 0x90
	.type	ackerman,@function
ackerman:                               # @ackerman
	.cfi_startproc
# %bb.0:
	movl	%esi, %eax
	testl	%edi, %edi
	je	.LBB2_4
# %bb.1:
	movl	%edi, %ecx
	.p2align	4, 0x90
.LBB2_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_5 Depth 2
	leal	-1(%rcx), %edx
	testl	%eax, %eax
	je	.LBB2_3
	.p2align	4, 0x90
.LBB2_5:                                #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	g_ret_sp(%rip), %rsi
	leal	1(%rsi), %edi
	movl	%edi, g_ret_sp(%rip)
	shlq	$4, %rsi
	movq	$case_ackerman_aval_bdec, g_ret_stack(%rsi)
	movq	%rdx, g_ret_stack+8(%rsi)
	addl	$-1, %eax
	jne	.LBB2_5
.LBB2_3:                                #   in Loop: Header=BB2_2 Depth=1
	addq	$-1, %rcx
	movl	$1, %eax
	testl	%edx, %edx
	jne	.LBB2_2
.LBB2_4:
	movslq	g_ret_sp(%rip), %rcx
	addq	$-1, %rcx
	movl	%ecx, g_ret_sp(%rip)
	shlq	$4, %rcx
	movq	g_ret_stack(%rcx), %rdi
	movq	g_ret_stack+8(%rcx), %rsi
	addl	$1, %eax
	movl	%eax, %edx
	jmpq	*%rdi                   # TAILCALL
.Lfunc_end2:
	.size	ackerman, .Lfunc_end2-ackerman
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
	movslq	g_ret_sp(%rip), %rax
	leal	1(%rax), %ecx
	movl	%ecx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	$main_return, g_ret_stack(%rax)
	movabsq	$223338299444, %rcx     # imm = 0x3400000034
	movq	%rcx, g_ret_stack+8(%rax)
	movl	$3, %edi
	movl	$11, %esi
	callq	ackerman
	xorl	%eax, %eax
	popq	%rcx
	retq
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
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
	.asciz	"%d"
	.size	.L.str, 3

	.type	g_ret_stack,@object     # @g_ret_stack
	.comm	g_ret_stack,16000000,16

	.ident	"clang version 6.0.0 (https://github.com/llvm-mirror/clang.git 40e9a74cba88c271af3407dad30006386881097b) (https://github.com/llvm-mirror/llvm.git 981877461a4a4387994841065d35f4897fe8dfeb)"
	.section	".note.GNU-stack","",@progbits
```