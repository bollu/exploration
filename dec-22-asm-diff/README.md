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
╭─bollu@cantordust ~/exploration/dec-22-asm-diff/c  ‹master*› 
╰─$ sudo perf stat -d ./a.out
16381
 Performance counter stats for './a.out':

        195.843427      task-clock (msec)         #    0.998 CPUs utilized          
                 0      context-switches          #    0.000 K/sec                  
                 0      cpu-migrations            #    0.000 K/sec                  
               111      page-faults               #    0.567 K/sec                  
      63,98,03,886      cycles                    #    3.267 GHz                      (50.80%)
    1,78,86,31,500      instructions              #    2.80  insn per cycle           (63.24%)
      62,08,15,851      branches                  # 3169.960 M/sec                    (63.24%)
          2,89,099      branch-misses             #    0.05% of all branches          (63.23%)
      18,30,28,830      L1-dcache-loads           #  934.567 M/sec                    (57.56%)
       3,24,91,238      L1-dcache-load-misses     #   17.75% of all L1-dcache hits    (24.60%)
          1,16,904      LLC-loads                 #    0.597 M/sec                    (25.65%)
               210      LLC-load-misses           #    0.18% of all LL-cache hits     (37.67%)

       0.196242193 seconds time elapsed

```

### Haskell like C performance on `-O1`

```
16381
 Performance counter stats for './a.out':

        365.511549      task-clock (msec)         #    0.999 CPUs utilized          
                 2      context-switches          #    0.005 K/sec                  
                 0      cpu-migrations            #    0.000 K/sec                  
               113      page-faults               #    0.309 K/sec                  
    1,17,82,84,369      cycles                    #    3.224 GHz                      (50.43%)
    2,10,87,92,898      instructions              #    1.79  insn per cycle           (63.24%)
      44,02,18,960      branches                  # 1204.391 M/sec                    (63.64%)
            47,825      branch-misses             #    0.01% of all branches          (63.89%)
      36,43,17,693      L1-dcache-loads           #  996.734 M/sec                    (60.85%)
       3,16,54,607      L1-dcache-load-misses     #    8.69% of all L1-dcache hits    (24.24%)
            60,686      LLC-loads                 #    0.166 M/sec                    (25.35%)
               104      LLC-load-misses           #    0.17% of all LL-cache hits     (37.60%)

       0.365935114 seconds time elapsed
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
	jne	.LBB2_2
	jmp	.LBB2_4
	.p2align	4, 0x90
.LBB2_3:                                #   in Loop: Header=BB2_2 Depth=1
	movl	$1, %eax
	testl	%edi, %edi
	je	.LBB2_4
.LBB2_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_5 Depth 2
	addl	$-1, %edi
	testl	%eax, %eax
	je	.LBB2_3
	.p2align	4, 0x90
.LBB2_5:                                #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	g_ret_sp(%rip), %rcx
	leal	1(%rcx), %edx
	movl	%edx, g_ret_sp(%rip)
	shlq	$4, %rcx
	movq	$case_ackerman_aval_bdec, g_ret_stack(%rcx)
	movl	%edi, g_ret_stack+8(%rcx)
	addl	$-1, %eax
	jne	.LBB2_5
	jmp	.LBB2_3
.LBB2_4:
	movslq	g_ret_sp(%rip), %rcx
	addq	$-1, %rcx
	movl	%ecx, g_ret_sp(%rip)
	shlq	$4, %rcx
	movq	g_ret_stack(%rcx), %rdi
	movl	g_ret_stack+8(%rcx), %esi
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