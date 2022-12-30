.data
filename: .space 30
fout: .space 30 
message1: .asciiz "\nPlease input the name of the plain text file: \n"
message2: .asciiz "\nDo you want to encrypt or decrypt? (e/d): \n"
message3: .asciiz "\nPlease input the name of the cipher text file: \n"
message4: .asciiz "\nThe Shift Value is= "
contents: .space 1048576
String: .space 1024
.text
.globl main
main:
    j START

    #print the contents of contents
#     la $t0, contents
#     li $t1, 0
#     li $t2, '\n'
#     li $v0, 11
# loopw2:
#     lb $t3, 0($t0)
#     add $t0, $t0, 1
#     beq $t3, $zero, exitw
#     move $a0, $t3
#     syscall
#     b loopw2
# exitw:
#     move $a0, $t2
#     syscall
#     jr $31

READ_FILE:
# Reading the filename and storing it into filename variable.
    la $a0, filename
    li $v0, 8
    syscall
# replacing the newline character with null character.
    la $t1, filename
    li $t2, '\n'
    li $v0, 13
    la $a0, filename
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
    li $v0, 16
    syscall
    jr $31



WRITE_FILE:
    la $a0, fout
    li $v0, 8
    syscall
# replacing the newline character with null character.
    la $t1, fout
    li $t2, '\n'
    li $v0, 13
    la $a0, fout
loopw:
    lb $t4, 0($t1)
    add $t1, $t1, 1
    bne $t4, $t2, loopw
    sb $zero, -1($t1) # -1 because we have incremented $t1 by 1 in the last step.



    li $v0, 13
    li $a1, 1
    li $a2, 0
    syscall
    move $s6, $v0               # $s6 is the file descriptor.
#Writing to a file.
    move $a0, $s6
    la $a1, contents
    move $a2, $t8
    li $v0, 15
    syscall
    li $v0, 16
    syscall
    jr $31



    


PROC_A:
    la $t0, contents 
    move  $t1, $t0
    li $t3, 0 # MAX
    li $t4, 0 # counter
    li $t8, 0 # TotalChars and Spaces and Newlines
loopA:
    # read byte by byte from contents
    lb $t5, 0($t0)
    add $t0, $t0, 1
    
    # check if the byte is space
    beq $t5, 32, space 
    beq $t5, '\n', space
    beq $t5, $zero, exit
    # check if the byte is between a-z even if it is capital
    or $t5, $t5, 32
    blt $t5, 97, exit
    bgt $t5, 122, exit
    b alpha
space:
    add $t8, $t8, 1
    bgt $t4, $t3, max
    move $t4, $zero
    sb $t5, 0($t1)
    add $t1, $t1, 1
    b exit
max:
    move $t3, $t4
    move $t4, $zero
    sb $t5, 0($t1)
    add $t1, $t1, 1
    b exit
alpha:
    sb $t5, 0($t1)
    add $t1, $t1, 1
    add $t4, $t4, 1
    add $t8, $t8, 1
exit:
    bne $t5, $zero, loopA
    sb $zero, 0($t1) 
    sleu $t7, $t4, $t3  #if $t4 <= $t3 then $t7 = 1
    beq $t7, $zero, exitA
    move $s0, $t3
    move $s1, $t1
    jr $31
exitA:
    move $s0, $t4
    jr $31



ENCODE:
    la $t0, contents
    move $t3, $s0
loopb:
    lb $t5, 0($t0)
    add $t0, $t0, 1
    beq $t5, 32, loopb
    beq $t5, $zero, exitb
    add $t5, $t5, $t3
    bgt $t5, 122, morethanz
lessthanz:
    sb $t5, -1($t0)
    b loopb
morethanz:
    sub $t5, $t5, 26
    sb $t5, -1($t0)
    b loopb
exitb:
    jr $31




DECODE:
    la $t0, contents
    move $t3, $s0
loopC:
    lb $t5, 0($t0)
    add $t0, $t0, 1
    beq $t5, 32, loopC
    beq $t5, $zero, exitc
    sub $t5, $t5, $t3
    blt $t5, 97, lessthana
morethana:
    sb $t5, -1($t0)
    b loopC
lessthana:
    add $t5, $t5, 26
    sb $t5, -1($t0)
    b loopC
exitc:
    jr $31



START:
    la $a0, message2  
    li $a1, 30
    li $v0, 4
    syscall
    li $v0, 12
    syscall
    beq $v0, 101, ENCODE_START
    beq $v0, 100, DECODE_START
    j START


ENCODE_START:
    la $a0, message1 
    li $v0, 4
    syscall
    jal READ_FILE
    jal PROC_A # s0 has the max_len and s1 has the text length
    #print the max_len
    la $a0, message4
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    jal ENCODE
    la $a0, message3 
    li $v0, 4
    syscall
    jal WRITE_FILE
    li $v0, 10
    syscall


DECODE_START:
    la $a0, message3 
    li $v0, 4
    syscall
    jal READ_FILE
    jal PROC_A
    #print the max_len
    la $a0, message4
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall
    jal DECODE
    la $a0, message1
    li $v0, 4
    syscall
    jal WRITE_FILE
    syscall
    li $v0, 10
    syscall
