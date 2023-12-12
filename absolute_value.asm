# absolute_value.asm
#
#  construct a MIPS program that reads an integer as input from the keyboard. The program should print the absolute value of that integer as output.
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
		add $t0,$zero, $s0 # adds s0 to t0 incase the number is positive then it will correctly return the value
		srl $t1, $s0, 31 # shift bits to get the MSB for the sign
		beq $t1, $zero, skip # checks for positive agaisnt the MSB that was hisfted to the first bit position // if zero then it is positive
		subu $t0, $zero, $s0 #negate the number using twos compplement

		skip: # skips other instructions if it is positive as AV of a positive is a positive
            move  $s1, $t0        # Save the result

            li    $v0, 1
            move  $a0, $s1
            syscall               # Print the result

            li    $v0, 10
            syscall               # Done, exit the program