#Christian Znidarsic	
.data
	#Buffer
	plaintext_buffer: .space 100
	
	file_descriptor: .space 16
	print_buffer: .space 8
	
	next_line: 		.asciiz "\n"
	message:		.space 28
	file_encrypted:        .asciiz "encrypted"
	file_decrypted:        .asciiz "plaintext"


.text

#Christian Znidarsic	
main:
	la $a1, plaintext_buffer
	li $14, 379 # private key exponent d
	li $15, 1517 # modulus
	

	jal readfile
	
	
	jal openFile	#open a new file to write decrypted plaintext
	
	jal iterateThroughInput	#iterate through encrypted text and decrypt one char at a time. Write decrypted chars to output file.

	jal closeFile	#close the file containing decrypted plaintext


	j exitLabel	#exit program


#Minzhe Chen
readfile: 
	# Read a file into a buffer
	# $a0 is filename 
	# $a1 is the buffer
	
	addi $sp, $sp, -20  #save registers
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	move $s1, $a1 # buffer adress

	li $v0, 13 # open file
	la $a0, file_encrypted # load file name into $a0
	li $a1, 0 # read file
	li $a2, 0 
	syscall
	move $s0, $v0 #save file

	li $v0, 14 # read file
	move $a0, $s0
	move $a1, $s1 #load the file in buffer
	li $a2, 100 # we read 100 characters by default
	syscall
	
	
	lw $s3 16($sp) # restore s registers
	lw $s2 12($sp)
	lw $s1 8($sp)
	lw $s0 4($sp)
	lw $ra 0($sp)
	addi $sp, $sp, 20
	
	jr $ra



#Christian Znidarsic	
iterateThroughInput:
    	addi $sp, $sp, -20
    	sw $ra, 36($sp) #save the return address to the stack
    	sw $a0, 32($sp) #save a0 to the stack
    	
    	addi $t4, $sp, 0 #save the stack pointer in $t4
    	la $t1, plaintext_buffer #load address of the buffer stored in $a0 into $t1
    	
    	loadWord:
	    lw $t2, ($t1) #load a word from the buffer (at address in $t1) into $t2
	    
	    
	    # set registers for modCalc
	    move $a0, $t2
	    move $a1, $14
	    move $a2, $15
	    
	    jal modCalc
	    
	    move $t2, $v0 #move the result from "modCalc:" into register $t2
	    
	    
	    
	    #print decoded ASCII character
	    sw $t2, print_buffer #store the encoded 4-byte value in print_buffer to be printed
	    
	    lw $a0, file_descriptor #load the file descriptor, saved in file_descriptor buffer, into $a0
	    li $v0, 15	#open file to write to
	    la $a1, print_buffer #load the address of the print_buffer
	    li $a2, 1 #number of bytes to read. We choose to print 4 (a whole word) at a time
	    syscall



	    #print current decoded char
	    li $v0, 11
	    move $a0, $t2
	    syscall

	    #print current decoded byte
	    #li $v0, 34
	    #move $a0, $t2
	    #syscall

	    #print a newline
	    #li $v0, 4
	    #la $a0, next_line
	    #syscall


	    
	    slti $t3, $t2, 1 #if $t2 < 1, set $t3 = 1, else $t3 = 0. (This is the condition to stop iterating through input)
    	    addi $t4, $t4, 4 #increment the stack pointer (saved in $t4) by 1
    	    addi $t1, $t1, 4 #increment the address of the buffer stored in $t1
    	    
    	    bne $t3, 1, loadWord #if $t3 != 1, jump back up to "loadByte:". This is the main loop condition
    	    #to iterate across all characters in the user input
    	
    
    	    lw $ra 36($sp) #reinstate the return address from the stack
    	    lw $a0 32($sp) #reinstate old contents of $a0 from the stack
    		

    	    addi $t2, $t2, -48
    	    jr $ra #jump back to main
    	    
    	      	    
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
	
	loop:
		beq $a1, 1, end #skip loop for case when exponent is 1
		mul $t1, $t1, $a0 #a = a * b
		
		
		div $t1, $a2	#divide result by mod number
		mfhi $t1	#store the remainder (result of mod operation) back into $t1
		
		
		addi $t0, $t0, 1 #increment the counter
		bne $t0, $a1, loop #end loop when power has been reached

		end:
		move $v0, $t1 #move the result into $v0 for return
		
		
	#reload registers
	lw $t1, 0($sp) # fetch $t1
	addi $sp, $sp, 4 # move stack pointer
	lw $t0, 0($sp) # fetch $t0
	addi $sp, $sp, 4 # move stack pointer
	
	
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
        la $a0, file_decrypted	#name of file to write to
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
	
	


exitLabel:
   	li $v0,10			#ends program
   	syscall
