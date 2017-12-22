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
	.intel_syntax noprefix
	.file	"test.c"
	.globl	ackerman                # -- Begin function ackerman
	.p2align	4, 0x90
	.type	ackerman,@function
ackerman:                               # @ackerman
	.cfi_startproc
# %bb.0:
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset rbx, -16
                                        # kill: def %edi killed %edi def %rdi
	test	edi, edi
	je	.LBB0_1
	.p2align	4, 0x90
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	lea	ebx, [rdi - 1]
	test	edi, edi
	jle	.LBB0_6
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=1
	mov	eax, 1
	test	esi, esi
	je	.LBB0_5
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	add	esi, -1
                                        # kill: def %edi killed %edi killed %rdi
	call	ackerman
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=1
	mov	esi, eax
	mov	edi, ebx
	test	ebx, ebx
	jne	.LBB0_3
	jmp	.LBB0_2
.LBB0_1:
	mov	eax, esi
.LBB0_2:
	add	eax, 1
	pop	rbx
	ret
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
	push	rax
	.cfi_def_cfa_offset 16
	mov	edi, 3
	mov	esi, 11
	call	ackerman
	mov	ecx, eax
	mov	edi, offset .L.str
	xor	eax, eax
	mov	esi, ecx
	call	printf
	xor	eax, eax
	pop	rcx
	ret
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
	.intel_syntax noprefix
	.file	"test.c"
	.globl	pushReturn              # -- Begin function pushReturn
	.p2align	4, 0x90
	.type	pushReturn,@function
pushReturn:                             # @pushReturn
	.cfi_startproc
# %bb.0:
	movsxd	rax, dword ptr [rip + g_ret_sp]
	lea	ecx, [rax + 1]
	mov	dword ptr [rip + g_ret_sp], ecx
	shl	rax, 4
	mov	qword ptr [rax + g_ret_stack], rdi
	mov	qword ptr [rax + g_ret_stack+8], rsi
	ret
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
	movsxd	rcx, dword ptr [rip + g_ret_sp]
	add	rcx, -1
	mov	dword ptr [rip + g_ret_sp], ecx
	shl	rcx, 4
	mov	rax, qword ptr [rcx + g_ret_stack]
	mov	rdx, qword ptr [rcx + g_ret_stack+8]
	ret
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
	movabs	rdx, 223338299444
	mov	rax, rdi
	ret
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
	mov	edx, esi
	mov	rax, rdi
	ret
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
	mov	edi, offset .L.str
	xor	eax, eax
	mov	esi, edx
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
	mov	edi, esi
	mov	esi, edx
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
	push	rbp
	.cfi_def_cfa_offset 16
	push	rbx
	.cfi_def_cfa_offset 24
	push	rax
	.cfi_def_cfa_offset 32
	.cfi_offset rbx, -24
	.cfi_offset rbp, -16
	mov	ebx, esi
	mov	ebp, edi
	test	ebp, ebp
	jne	.LBB6_2
	jmp	.LBB6_4
	.p2align	4, 0x90
.LBB6_3:                                #   in Loop: Header=BB6_2 Depth=1
	mov	ebx, 1
	test	ebp, ebp
	je	.LBB6_4
.LBB6_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_5 Depth 2
	add	ebp, -1
	test	ebx, ebx
	je	.LBB6_3
	.p2align	4, 0x90
.LBB6_5:                                #   Parent Loop BB6_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	mov	edi, offset case_ackerman_aval_bdec
	mov	esi, ebp
	call	mkclosure1
	mov	rdi, rax
	mov	rsi, rdx
	call	pushReturn
	add	ebx, -1
	jne	.LBB6_5
	jmp	.LBB6_3
.LBB6_4:
	call	popReturn
	add	ebx, 1
	mov	rdi, rax
	mov	rsi, rdx
	mov	edx, ebx
	add	rsp, 8
	pop	rbx
	pop	rbp
	jmp	rax                     # TAILCALL
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
	push	rax
	.cfi_def_cfa_offset 16
	mov	edi, offset main_return
	call	mkclosure0
	movabs	rsi, 223338299444
	mov	rdi, rax
	call	pushReturn
	mov	edi, 3
	mov	esi, 11
	call	ackerman
	xor	eax, eax
	pop	rcx
	ret
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