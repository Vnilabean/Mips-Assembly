# formula.asm
#
# This MIPS program accepts an integer as input and prints that integer as output.
# Modify the program so that it computes the formula y = 9x + 5 and prints that as output.
# The provided code is assuming that you compute the result in $t0 (which it then moves into $s1).

            .data
prompt:
            .asciiz "Enter an integer: "

            .text
main:
            li    $v0, 4
            la    $a0, prompt
            syscall               # Print input prompt

            li    $v0, 5
            syscall               # Input the integer

            move  $s0, $v0        # Save the result

            # Put your instructions here
		# Since I can oinly use add, addi, or sub i will multiply by looping a add 9 x times then adding 5 after
		li $t1, 0 # sets counter
		beq $s0,$zero, skip # if x is 0 then skip to +5
		loop:
		addi $t0, $t0, 9 # add 9 to total
		addi $t1, $t1, 1 # add to counter
		bne $t1, $s0, loop # iff the counter is not equal to x then go back to the top of the loop
		skip:
		addi $t0, $t0, 5 #add the remaining 5
		
		
            move  $s1, $t0        # Save the result

            li    $v0, 1
            move  $a0, $s1
            syscall               # Print the result

            li    $v0, 10
            syscall               # Done, exit the program