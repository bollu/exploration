/*
# RUN: %loadSimplexhc %s  --jit | FileCheck %s
# CHECK: 7
#
# ack :: Int -> Int -> Int
# ack 0 b = b+1
# ack a 0 = ack (a - 1) 1
# ack a b = ack (a - 1) (ack a (b - 1))

binding ackerman = \(aint: PrimInt, bint: PrimInt) -> PrimInt {
    case aint () of
            0 -> primAdd (bint 1);
            aval -> case primSubtract (aval 1) of
                        adec ->  case bint () of
                                    0 -> ackerman (adec 1);
                                    bval -> case primSubtract (bval 1) of
                                                bdec -> case ackerman (aval bdec) of
                                                    bnew -> ackerman (adec bnew);;;;;
};


binding main = \() -> Boxed {
    case ackerman (3 11) of
        x -> printInt (x); 
};
*/
#include <stdio.h>
#include <assert.h>
#include <memory.h>
#include <stdlib.h>

#define STACK_SIZE 1000000ull

typedef struct Closure {
	void *fn;
	int data1;
} Closure;


typedef void(*VoidFnPtrTy)(Closure c);
typedef void(*IntFnPtrTy)(Closure c, int i);

//Closure *g_ret_stack;
Closure g_ret_stack[STACK_SIZE];
int g_ret_sp = 0;

__attribute__((always_inline))
inline void pushReturn(Closure c) {
	// assert(g_ret_sp <= STACK_SIZE - 1);
	g_ret_stack[g_ret_sp++] = c;
}


__attribute__((always_inline))
inline Closure popReturn() {
	Closure c = g_ret_stack[--g_ret_sp];
	// assert(g_ret_sp >= 0);
	return c;
}

__attribute__((always_inline))
inline Closure mkclosure0(void *f) {
	Closure c;
	c.fn = (void *)f;
	return c;
}


__attribute__((always_inline))
inline Closure mkclosure1(void *f, int i) {
	Closure c;
	c.fn = f;
	c.data1 = i;
	return c;
}

void main_return(Closure c, int i) {
	printf("%d", i);
}


/* forward decl */
inline void ackerman(int i, int j);


void case_ackerman_aval_bdec(Closure c, int bnew) {
	ackerman(c.data1, bnew);
}

void ackerman(const int a, const int b) {
    if (a == 0) {
        const Closure c = popReturn();
        ((IntFnPtrTy)c.fn)(c, b + 1);
    }
    else if (b == 0) {
		ackerman(a - 1, 1);
    }
	else {
		pushReturn(mkclosure1((void *)case_ackerman_aval_bdec, a - 1));
		ackerman(a, b - 1);
	}

}

int main() {
	// g_ret_stack//  = (Closure *)malloc(sizeof(Closure) * STACK_SIZE);
    Closure c = mkclosure0((void *)main_return);
	pushReturn(c);
    ackerman(3, 11);
    return 0;
}
