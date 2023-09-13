.text
 
format: .asciz "%ld"
 
.global main
 
main:
	pushq 	%rbp                    #initialize the stack layout
	movq 	%rsp, %rbp              #moving the stack pointer at the start of the stack
	 
	call 	input                   #getting the base
	movq    %rax, n                 #save the n into memory
    movq    n, %rdi                 #save the first parameter of function factorial
     
	call 	factorial               #getting thefactorial result
	movq    %rax, result            #save the result into memory

   	movq 	$format, %rdi           #specify the format of the ouput
   	movq   	$0, %rax                #reinitialize the rax register
	movq 	(result), %rsi          #load the result
	call 	printf                  #print it
	
	movq    %rbp, %rsp
	popq 	%rbp                    #restore base pointer location
	movq 	$0, %rdi                #load the exit code 0
	call    exit
 
input:
	pushq   %rbp                    #initialize the stack layout for the subroutine
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

factorial:
    pushq   %rbp                    #initialize the stack layout
    movq    %rsp, %rbp           
    
    cmpq    $0, %rdi                #check the finish case, if exp = 0 we return 1
    je      finish_factorial        #make the (%rax) equal 1 and stop calling the recursive function again
    
    pushq   %rdi                    #save the the value of n so we can multiply the result with it after finishing the recursive call
    decq    %rdi                    #decrease n so we can call factorial function again [factorial(n - 1)]
    
    subq    $8, %rsp                #using call we push only 8 bytes to the stack, but we need it to be 16 alligned
    call    factorial               #calling the recursive subroutine
    addq    $8, %rsp                #removing the 8 bytes used to allign the stack

    popq    %rdi                    #after calculating (n-1)! and saving it in rax, we get our value n from the stack back
    mulq    %rdi                    #multiply the result(%rax) with our value from the stack [(n)! = factorial[n - 1] * n]

    movq    %rbp, %rsp              #clear the stack for the recursive call of the subroutine
    popq    %rbp
    ret

finish_factorial:
    movq    $1, %rax                #initialize the return register with 1
    movq    %rbp, %rsp              #clear the stack
    popq    %rbp
    ret
.data
n:  .quad 0
result:  .quad 0
