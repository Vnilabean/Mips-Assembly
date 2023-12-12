.data

arr:
  .space 40 # space for a 10-integer array
prompt:
  .asciiz "how many numbers to input (10 max)?"
newline:
  .asciiz "\n"


.text

main:
  la $a0, prompt  # setup print call
  li $v0, 4       # setup print call
  syscall         # print
  
  li $v0, 5       # setup input call
  syscall         # input
  move $s0, $v0   # save the result (N)
  
  li $t0, 0       # i = 0
  la $t1, arr     # temp = arr

  # loop until we've read N values into the array
mainloop:
  slt $t2, $t0, $s0
  beq $t2, $zero, maindone
  
  # setup syscall and read an int
  li $v0, 5 
  syscall
  
  sw $v0, 0($t1) # save the result to the array
  
  # update i and temp
  addi $t0, $t0, 1
  addi $t1, $t1, 4
  j mainloop
  
maindone:
  # print a blank line to separate the input
  # from the output
  li $v0, 4
  la $a0, newline
  syscall
  
  # call print_powers_of_2
  la   $a0, arr 
  move $a1, $s0 # N is still in $s0 from above
  jal print_powers_of_2
  
  # exit from main
  li $v0, 10
  syscall


print_powers_of_2:
	# a0 = adr   # a1 = n
	
	# since this was called save the rerturn address
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# move the arguemnts to saved and temp registries
	move $s0, $a0 # set s0 to the addr
	move $s1,$a1 # set s1 to n
loop:
	# if n is 0 go to n
	beq $s1, $0, print_powers_of_2done
	# set $s2 to arr[i]
	lw $s2, 0($s0)
	# set args0 to the arr item for ispow2 to use
	move $a0, $s2
	# call ispow2 with args0 being the first item of the array
	jal is_pow_2
	beq $v0, $0, was_false
	
	# if it was true then print the value
	move $a0, $s2
	li $v0, 1
	syscall
	li $v0, 4
 	la $a0, newline
 	syscall
	
was_false:
	# next arr item
	addi $s0, $s0, 4
	# decrease n by 1
	addi $s1, $s1, -1
	j loop	
	
 print_powers_of_2done:
 	# rest the saved values and deallocate the stack and return
 	lw $ra, 0($sp)
 	addi $sp,$sp, 4
 	jr $ra
 

# i could not get the exact c translation to work so I changed it a little, it checks the lsb for a 1 and increases a counter, if that counter goes above 1 then its false
# it still uses the general algorithm from the assignment with the LSB and using &1 and srl and x checking after. it also still uses the counter loop to check all bits
is_pow_2:
	# allocate stack space
	addi $sp, $sp, -4
	# save return addr in stack
 	sw $ra, 0($sp)       
	# set lsb counter to 0
	li $t0, 0
	# set loop counter
	li $t2, 31
	# set return to true, changes to false if condition is met
	li $v0, 1
pow_2_loop:
	beq $t2, $0,  false
	# arr[i] & 1
	andi $t1, $a0, 1
	# if t1 is not equal to 0 "equals 1"
	bne $t1, $0, pow_2_break
	# shift x right by 1 bit
	srl $a0, $a0, 1
	addi $t2, $t2, -1
	j pow_2_loop
	
pow_2_break:
	# increase lsb counter
	addi $t0, $t0 ,1
	# decrease i counter
	addi $t2, $t2, -1
	# shift
	srl $a0, $a0, 1
	# if the lsb counter is greater than 1 then it is not a pow of 2
	bgt $t0, 1, false
	j pow_2_loop
	
false:
	#checks if the lsb counter is equal to 1 and if it is skip to end and return true, if it is >1 or == 0 then returns false
	beq $t0,1, pow_2_end
	li $v0, 0
pow_2_end:
	# return and deallocate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


