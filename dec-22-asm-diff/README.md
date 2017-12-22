Checking out difference in ASM:

Investigating code generation in GHC.
In GHC, we tend to manage our own call stack as a "return stack".
Benchmarking this versus having an actual stack.

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
╰─$ sudo perf stat -d ./a.out
16381
 Performance counter stats for './a.out':

        593.519342      task-clock (msec)         #    0.999 CPUs utilized          
                 1      context-switches          #    0.002 K/sec                  
                 0      cpu-migrations            #    0.000 K/sec                  
               111      page-faults               #    0.187 K/sec                  
    1,70,39,90,940      cycles                    #    2.871 GHz                      (50.26%)
    3,92,42,71,140      instructions              #    2.30  insn per cycle           (62.95%)
      96,23,45,792      branches                  # 1621.423 M/sec                    (63.20%)
            52,883      branch-misses             #    0.01% of all branches          (63.45%)
      81,69,54,402      L1-dcache-loads           # 1376.458 M/sec                    (61.75%)
       3,16,28,281      L1-dcache-load-misses     #    3.87% of all L1-dcache hits    (24.70%)
            32,498      LLC-loads                 #    0.055 M/sec                    (24.36%)
               343      LLC-load-misses           #    1.06% of all LL-cache hits     (37.56%)

       0.594038294 seconds time elapsed

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
	.globl	pushReturn              # -- Begin function pushReturn
	.p2align	4, 0x90
	.type	pushReturn,@function
pushReturn:                             # @pushReturn
	.cfi_startproc
# %bb.0:
	movslq	g_ret_sp(%rip), %rax
	leal	1(%rax), %ecx
	movl	%ecx, g_ret_sp(%rip)
	shlq	$4, %rax
	movq	%rdi, g_ret_stack(%rax)
	movq	%rsi, g_ret_stack+8(%rax)
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
	shlq	$4, %rcx
	movq	g_ret_stack(%rcx), %rax
	movq	g_ret_stack+8(%rcx), %rdx
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
	.comm	g_ret_stack,16000000,16
	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d"
	.size	.L.str, 3


	.ident	"clang version 6.0.0 (https://github.com/llvm-mirror/clang.git 40e9a74cba88c271af3407dad30006386881097b) (https://github.com/llvm-mirror/llvm.git 981877461a4a4387994841065d35f4897fe8dfeb)"
	.section	".note.GNU-stack","",@progbits

```