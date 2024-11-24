# Operating Systems Project

## Group Members
1. **Rachit Chandekar** - CS22B1088  
2. **Shubh Khandelwal** - CS22B1090  
3. **Kush Jain** - CS22B2010   

## Prerequisites
- Bash
- CMake
- Ubuntu Version 22.04 / 24.04
- xv6-public / xv6-riscv

## Project-1 : System Call inplemented: cps,shm_address, describe

### Problem Overview
In this project, we aimed to implement **three new system calls** and integrate them into the **xv6-riscv operating system**.

### System Calls Implemented
1. **cps**  
   Displays all the processes currently running, their process IDs, and current states.

2. **Shm_address**  
   - Implementing a new system call which will provide the shared memory address.  
   
3. **Describe**  
   - Providing the description for each system call to help understand their functionality.


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
$ ps
```
### For Shm_address
```
$shmtest
```
### For Describe
```
$desc
```

## Output Images

1. **Make**
   
![make](https://github.com/user-attachments/assets/4a69a94b-5820-4edd-a6e1-0283806b8155)

2. **Make Qemu**
   
![make_que](https://github.com/user-attachments/assets/c22d605a-ec8e-49cc-8597-8b1d4be3a7b3)

3. **Cps**
   
![cps](https://github.com/user-attachments/assets/a8a792d0-1c8a-4692-ac23-f841d13b0ff5)
 
4. **Shm_address**
   
![shm add](https://github.com/user-attachments/assets/a3c3d9d7-8256-4469-a53d-0d2b59323f7e)


5. **Describe**
    
![describe](https://github.com/user-attachments/assets/0d63d3f1-dad6-4a78-8af1-d16a4474f0d2)




## Project-2: Custom UNIX shell application
**Topics Implemented:**  'cat' , 'cd' , 'cp' , 'exit' , 'ls' , 'mv' 

In this project, we aim to develop a series of simplified UNIX-like utilities.
These utilities will be lightweight versions of common commands, such as cat,
ls, cd, and others. To avoid confusion with the standard UNIX commands, each
utility will have a unique name; for instance, instead of using cat, you will
implement a command called custom_cat. Signals like SIGINT, SIGSTOP and SIGTSTP
have been ignored to prevent the interruption of the shell application.

### Implementation
1. **custom_cat**
   - Usage: cat <Input_File_1> <Input_File_2> ...
   - Used for concatenating and displaying file contents
2. **custom_cd**
   - Usage: cd <Destination_Path>
   - Used for changing directories
3. **custom_cp**
   - Usage: cp <Input_File_1> <Input_File_2> ... <Destination_Path>
   - Used for copying files
4. **custom_exit**
   - Usage: exit
   - Used for exiting the shell
5. **custom_ls**
   - Usage: ls
   - Used for listing items
6. **custom_mv**
   - Usage: mv <Input_File_1> <Input_File_2> ... <Destination_Path>
   - Used for moving files


### Output
1. **Custom_cat**
   
![cat](https://github.com/user-attachments/assets/43c0772f-f89c-4959-82a9-cfdcc57a280f)

2. **Custom_cd**
![cd](https://github.com/user-attachments/assets/3775e9ae-d947-4f38-b92d-8abe57770416)


3. **Custom_cp**

![cp](https://github.com/user-attachments/assets/67051673-a4a4-44ca-8994-f757214a899b)

4. **Custom_exit**

![exit](https://github.com/user-attachments/assets/4d95cd69-34ba-4b65-a522-f13357c7c15e)

5. **Custom_ls**

![ls](https://github.com/user-attachments/assets/cacdee94-f091-4d99-89ce-2b7d68f68a84)

6. **Custom_mv**

![mv](https://github.com/user-attachments/assets/4cdf5f2b-ecce-4692-8652-5f9f6ce8a991)


   



   
