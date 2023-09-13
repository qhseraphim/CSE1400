.text
 
format: .asciz "%ld"
 
.global main
 
main:
	pushq 	%rbp                    #initialize the stack layout
	movq 	%rsp, %rbp              #moving the stack pointer at the start of the stack
	 
	call 	input                   #getting the base
	movq    %rax, base              #save the base into memory
 
	call 	input                   #getting the exponent
	movq    %rax, exp               #save the exponent into memory
	 
	movq    base, %rdi              #first parameter=base saved in rdi as the convention says
	movq    exp, %rsi               #second parameter=exp saved in rsi as the convention says
	call    pow                     #call the subroutine pow

	movq	%rax, result            #save the result into memory

   	movq 	$format, %rdi           #specify the format of the ouput
   	movq   	$0, %rax                #reinitialize the rax register
	movq 	(result), %rsi          #load the result
	call 	printf                  #print it
	
	movq    %rbp, %rsp
	popq 	%rbp                    #restore base pointer location
	movq 	$0, %rdi                #load the exit code 0
	call    exit
 
input:
	pushq    %rbp                   #initialize the stack layout for the subroutine
	movq 	%rsp, %rbp           
	 
	movq 	$0, %rax
	movq 	$format, %rdi           #load the input format
	subq 	$16,  %rsp              #subtract the memory required to store the input
	leaq 	-16(%rsp), %rsi         #load it into effective memory    
	call    scanf                   #call the reading subroutine
	
	movq 	%rsi, %rax              #save the input value into rax for later usage
	 
	movq 	%rbp, %rsp              #clear the stack of the subroutine
	popq 	%rbp
	ret
 
pow:
	pushq    %rbp                   #initialize the stack layout for the subroutine
	movq 	%rsp, %rbp   
	
	movq	$1, %rax				#initialize the result to 1
	cmpq	$0, exp                 #comparing the exponent, because if it is == 0 the result is always 1
	jne     pow_looping             #exponent!=0, we do the powering otherwise just return 1

	movq 	%rbp, %rsp
	popq    %rbp                   
    ret

pow_looping:
	movq    $1, %rax                #initialize the rax(result register of multiplication) to 1
	loop:
	   mulq  	%rdi                #multiply the rax with the base
	   decq  	%rsi                #decrease the number of times we still need to multiply
	   cmpq  	$0, %rsi            #check if we still to multiply
	   jne 		loop                #if exp != 0 we loop again
	movq 	%rbp, %rsp              #clear the stack of the subroutine
	popq 	%rbp
    ret
	
.data

base: .quad 0
exp:  .quad 0
result:  .quad 0
