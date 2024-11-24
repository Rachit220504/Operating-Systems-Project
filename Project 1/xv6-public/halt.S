; halt.S (Assembly version of halt)
    global halt
halt:
    hlt    ; HALT instruction, halts the CPU in QEMU or similar environments
    ret

