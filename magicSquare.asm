.include "SysCalls.asm"

.data
prompt:	.asciiz "Give me an odd number between 0 and 100: "	#Prompt for the user
newLine: .asciiz "\n"						#New Line 
spce:	.asciiz	" "						#Space

even:	.asciiz	"\nCannot be an even number"
negi:	.asciiz	"\nCannot be a negative number"

array:	.space	10000
.text
main:
la	$a0,	prompt						#Prints the prompt for the user
li	$v0,	SysPrintString
syscall

li	$v0,	SysReadInt					#Reads the integer from keyboard
syscall

add	$s0,	$v0,	$zero					#Move the value to $s0 register

slti	$t0,	$v0,	1
beq	$t0,	1,	exitNegi				#Checks if the given int is negative and exits if true

add	$t0,	$zero,	$zero					#Reset $t0 to 0 (even though if it gets here it won't be >0)

andi	$t0,	$v0,	1
beq	$t0,	0,	exitEven				#Checks if the given int is even and exits if true

add	$t0,	$zero,	$zero					#Reset $t0 to 0

#Set Values
mul	$t9,	$s0,	$s0	#Total number of spaces (N * N)
div	$t8,	$s0,	2	#i = n / 2
subi	$t7,	$s0,	1	#j = n - 1
la	$s1,	array		#base address of the array
addi	$t0,	$0,	1	#num = 1

mul	$t6,	$t8,	$s0	#row number	(i * n)
add	$t6,	$t6,	$t7	#row + col
add	$s2,	$t6,	$s1	#array[i][j]	address

add	$t6,	$0,	$0	#reset $t6
addi	$t4,	$0,	1


j	check1
########################		check the first if statement
check1:					
seq	$t1,	$t8,	-1	#if i == -1
seq	$t2,	$t7,	$s0	#if j == n
and	$t1,	$t1,	$t2	#check if both are true

add	$t1,	$0,	$0	#reset $t1

beq	$t1,	1,	cond3IF
j	cond3ELSE
########################		IF STATEMENT 1
cond3IF:
subi	$t7,	$s0,	2	#j = n - 2
add	$t8,	$0,	$0	#i = 0


j	check2
########################		ELSE STATEMENT 1
cond3ELSE:
seq	$t1,	$t7,	$s0	#if j == n
beq	$t1,	1,	cond3IF2

add	$t1,	$0,	$0	#reset $t1

slt	$t1,	$t8,	$0	#if i < 0
beq	$t1,	1,	cond3IF3	

add	$t1,	$0,	$0	#reset $t1

j	check2
########################
cond3IF2:
add	$t7,	$0,	$0	#j = 0
j	cond3ELSE
########################
cond3IF3:
subi	$t8,	$s0,	1	#i = n - 1
j	check2
########################		check the second if statement
check2:
add	$t6,	$0,	$0	#reset $t6
mul	$t6,	$t8,	$s0	#row number	(i * n)
add	$t6,	$t6,	$t7	#row + col
add	$s2,	$t6,	$s1	#array[i][j]	address
add	$t6,	$0,	$0	#reset $t6

lb	$t3,	0($s2)		#array[i][j]
bne	$t3,	0,	cond2IF	#If array[i][j] is not empty, go to if
j	cond2ELSE
########################		IF STATEMENT 2
cond2IF:
subi	$t7,	$t7,	2	#j = j - 2
addi	$t8,	$t8,	1	#i++

j	check1
########################		ELSE STATEMENT 2
cond2ELSE:
sb	$t0,	0($s2)		#array[i][j] = num
addi	$t0,	$t0,	1	#num++
j	loop
########################		loop it!
loop:
addi	$t7,	$t7,	1	#j++
subi	$t8,	$t8,	1	#i--

bgt 	$t0,	$t9,	print	#if num <= n*n

j	check1
########################
print:	
bge	$s6,	$t9,	exit

add	$s2,	$s6,	$s1	#get address array[i][j]
lb	$a0,	0($s2)		#loads the byte into $a0
li	$v0,	SysPrintInt	#prints the byte
syscall

la	$a0,	spce
li	$v0,	SysPrintString
syscall

addi	$s6,	$s6,	1

beq	$t4,	$s0,	newLn
addi	$t4,	$t4,	1

j	print
newLn:
la	$a0,	newLine
li	$v0,	SysPrintString
syscall

addi	$t4,	$0,	1

j	print
exit:
li	$v0,	SysExit
syscall
########################
exitEven:

la	$a0,	even
li	$v0,	SysPrintString
syscall

li	$v0,	SysExit
syscall
########################
exitNegi:

la	$a0,	negi
li	$v0,	SysPrintString
syscall

li	$v0,	SysExit
syscall