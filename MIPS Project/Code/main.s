.data
filename: .space 30
file: .asciiz "input.txt"
message: .asciiz "Enter file name: \n"
contents: .space 1048576
.text
.globl main
main:
# Printing "Enter File Name: \m"
la $a0, message		
li $a1, 30
li $v0, 4
syscall
# Reading the filename and storing it into filename variable.
la $a0, filename
li $v0, 8
syscall
# Re-printing the filename to assure that we got it right.
li $v0, 4

syscall
# replacing the newline character with null character.
la $t1, filename
li $t2, '\n'
loop:
lb $t4, 0($t1)
add $t1, $t1, 1
bne $t4, $t2, loop
sb $zero, -1($t1) # -1 because we have incremented $t1 by 1 in the last step.

# Reading From a file.
li $v0, 13
la $a0, filename
la $a1, 0
la $a2, 0
syscall

# Reading the file contents.
move $a0, $v0               # $a0 is the file descriptor.
la $a1, contents            # $a1 is the buffer.
li $a2, 1048576           # $a2 is the size of the buffer.
li $v0, 14
syscall
#Printing The file contents.
move $a0, $a1
li $v0, 4
syscall
# exiting the program
li $v0, 10
syscall
