# isolate_bit.asm
#  construct a MIPS program that computes the formula y = 9x + 5, where x is an integer given as input by the user and y is the integer printed as output.


.data

input1: 
.asciiz "Enter the number n: "
input2:
.asciiz "Enter the number x: "
errorMessage:
.asciiz "The x value exceedes the limits of 0 through 31"

.text
main:
# iinput for n
li $v0, 4
la $a0, input1
syscall
li $v0, 5
syscall
move $s0,$v0
# input for y
li $v0, 4
la $a0, input2
syscall
li $v0, 5
syscall
move $s1,$v0

# s0 = n     s1 = x

# checks for errors
bltz $s1, error
bgt $s1, 31, error

# sets 2^x
sll $s1, $s1, 1
# srlv is the shift by a dynamic number of places which is set in the sll $s1 which multiplies(shifts) the x number by 2^x then shifts the $t2 n by that many places
# another thing to note in the documentation is that it only does the lower 5 bits which means it can only do 0-31 which for this implementation is fine
srlv $t2,$s0,$s1
# then replace all of the other bits in the binary with 0  with a andi against a binary 1 which is 1 with tailng 0. This returns either 000...0 or 000...1
andi $t3, $t2, 1

# print result
li $v0, 1
move $a0, $t3
syscall
j end
error:
 li $v0, 4
 la $a0, errorMessage
 syscall
end:
li    $v0, 10
syscall               # Done, exit the program
