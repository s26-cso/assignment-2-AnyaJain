#fix no duplicates will be inserted

.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node: #Returns a pointer to a struct with the given value and left and right pointers set to NULL.

    addi sp, sp, -32
    sd ra, 24(sp)
    sd s1, 16(sp)
    sd s2, 8(sp)
    sd s3, 0(sp)

    mv s1, a0     #s1 has the int
    li a0, 24           #size 24
    call malloc         
    mv s2, a0           #this is pointer to struct

    sd s1, 0(s2)        #storing that int, use sw instead becayse int is 4 bits?
    sd x0, 8(s2)         #nulls
    sd x0, 16(s2)

    mv a0, s2

    ld ra, 24(sp)
    ld s1, 16(sp)
    ld s2, 8(sp)
    ld s3, 0(sp)
    addi sp, sp, 32

    ret

insert: #insert a node with value val into the tree with the given root. Return the root.

    addi sp, sp, -32
    sd ra, 24(sp)
    sd s1, 16(sp)
    sd s2, 8(sp)
    sd s3, 0(sp)

    mv s1, a0 #pointer to root
    mv s2, a1 #integer to be added
    
    #base case if root is null add there and then finish
    bne s1, zero, not_null
    mv a0, s2
    call make_node      #a0 has ret pointer alr
    j insert_done

    not_null:
        ld t0, 0(s1)
        bge s2, t0, right

    left:
        #if our int < node int then go left
        ld a0, 8(s1)
        mv a1, s2
        call insert
        sd a0, 8(s1)
        j finish

    right:
        #else go right
        ld a0, 16(s1)
        mv a1, s2
        call insert
        sd a0, 16(s1)

    finish:
        mv a0, s1

    insert_done:
        ld ra, 24(sp)
        ld s1, 16(sp)
        ld s2, 8(sp)
        ld s3, 0(sp)
        addi sp, sp, 32

        ret

get: #Return a pointer to a node with value val in the tree. Return NULL if no such node exists.

    addi sp, sp, -32
    sd ra, 24(sp)
    sd s1, 16(sp)
    sd s2, 8(sp)
    sd s3, 0(sp)

    mv s1, a0 #pointer to root
    mv s2, a1 #integer to be found

    base_case:
        bne s1, x0, check_success
        li a0, 0
        j done

    check_success:
        ld t0, 0(s1)        #use lw?
        beq s2, t0, done  # if equal, return root (a0 = s1 at finish)
        bge s2, t0, look_right

    look_left:
        #if our int < node int then go left
        ld a0, 8(s1)
        mv a1, s2
        call get #puts in a0
        j done

    look_right:
        #else go look_right
        ld a0, 16(s1)
        mv a1, s2
        call get #puts in a0

    done:

        ld ra, 24(sp)
        ld s1, 16(sp)
        ld s2, 8(sp)
        ld s3, 0(sp)
        addi sp, sp, 32

        ret

getAtMost: # Return the greatest value present in the tree which is <= val. Return -1 if no such node exists.
    
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s1, 16(sp)
    sd s2, 8(sp)
    sd s3, 0(sp)

    mv s1, a0 #val
    mv s2, a1 #pointer to root

    #base case
    bne s2, x0, found
    li a0, -1
    j over

    found:
        ld t0, 0(s2)        #use lw?
        beq s1, t0, over  # if equal, return root (a0 = s1 at finish)
        bge s1, t0, go_right

    go_left:
        #if our int < node int then go left
        ld a1, 8(s2)
        mv a0, s1
        call getAtMost
        j over

    go_right:
        #else go right
        ld a1, 16(s2)
        mv a0, s1
        call getAtMost
        li t0, -1
        bne a0, t0, over
        ld a0, 0(s2)

    over:

        ld ra, 24(sp)
        ld s1, 16(sp)
        ld s2, 8(sp)
        ld s3, 0(sp)
        addi sp, sp, 32

        ret
