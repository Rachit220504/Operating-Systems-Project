#ifndef COMMANDS_H
#define COMMANDS_H

#include <dirent.h>

#define BUFFER_SIZE 4096

void custom_cat(char **);

void custom_cd(char *, char *);

void custom_cp(char **, char *);

void custom_ls(DIR *);

void custom_mv(char **, char *);

#endif