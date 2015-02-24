## David Krawchuk 
## 11/18/2013
## SquareRoots
##
## Function name : sqrt
## This function calculates square roots. The function takes one parameter in register $f0
## 	and returns the calculated value in register $f1 when finished. If given a negative
##	value then the function will print an error message and then return a value 0 in register $f1.

# Data Block #
.data
# Constant value zero
zero: 
	.float 0.0
# Constant value one
one:
	.float 1.0
# Constant value two
two:
	.float 2.0
# Error statement ; used when input value is negative.
error_statement:
	.asciiz "\nInput value is negative!\n"

# END Data Block #

# Function Body #
.globl sqrt
.text
sqrt:

## Negative Condition Test Block ##
# Used Registers : 
# $f0 = function input
# $f31 = zero (const.)
l.s $f31, zero						# Load register $f31 with value zero constant for comparison to input.
c.lt.s $f0, $f31					# Compare input paragmeter with zero constant; if negative set flag to 1 (1 = False).	
bc1t error 						# Break to ERROR BLOCK of function if flag value is 1; else continue to Base Calculation Block.
## End N.C.T.B.##

## Base Calculation Block ##
# Used registers :
# $f30 = one (const.)
# $f29 = two (const.)
# $f2 = calculated result
# $f0 = input parameter
l.s $f30, one						# Set register $f30 to the float value 1.0.
l.s $f29, two						# Set register $f29 to the float value 2.0.
add.s $f2, $f0, $f30					# Represents (input + 1)
div.s $f2, $f2, $f29					# Represents (input + 1) / 2
## End B.C.B.##

## Approximation Block ##
# Used Registers :
# $t0 = loop counter
# $f3 = result of Xsub(i - 1) / 2
# $f2 = Xsub(i-1)
# $f29 = 2
# $f4 = 2 * Xsub(i - 1)
# $f5 = input / ($f4)
li $t0, 1						# Set counter register $t0 to the value one; used for loop constraint. 

approximation_loop:					
beq $t0, 10, end_approximation_loop			# Break to end of loop after nine itterations of loop. 
							# Note: first itteration performed in Base Calculation Block.

div.s $f3, $f2, $f29					# Calculates Xsub(i - 1) / 2; places results in $f3.
mul.s $f4, $f29, $f2					# Calculates 2 * Xsub(i - 1)
div.s $f5, $f0, $f4					# Calculates INPUT / $f4
add.s $f2, $f3, $f5					# Calculates $f3 + $f5; Xsub(i-1) / 2 + (2 * Xsub(i - 1)

addi $t0, $t0, 1					# Add one to the loop counter.

j approximation_loop					# Return to the begenning of the approximation_loop.

end_approximation_loop:
## End Approximation Block ##

mov.s $f1, $f2						# Move calculated contents from appoximation loop from $f2 to return register $f1.

jr $ra							# Return to caller address.

sqrt_end:
## END FUNCTION BODY ##

## ERROR BLOCK ##
error:
l.s $f0, zero						# Set return register $f0 to value 0.

li $v0, 4						# Load instruction 4 into $v0; value 4 : print string instruction.
la $a0, error_statement					# Load address of string statement.
syscall							# Perform system call.

jr $ra							# Return to caller address.
error_end:
## END ERROR BLOCK ##
