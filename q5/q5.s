.section .rodata

filename: .string "input.txt"
mode: .string "r"
yes_str: .string "Yes\n"
no_str: .string "No\n"

.globl main
.section .text
main:
    addi sp, sp, -48
    sd ra, 40(sp)
    sd s1, 32(sp)
    sd s2, 24(sp)
    sd s3, 16(sp)
    sd s4, 8(sp)
    sd s5, 0(sp)

    la a0, filename
    la a1, mode
    call fopen
    mv s1, a0   #s1 has f(addr)

    li a1, 0
    li a2, 2     #SEEK_END = 2
    call fseek

    mv a0, s1
    call ftell
    mv s2, a0   #s2 has length of input.txt, --
    addi s2, s2, -1
    li s3,0     #starting, ++

    loop:
        bge s3, s2, print_yes

        mv a0, s1
        mv a1, s2
        li a2,0
        call fseek
        mv a0, s1
        call fgetc
        mv s4, a0

        mv a0, s1
        mv a1, s3
        li a2,0
        call fseek
        mv a0, s1
        call fgetc
        mv s5, a0

        addi s3, s3, 1
        addi s2,s2, -1 
        bne s4, s5, print_no
        j loop

    print_yes:
        la a0, yes_str
        call printf
        j finish

    print_no:
        la a0, no_str
        call printf

    finish:
        ld ra, 40(sp)
        ld s1, 32(sp)
        ld s2, 24(sp)
        ld s3, 16(sp)
        ld s4, 8(sp)
        ld s5, 0(sp)
        addi sp, sp, 48
        li a0, 0
        ret