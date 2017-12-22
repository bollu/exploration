all: clean build run
build:
	clang test.c -o a.out -O1 
	clang test.c -o a.s -O1  -S
	clang test.c -S -emit-llvm -o test.ll -O1

clean:
	-rm a.out

run:
	time ./a.out
