#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
// Add this declaration at the top of init.c
extern void halt(void);

char *argv[] = { "sh", 0 };

int main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();  // Will exit if fork fails
    }
    if(pid == 0){
      exec("sh", argv);  // Execute the shell
      printf(1, "init: exec sh failed\n");
      exit();  // Will exit child process if exec fails
    }

    // Wait for the shell process to finish
    wpid = wait();
    if(wpid >= 0) {
      printf(1, "init: shell exited, shutting down...\n");

      // After shell exits, shut down the system
      
    }
  }
}

