# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.29

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/shubh_khandelwal/.local/lib/python3.8/site-packages/cmake/data/bin/cmake

# The command to remove a file.
RM = /home/shubh_khandelwal/.local/lib/python3.8/site-packages/cmake/data/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/src"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build"

# Include any dependencies generated for this target.
include CMakeFiles/SHELL.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/SHELL.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/SHELL.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/SHELL.dir/flags.make

CMakeFiles/SHELL.dir/main.c.o: CMakeFiles/SHELL.dir/flags.make
CMakeFiles/SHELL.dir/main.c.o: /home/shubh_khandelwal/Documents/IIITDM\ Kancheepuram/Operating\ Systems/Project/src/main.c
CMakeFiles/SHELL.dir/main.c.o: CMakeFiles/SHELL.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir="/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building C object CMakeFiles/SHELL.dir/main.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/SHELL.dir/main.c.o -MF CMakeFiles/SHELL.dir/main.c.o.d -o CMakeFiles/SHELL.dir/main.c.o -c "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/src/main.c"

CMakeFiles/SHELL.dir/main.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing C source to CMakeFiles/SHELL.dir/main.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/src/main.c" > CMakeFiles/SHELL.dir/main.c.i

CMakeFiles/SHELL.dir/main.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling C source to assembly CMakeFiles/SHELL.dir/main.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/src/main.c" -o CMakeFiles/SHELL.dir/main.c.s

# Object files for target SHELL
SHELL_OBJECTS = \
"CMakeFiles/SHELL.dir/main.c.o"

# External object files for target SHELL
SHELL_EXTERNAL_OBJECTS =

SHELL: CMakeFiles/SHELL.dir/main.c.o
SHELL: CMakeFiles/SHELL.dir/build.make
SHELL: include/libCOMMANDS.a
SHELL: CMakeFiles/SHELL.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir="/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking C executable SHELL"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/SHELL.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/SHELL.dir/build: SHELL
.PHONY : CMakeFiles/SHELL.dir/build

CMakeFiles/SHELL.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/SHELL.dir/cmake_clean.cmake
.PHONY : CMakeFiles/SHELL.dir/clean

CMakeFiles/SHELL.dir/depend:
	cd "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/src" "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/src" "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build" "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build" "/home/shubh_khandelwal/Documents/IIITDM Kancheepuram/Operating Systems/Project/build/CMakeFiles/SHELL.dir/DependInfo.cmake" "--color=$(COLOR)"
.PHONY : CMakeFiles/SHELL.dir/depend
