#include "types.h"   // For uint type
#include "user.h"    // For printf and exit

int main() {
    int size = 4096;  // Allocate 4KB of shared memory
    void *addr = (void *)shm_alloc(size);

    if (addr == (void *)-1) {
        printf(1, "Shared memory allocation failed\n");
    } else {
        printf(1, "Shared memory allocated at address: %p\n", addr);
    }

    return 0; // Terminate the program
}

