#include "user.h"  // Includes the user space definitions

int main() {
    printf(1, "Testing the sys_describe system call:\n\n");

    // Invoke the sys_describe system call
    describe();

    // Exit the program
    return 0;
}

