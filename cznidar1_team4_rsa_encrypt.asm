.data
	#Buffer
	decrypted_textbuffer: .space 100
	plaintext_buffer: .space 100
	ciphertext_buffer: .word 100
	
	file_descriptor: .space 16
	print_buffer: .space 8
	
	
	
	var_input_number_p:	.asciiz "Please enter a positive integer p where p<50:"
	var_input_number_q:	.asciiz "Please enter a positive integer q where q<50:"
	var_is_prime1:		.asciiz "Integer p: "
	var_is_prime2:		.asciiz " is a prime number."
	var_is_prime3:		.asciiz "Integer q: "
	var_is_prime4:		.asciiz " is a prime number."
	var_is_not_prime:	.asciiz "These are not prime numbers."
	next_line: 		.asciiz "\n"
	Result1:		.asciiz "The modulus n is: "
	Result2:		.asciiz "The totient phi(n) is: "
	public_key_exp:		.asciiz "Please enter a small public key exponent value e: "
	e_is_not_positive:	.asciiz "e is not a positive number."
	e_is_greater_than_phi:	.asciiz "e is greater than the totient."
	GCD_answer:		.asciiz "The GCD of e and the totient is: "
	not_coprime:		.asciiz "e is not co-prime to the totient."
	x_integer:		.asciiz "Enter a value for integer x: "
	private_key:		.asciiz "The private key d is: "
	input_message:		.asciiz "Enter message:"
	message:		.space 28
	output_message:		.asciiz "You wrote: "
	file:  			.asciiz "test.txt"
	file_encrypted:        .asciiz "encrypted"
	file_decrypted:        .asciiz "plaintext"

    
.text
#Michael Goulard
main:
	
	li $v0,4			#Prompting the user to enter a positive integer p
	la $a0, var_input_number_p
	syscall				# call print on the integer located at address in a0
	
	li $v0,5			#Reading the integer value inputed from the user
	syscall
	
	move $8, $v0			#moving the integer to register 8
	
	li $v0,4			#Prompting the user to enter a positive integer q
	la $a0, var_input_number_q
	syscall				# call print on the integer located at address in a0
	
	li $v0,5			#Reading the integer value inputed from the user
	syscall
	
	move $11, $v0			#moving the integer to register 8
	
	li $9, 2			#register 9 is a constant 2
	
	
	blt $8, 1, isNotPrime		#if the number is less than 1 go to isNotPrime
	beq $8, 1, isNotPrime		#if the number is equal to 1 go to isNotPrime
	beq $8, 2, prime		#if the number is 2 go to isPrime
    
   	blt $11, 1, isNotPrime		#if the number is less than 1 go to isNotPrime
	beq $11, 1, isNotPrime		#if the number is equal to 1 go to isNotPrime
	beq $11, 2, prime		#if the number is 2 go to isPrime
	
   	loopPrime:			#the loopprime tests if the number is prime
   		beq $9,$8,prime
   		div $8, $9		#successfully divide input by numbers in range
   		mfhi $10		#move division remainder to register 10
   		beq $10,$0,isNotPrime   #if the remainder is equal to zero, it is not prime
   		addi $9,$9,1		#increment
   		
   		beq $9,$11,prime
   		div $11, $9		#successfully divide input by numbers in range
   		mfhi $10		#move division remainder to register 10
   		beq $10,$0,isNotPrime   #if the remainder is equal to zero, it is not prime
   		addi $9,$9,1		#increment
   		
   		b loopPrime		#back to top of loop
   		
   #Michael Goulard	
   isNotPrime:
   	
    	li $v0, 4			#printing the string
   	la $a0, var_is_not_prime
   	syscall				# call print on the string located at address in a0
   	
    	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
   	
   	b exitLabel			#finish program
   #Michael Goulard	
   exitLabel:
   	li $v0,10			#ends program
   	syscall
   #Michael Goulard
   prime:

	li $v0, 4			#printing the string
   	la $a0, var_is_prime1
   	syscall				# call print on the string located at address in a0
   	
   	li $v0, 1			#printing the integer
    	move $a0, $8			#moving the inputed integer to register a0
    	syscall				#call print on the integer located at address in a0
    	
    	li $v0, 4			#printing the string
   	la $a0, var_is_prime2
   	syscall				# call print on the string located at address in a0
   	
   	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
   	
   	li $v0, 4			#printing the string
   	la $a0, var_is_prime3
   	syscall				# call print on the string located at address in a0
   	
   	li $v0, 1			#printing the integer
    	move $a0, $9			#moving the inputed integer to register a0
    	syscall				#call print on the integer located at address in a0
    	
    	li $v0, 4			#printing the string
   	la $a0, var_is_prime4
   	syscall				# call print on the string located at address in a0
   	
   	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
	
	mult $8, $11			#calculating the modulus n
	li $v0, 4			#printing the string for the modulus n
	la $a0, Result1
	syscall				# call print on the string located at address in a0
	li $v0, 1			#printing the integer
	mflo $a0			#contents of low register hold the product of p and q
	syscall				# call print on the string located at address in a0
	
	
	move $s0, $a0 # <------------------------------------------------------------------------------------- SAVING "n" IN $S0 TO BE ACCESSED BY "iterateThroughInput:"
	
	
	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
	
	sub $12, $8, 1			# subtracting 1 from p and storing it in $12
	sub $13, $11, 1			# subtracting 1 from q and storing it in $13
	mult $12, $13			# calculating the totient phi(n)
	li $v0, 4			#printing the string for the totient
	la $a0, Result2
	syscall				# call print on the string located at address in a0
	li $v0, 1			#printing the integer
	mflo $a0			#contents of low register hold the product of p-1 and q-1
	syscall				# call print on the string located at address in a0
	
	move $15, $a0
	
	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
	
	j cpubexp			#jump to cpubexp
#Michael Goulard	
cpubexp:
	li $v0,4			#Prompting the user to enter a exp value e
	la $a0, public_key_exp
	syscall				# call print on the integer located at address in a0
	
	li $v0,5			#Reading the integer value inputed from the user
	syscall
	
	move $14, $v0			#moving the integer to register 14
	
	blt $14, 1, exitLabel2		#end program if e is not a positive number
	bgt $14, $15, exitLabel3	#end program if e is greater than the totient
	
	move $a0, $14			#moving e into $a0
	move $a1, $15			#moving the totient into $a1
	
	jal GCD				#calling the GCD function
	move $24, $v0			#returning the value
	
	li $v0, 4			#printing the GCD string
	la $a0, GCD_answer
	syscall				# call print on the string located at address in a0
	
	li $v0, 1			#printing the integer
	move $a0, $24			#moving the GCD to $a0
	syscall				# call print on the string located at address in a0
	
	bne $24, 1, not_coprime1	#end program if the GCD is not 1
	
	move $a0, $14			#moving e into $a0
	move $a1, $15			#moving the totient into $a1
	
	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
	
	
	
	
	#li $v0,4			#Prompting the user to enter an integer x
	#la $a0, x_integer
	#syscall			# call print on the integer located at address in a0
	
	#li $v0,5			#Reading the integer value inputed from the user
	#syscall
	
	#move $25, $v0			#moving the integer to register 25
	
	#move $a2, $25			#moving the x integer into $a2
	
	
	
	
	
	j cprivexp			#jump to calculating the private key d
	
	j exitLabel			#exit Program
#Michael Goulard	
GCD:
	addi $sp, $sp, -12
	subu $sp, $sp, 4 		# points to the next item on top
	sw $a0, ($sp) 			# store on the top of the stack
	subu $sp,$sp,4 			# points to the next item on top
	sw $a1,($sp) 			# store on the top of the stack
	subu $sp,$sp,4			# points to the next item on top
	sw $ra,($sp) 			# store on the top of the stack
	move $v0,$a0 			# move $a0 to $v0
	beqz $a1,returnGCD
	div $v0,$a0,$a1 		# dividing e and the totient and storing in $v0
	mfhi $v0 			# the high register stores the remainder
	move $a0,$a1 			# e = totient;
	move $a1,$v0 			# totient = n;
	jal GCD
#Michael Goulard	
returnGCD:
	lw $ra,($sp) 			# store on the top of the stack
	addu $sp,$sp,4 			# points to the next item on top
	lw $a1,($sp) 			# store on the top of the stack
	addu $sp,$sp,4 			# points to the next item on top
	lw $a0,($sp) 			# store on the top of the stack
	addu $sp,$sp,4 			# points to the next item on top
	addi $sp, $sp, 12
	jr $ra				# return GCD


#Michael Goulard
#Christian Znidarsic	
cprivexp:
	
	li $a2, 0	# initialize x to 1
	move $a0, $14	# moving e into $a0
	
	privLoop:
		add $a2, $a2, 1	#increment the counter in $a2 by 1
		
		
		mult $a1, $a2			#multiply x and the totient
		mflo $v0			#moving the value to register $v0
		move $21, $v0			#moving to register $21
		add $21, $21, 1			#adding one to the numerator
		div $21, $a0			#performing the division
		mfhi $t9			#storing the remainder
		mflo $v1			#storing the quotient
		
		
		move $19, $v1			#moving quotient to register $19
		
		bne $t9, $zero, privLoop	#if remainder is not zero, then try another value of x
		
	
	li $v0, 4			#printing the string
   	la $a0, private_key
   	syscall				# call print on the string located at address in a0
	
	
	li $v0, 1			#printing the integer
	move $a0, $19
	syscall				# call print on the string located at address in a0
	
	j encrypt
	
	j exitLabel			#jump to exit label
	
	
	
#Michael Goulard
#Christian Znidarsic	
encrypt:
	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0
   	
   	li $v0, 4
	la $a0, input_message
	syscall
	
	li $v0, 8
	la $a0, message
	li $a1, 28
	syscall
	
	jal openFile #open the file to write to
    
    	jal iterateThroughInput #jump and link to the "iterateThroughInput:" function
    	
    	jal closeFile #close the file after it has been written to
 
   #THIS IS THE LINE WHERE THE PROGRAM ENDS
   
       
    	j exitLabel

    
    
#Christian Znidarsic
iterateThroughInput:
	addi $sp, $sp, -20
	sw $ra, 36($sp) #save the return address to the stack
    	sw $a0, 32($sp) #save a0 to the stack
    	
    	addi $t4, $sp, 0 #save the stack pointer in $t4
    	la $t1, ($a0) #load address of the buffer stored in $a0 into $t1
    	
    	loadByte:
	    lbu $t2, ($t1) #load a byte from the buffer (at address in $t1) into $t2
	    
	    
	    #prepare values for modCalc
	    move $a0, $t2
	    move $a1, $14
	    move $a2, $s0
	    
	    jal modCalc
	    
	    move $t2, $v0 #move the result from "modCalc:" into register $t2
	    
	    
	    
	    #print encoded ASCII equivalent to the file called "encoded"
	    sw $t2, print_buffer #store the encoded 4-byte value in print_buffer to be printed
	    
	    lw $a0, file_descriptor #load the file descriptor, saved in file_descriptor buffer, into $a0
	    li $v0, 15	#open file to write to
	    la $a1, print_buffer #load the address of the print_buffer
	    li $a2, 4 #number of bytes to read. We choose to print 4 (a whole word) at a time
	    syscall



	    #print current encoded byte
	    #move $a0, $t2
	    #li $v0,34
	    #syscall

	    #print a newline
	    #li $v0, 4
	    #la $a0, next_line
	    #syscall

	    
	    
	    slti $t3, $t2, 1 #if $t2 < 1, set $t3 = 1, else $t3 = 0. (This is the condition to stop iterating through input)
    	    addi $t4, $t4, 1 #increment the stack pointer (saved in $t4) by 1
    	    addi $t1, $t1, 1 #increment the address of the buffer stored in $t1
    	    
    	    bne $t3, 1, loadByte #if $t3 != 1, jump back up to "loadByte:". This is the main loop condition
    	    #to iterate across all characters in the user input
    	
    
    	    lw $ra 36($sp) #reinstate the return address from the stack
    	    lw $a0 32($sp) #reinstate old contents of $a0 from the stack
    		

    	    addi $t2, $t2, -48
    	    jr $ra #jump back to main

#Michael Goulard	
exitLabel2:				#this label is used when e is not a positive number
	li $v0, 4			#printing the string
   	la $a0, e_is_not_positive
   	syscall				# call print on the string located at address in a0
   	
   	j exitLabel
 #Michael Goulard 	
exitLabel3:				#this label is used when e is greater than phi
	li $v0, 4			#printing the string
   	la $a0, e_is_greater_than_phi
   	syscall				# call print on the string located at address in a0
   	
   	j exitLabel
 #Michael Goulard  	
not_coprime1:				#this label is used when e is not co-prime to the totient
	li $v0, 4			#printing the string
   	la $a0, next_line
   	syscall				# call print on the string located at address in a0

	li $v0, 4			#printing the string
   	la $a0, not_coprime
   	syscall				# call print on the string located at address in a0
   	
   	j exitLabel


#Christian Znidarsic
pow:	#not used
	#receives base in $a0
	#receives exponent in $a1
	#returns result in $v0
	
	li $t0, 1 #initialize counter to 1
	move $t1, $a0 #initialize result register
	
	loop:
		#beq $a1, 1, end #skip loop for case when exponent is 1
		mul $t1, $t1, $a0 #a = a * b
		addi $t0, $t0, 1 #increment the counter
		bne $t0, $a1, loop #end loop when power has been reached

		#end:
		move $v0, $t1 #move the result into $v0 for return
		
		jr $ra


#Christian Znidarsic
mod:	#not used
	#for "a mod(b) = c"
	#receives a in $a0
	#receives b in $a1
	#outputs c in $v0
	
	div $a0, $a1
	mfhi $v0
	
	jr $ra
	
	
#Christian Znidarsic
openFile:
	#save registers
	addi $sp, $sp, -4 # move stack pointer 
	sw $ra, 0($sp) # save $ra
	addi $sp, $sp, -4 # move stack pointer 
	sw $v0, 0($sp) # save $v0
	addi $sp, $sp, -4 # move stack pointer 
	sw $a0, 0($sp) # save $a0
	addi $sp, $sp, -4 # move stack pointer 
	sw $a1, 0($sp) # save $a1
	addi $sp, $sp, -4 # move stack pointer 
	sw $a2, 0($sp) # save $a2

        #open file to write
        li $v0, 13	#syscall to open a file to write
        la $a0, file_encrypted	#name of file to write to
        li $a1, 1	#enables writing ability
        li $a2, 0	#mode $a2 is ignored
        syscall		#opens file
        
        sw $v0, file_descriptor
	
	#reload registers
	lw $a2, 0($sp) # fetch a2
	addi $sp, $sp, 4 # move stack pointer
	lw $a1, 0($sp) # fetch $a1
	addi $sp, $sp, 4 # move stack pointer
	lw $a0, 0($sp) # fetch $a0
	addi $sp, $sp, 4 # move stack pointer
	lw $v0, 0($sp) # fetch $v0
	addi $sp, $sp, 4 # move stack pointer
	lw $ra, 0($sp) # fetch $ra
	addi $sp, $sp, 4 # move stack pointer
	
	jr $ra


#Christian Znidarsic	
closeFile:
	#save registers
	addi $sp, $sp, -4 # move stack pointer 
	sw $a0, 0($sp) # save $a0
	addi $sp, $sp, -4 # move stack pointer 
	sw $s6, 0($sp) # save $s6
	
	#close file
	li $v0, 16
        move $a0, $s6	#closes file descriptor
        syscall		#closes the file
	
	#reload registers
	lw $s6, 0($sp) # fetch $s6
	addi $sp, $sp, 4 # move stack pointer
	lw $a0, 0($sp) # fetch $a0
	addi $sp, $sp, 4 # move stack pointer
	
	jr $ra


#Christian Znidarsic
modCalc:
	#for a = b^c mod(d)
	
	#receives b in $a0
	#receives c in $a1
	#receives d in $a2
	#returns a in $v0
	
	
	#save registers
	addi $sp, $sp, -4 # move stack pointer 
	sw $t0, 0($sp) # save $t0
	addi $sp, $sp, -4 # move stack pointer 
	sw $t1, 0($sp) # save $t1
	
	
	li $t0, 1 #initialize counter to 1
	move $t1, $a0 #initialize result register
	
	modLoop:
		beq $a1, 1, end #skip loop for case when exponent is 1
		mul $t1, $t1, $a0 #a = a * b
		
		
		div $t1, $a2	#divide result by mod number
		mfhi $t1	#store the remainder (result of mod operation) back into $t1
		
		
		addi $t0, $t0, 1 #increment the counter
		bne $t0, $a1, modLoop #end loop when power has been reached

		end:
		move $v0, $t1 #move the result into $v0 for return
		
		
	#reload registers
	lw $t1, 0($sp) # fetch $t1
	addi $sp, $sp, 4 # move stack pointer
	lw $t0, 0($sp) # fetch $t0
	addi $sp, $sp, 4 # move stack pointer
	
	
	jr $ra



