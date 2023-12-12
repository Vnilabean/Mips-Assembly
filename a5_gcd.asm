.data

prompt1:
  .asciiz "enter value a: "
prompt2:
  .asciiz "enter value b: "  
newline:
  .asciiz "\n"


.text

main:
  la $a0, prompt1 # setup print call
  li $v0, 4       # setup print call
  syscall         # print
  
  li $v0, 5       # setup input call
  syscall         # input
  move $s0, $v0   # save the result (a)
  
  la $a0, prompt2 # setup print call
  li $v0, 4       # setup print call
  syscall         # print
  
  li $v0, 5       # setup input call
  syscall         # input
  move $s1, $v0   # save the result (b)
  
  # print a blank line to separate the input
  # from the output
  li $v0, 4
  la $a0, newline
  syscall
  
  # call gcd(a, b)
  move $a0, $s0
  move $a1, $s1
  jal gcd
  
  # print the returned value
  move $a0, $v0
  li $v0, 1
  syscall
  
  # exit from main
  li $v0, 10
  syscall
  
gcd:
	# allocate space on stack : since it is recurssive we have to save the s register to keep values after each call
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	# if they are equal then go to return and return a
	beq $a0,$a1, return
	# if b < a then do branch 1 
	blt $a1, $a0, branch1
	#otherwise (else) do other branch
	sub $a1, $a1, $a0
	# call gcd with b = b - a
	jal gcd
	j return

# recursive call for when b < a
branch1:
	sub $a0, $a0, $a1 
	# call gcd with a = a - b
	jal gcd
return:
	move $v0, $a0
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra












