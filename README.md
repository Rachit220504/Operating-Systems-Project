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

2. **Shm_address**  
   - Implemented a default handler for a user-generated interrupt (**SIG_INT**).  
   - Added **Ctrl+C** as a command to send a user interrupt.

3. **Describe**  
   - Implemented a function to create threads.  
   - Allocated a kernel stack for each thread during execution.

4. **exit_terminal**  
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
## Output Images

1. **Make**
   
![ALT TEXT](images/make1.png)
![ALT TEXT](images/make2.png)

2. **Make Qemu**
   
![ALT TEXT](images/makeqemu.png)

3. **Cps**
   
 ![ALT TEXT](images/signal.png)
 
4. **Shm_address**
   
![shm add](https://github.com/user-attachments/assets/a3c3d9d7-8256-4469-a53d-0d2b59323f7e)


5. **Describe**
    
![ALT TEXT](images/thread_create.png)

6. **Exit_terminal**
    
![ALT TEXT](images/thread_create.png)

## Question_2: Custom UNIX shell application
**Topics Implemented:**  'cat' , 'cd' , 'cp' , 'exit' , 'ls' , 'mv' , 'rm'

In this project, we aim to develop a series of simplified UNIX-like utilities.
These utilities will be lightweight versions of common commands, such as cat,
ls, cd, and others. To avoid confusion with the standard UNIX commands, each
utility will have a unique name; for instance, instead of using cat, you will
implement a command called custom_cat .

### Modified Commands
1. **custom_cat**
   - will do later.
2. **custom_cd**
   - will do later.
3. **custom_cp**
   - will do later.
4. **custom_exit**
   - will do later.
5. **custom_ls**
   - will do later.
6. **custom_mv**
   - will do later
7. **custom_rm**
   - will do later.

### Implementation

### Output
1. **Custom_cat**
   
![ALT TEXT](images/thread_create.png)

2. **Custom_cd**

![ALT TEXT](images/thread_create.png)

3. **Custom_cp**

![ALT TEXT](images/thread_create.png)

4. **Custom_exit**

![ALT TEXT](images/thread_create.png)

5. **Custom_ls**

![ALT TEXT](images/thread_create.png)

6. **Custom_mv**

![ALT TEXT](images/thread_create.png)

7. **Custom_rm**

![ALT TEXT](images/thread_create.png)
   



   
