// halt.c
#include "types.h"
#include "defs.h"

void halt(void) {
    // Halts the system (for QEMU or similar systems)
    for (;;)
        ;  // Infinite loop to halt the system
}

