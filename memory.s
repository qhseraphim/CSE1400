.text
format_c: .asciz "%c"
format_ld: .asciz "%ld"

.include "final.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown                                         *
#   - 4 byte index                                           *
#   - 1 byte amount                                          *
#   - 1 byte character                                       *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	pushq	%rbp 			 # push the base pointer (and align the stack)
	movq	%rsp, %rbp		 # copy stack pointer value to base pointer
	loop:
		movq    (%rdi), %rdx     # save the current line in rdx so we can process the character
		movq    (%rdi), %rcx     # save the current line in rcx so we can process the number of times 
		movq    (%rdi), %rbx     # save the current line in rbx so we can process next block adress
		
		andq 	$0xFF, %rdx  	# getting the 8-th byte (the character to be printed)

		shrq    $8, %rcx         # we remove the 8-th byte so we can read the 7-th one
		andq 	$0xFF, %rcx      # getting the 7-th byte (the number of times)

		shrq    $16, %rbx         		# we remove the 8-th byte so we can read the 3-6 ones
		movq    $0xFFFFFFFF, %rax       
		andq    %rax, %rbx              # we need the first the bytes from 0..31 (32 in total), so we need to AND with 0xFFFFFFFF = (2 ^ 32 - 1) = 111.11 32 times to get them

		movq   %rdx, characater   #save the character into memory
		movq   %rcx, times        #save in memory the number of times
		cmpq   $0, times          #check if we need to print at least one characater
		jne   loop_print          #if we have, we first go to print them
		jmp   next_block          #if not we get the next block
		loop_print:                     
			movq  $format_c, %rdi          #specify the format of the ouput
			movq  $0, %rax                 #reinitialize the rax register
			movq  characater, %rsi
			call  printf                   #print it
			decq  times                    #decrease the number of times I need to print
			cmpq  $0, times
			jne   loop_print
		next_block:
			cmpq   $0, %rbx                 # we got again to the first line, so we should stop
			je     end

			shlq    $3, %rbx                # multiply the new position where we need to get by 8 (size of a quad) so we jump %rbx lines
			addq 	$MESSAGE, %rbx   		# Add base address of MESSAGE to get the new address
			movq    %rbx, %rdi              # Copy the pointer to the new element to %rdi for next iteration
		jmp    loop
	end: 
		movq	%rbp, %rsp		# clear local variables from stack
		popq	%rbp			# restore base pointer location 
		ret
main:
	pushq	%rbp 			# push the base pointer (and align the stack)
	movq	%rsp, %rbp		# copy stack pointer value to base pointer

	movq    $MESSAGE, %rdi
	call	decode			# call decode

	popq	%rbp			# restore base pointer location 
	movq	$0, %rdi		# load program exit code
	call	exit			# exit the program
.data
times: .quad 0
characater: .quad 0
