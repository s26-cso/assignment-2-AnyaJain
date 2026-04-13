#For Q2, output the integers with exactly one space between them and print a newline after that, dont print a space after the last integer

.section .rodata

fmt: .string "%ld" 
fmt2: .string " " 
fmt3: .string "\n" 

.globl main
.section .text

main:

    addi sp, sp, -56
    sd s6, 48(sp)
    sd ra, 40(sp)
    sd s1, 32(sp)
    sd s2, 24(sp)
    sd s3, 16(sp)
    sd s4, 8(sp)
    sd s5, 0(sp)


    addi s1, a0, -1  # s1 is size of input arr (not inluding name)
    mv   s5, a1   # string of args

    # malloc input arr
    slli a0, s1, 3  # n*8 bytes
    call malloc     #goes to a0 cuz return
    mv s2, a0     # s2 = input arr

    # malloc result arr
    slli a0, s1, 3
    call malloc
    mv s3, a0     # s3 = result arr

    #converting to int

    li s4, 0
    parse_loop:
        bge s4, s1, parse_done

        slli t0, s4, 3; #i*8 in t0
        addi t0, t0, 8 #(i+1)*8 basically
        add t0, s5, t0
        ld a0, 0(t0)
        call atoi

        slli t1, s4, 3
        add t1, s2, t1
        sd a0, 0(t1)

        addi s4, s4, 1
        j parse_loop

    parse_done:

        # malloc stack arr
        slli a0, s1, 3
        call malloc
        mv s4, a0     # s4 = stack arr

        li t6, -1  #initialize t6 as stacktop (push pop)
        addi s6, s1, -1 #s6 goes right to left in input array till it finishes 0 (--)
    #t4 goes left to right in results array till it reaches n (++)

    algo_loop:
        blt s6, x0, print  #s6 is index?
        slli t0, s6, 3
        add t0, s2, t0
        ld t1, 0(t0)     #t1 = arr[i]

    while_loop:
        blt  t6, zero, while_done    # base case: if stacktop<0, stack empty, exit while

        # load arr[stack[stacktop]] into t2
        slli t0, t6, 3
        add t0, s4, t0
        ld t2, 0(t0)               # t2 = stack[stacktop] the index
        slli t2, t2, 3
        add t2, s2, t2
        ld t2, 0(t2)               # t2 = arr[stack[stacktop]]

        bgt t2, t1, while_done      # if arr[stack[top]] > arr[i], stop popping
        addi t6, t6, -1              # pop
        j while_loop

    while_done:

        slli t0, s6, 3
        add  t0, s3, t0              # store index in result[i]

        blt  t6, zero, set_neg_one   # stack empty -> result[i] = -1
        slli t2, t6, 3
        add t2, s4, t2
        ld t2, 0(t2)               # t2 = stack[stacktop]
        sd t2, 0(t0)               # result[i] = stack[stacktop]
        j push

    set_neg_one:
        li t2, -1
        sd t2, 0(t0)
        
    push:
        addi t6, t6, 1      # stacktop++
        slli t0, t6, 3
        add t0, s4, t0
        sd s6, 0(t0)      # stack[stacktop] = i

        addi s6, s6, -1    # i--
        j algo_loop

    print:
        li s5, 0
        addi s1,s1,-1

    print_loop:
        bge  s5, s1, finish

        slli t0, s5, 3
        add  t0, s3, t0
        ld a1, 0(t0)        # a1 = arr[i]
        la a0, fmt          # "%ld "
        call printf
        la a0, fmt2
        call printf

        addi s5, s5, 1
        j print_loop
        
    finish:
        slli t0, s5, 3
        add t0, s3, t0
        ld a1, 0(t0)
        la a0, fmt
        call printf
        la a0, fmt3
        call printf
        
        ld s6, 48(sp)
        ld ra, 40(sp)
        ld s1, 32(sp)
        ld s2, 24(sp)
        ld s3, 16(sp)
        ld s4, 8(sp)
        ld s5, 0(sp)
        addi sp, sp, 56
        li a0, 0
        ret