.data
filename: .space 30
message: .asciiz "Enter file name: \n"

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
# exiting the program
li $v0, 10
syscall
