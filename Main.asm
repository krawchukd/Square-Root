# Test Main
.data
Test_Value: 
	.float 32.0
		
.text
.globl main
main:

#lwc1 $f0, Test_Value		# Load input float into float register.

li $v0, 6
syscall

#mtc1 $v0, $f0


jal sqrt			# Perform function and return value in $f0.
mov.s $f12, $f1 		# Move from register 

li $v0, 2			# Load print float instruction.
syscall				# Perform system call.
 
