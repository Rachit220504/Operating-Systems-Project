# Operating Systems Project

## Group Members
1. **Rachit** - CS22B1088  
2. **Shubh** - CS22B1090  
3. **Kush** - CS22B2010   

## Prerequisites
- Ensure your Ubuntu version is **24.04** if you're using WSL.

## Question-1 : System Call inplemented: cps,signal,pthread, message queue

### Problem Overview
In this project, we aimed to implement **four new system calls** and integrate them into the **xv6-riscv operating system**.

### System Calls Implemented
1. **cps**  
   Displays all the processes currently running, their process IDs, and current states.

2. **signal**  
   - Implemented a default handler for a user-generated interrupt (**SIG_INT**).  
   - Added **Ctrl+C** as a command to send a user interrupt.

3. **pthread**  
   - Implemented a function to create threads.  
   - Allocated a kernel stack for each thread during execution.

4. **message queue**  
   - Implemented `msgget` to allocate memory for **inter-process communication (IPC)**.

### Methodology
1. **System Call Numbers**  
   - Each system call is assigned a **unique number** in the system call registry.  
   - When a system call is invoked, the system triggers an **interrupt** with the corresponding number.

2. **Definitions**  
   - The logic for each system call is **distributed across files** to handle all cases efficiently.

3. **User-Space Wrapping**  
   - System call logic is **inaccessible** to users directly.  
   - A **wrapper function** was implemented in the user-space to send arguments required for a system call.  
   - The wrapper function:  
     - Passes the required arguments to the system call.  
     - Is added to the **function registry**, ensuring proper mapping from user-space to kernel-space.

```
make clean
```
```
make
```
```
make qemu
```
### For cps:
```
$ cps
```
### For Shm_address
```
k
```
### For Describe
```
c
```
### For exit_terminal
```
G
```
