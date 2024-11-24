#include "commands.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void custom_cat(char **args)
{

    int index = 0;
    while (args[index][0] != '\0')
    {

        FILE *file = fopen(args[index], "r");
        if (file == NULL)
        {
            printf("Error in opening file(s).\n");
            return;
        }

        char buffer[BUFFER_SIZE] = {0};
        while (fgets(buffer, BUFFER_SIZE, file))
        {
            printf("%s", buffer);
        }
        printf("\n");
        fclose(file);

        index++;
    }

    if (index == 0)
    {
        printf("Usage: cat ${INPUT_FILE_1} ${INPUT_FILE_2} ...\n");
    }

}

void custom_cd(char *arg, char *directory_path)
{

    if (arg[0] == '\0')
    {

        for (int i = 0; i < BUFFER_SIZE; i++)
        {
            directory_path[i] = '\0';
        }

        char *username = getenv("USER");
        snprintf(directory_path, BUFFER_SIZE, "/home/%s", username);

    } else if (arg[0] == '/')
    {

        DIR* temp = opendir(arg);
        if(temp == NULL)
        {
            printf("%s: Not a directory.\n", arg);
        } else
        {
            for (int i = 0; i < BUFFER_SIZE; i++)
            {
                directory_path[i] = '\0';
            }
            strcpy(directory_path, arg);
        }
        closedir(temp);

    } else
    {
    
        char old_path[BUFFER_SIZE];
        strcpy(old_path, directory_path);
        if (directory_path[strlen(directory_path) - 1] != '/')
        {
            directory_path[strlen(directory_path)] = '/';
        }
        int index = 0;
        while (arg[index] != '\0')
        {
            if (arg[index] == '.')
            {
                if ((arg[index + 1] == '/') || (arg[index + 2] == '\0'))
                {
                    index += 2;
                }
                if (arg[index + 1] == '.')
                {
                    if ((arg[index + 2] == '/') || (arg[index + 2] == '\0'))
                    {
                        if (strlen(directory_path) != 1)
                        {
                            directory_path[strlen(directory_path) - 1] = '\0';
                        }
                        for (int i = strlen(directory_path) - 1; directory_path[i] != '/'; i--)
                        {
                            directory_path[i] = '\0';
                        }
                        index += 3;
                    } else
                    {
                        printf("%s: Not a directory.\n", arg);
                        for (int i = 0; i < BUFFER_SIZE; i++)
                        {
                            directory_path[i] = '\0';
                        }
                        strcpy(directory_path, old_path);
                        return;
                    }
                }
            } else
            {
                directory_path[strlen(directory_path)] = arg[index++];
            }
        }
        if ((strlen(directory_path) != 1) && (directory_path[strlen(directory_path) - 1] == '/'))
        {
            directory_path[strlen(directory_path) - 1] = '\0';
        }

        DIR* temp = opendir(directory_path);
        if(temp == NULL)
        {
            printf("%s: Not a directory.\n", arg);
            for (int i = 0; i < BUFFER_SIZE; i++)
            {
                directory_path[i] = '\0';
            }
            strcpy(directory_path, old_path);
        }
        closedir(temp);
    
    }

}

void custom_cp(char **args, char *directory_path)
{

    int index = 0;
    while (args[index][0] != '\0')
    {
        index++;
    }
    if ((index == 0) || (index == 1))
    {
        printf("Usage: mv ${INPUT_FILE_1} ${INPUT_FILE_2} ... ${DESTINATION_DIRECTORY}\n");
        return;
    }
    index--;

    char temp_path[BUFFER_SIZE];
    if (args[index][0] == '/')
    {

        strcpy(temp_path, args[index]);

    } else
    {
    
        strcpy(temp_path, directory_path);
        if (temp_path[strlen(temp_path) - 1] != '/')
        {
            temp_path[strlen(temp_path)] = '/';
        }
        int k = 0;
        while (args[index][k] != '\0')
        {
            if (args[index][k] == '.')
            {
                if ((args[index][k + 1] == '/') || (args[index][k + 1] == '\0'))
                {
                    k += 2;
                }
                if (args[index][k + 1] == '.')
                {
                    if ((args[index][k + 2] == '/') || (args[index][k + 2] == '\0'))
                    {
                        if (strlen(temp_path) != 1)
                        {
                            temp_path[strlen(temp_path) - 1] = '\0';
                        }
                        for (int i = strlen(temp_path) - 1; temp_path[i] != '/'; i--)
                        {
                            temp_path[i] = '\0';
                        }
                        k += 3;
                    } else
                    {
                        printf("%s: Not a directory.\n", args[index]);
                        return;
                    }
                }
            } else
            {
                temp_path[strlen(temp_path)] = args[index][k++];
            }
        }
        if ((strlen(temp_path) != 1) && (temp_path[strlen(temp_path) - 1] == '/'))
        {
            temp_path[strlen(temp_path) - 1] = '\0';
        }
    
    }

    DIR* temp = opendir(temp_path);
    if(temp == NULL)
    {
        printf("%s: Not a directory.\n", args[index]);
        closedir(temp);
        return;
    }
    closedir(temp);
    index--;

    while (index >= 0)
    {

        FILE *file = fopen(args[index], "rb");
        char new_path[BUFFER_SIZE];
        for (int i = 0; i < BUFFER_SIZE; i++)
        {
            new_path[i] = '\0';
        }
        strcpy(new_path, temp_path);
        new_path[strlen(new_path)] = '/';
        strcat(new_path, args[index]);
        FILE *new = fopen(new_path, "wb");
        if (file == NULL || new == NULL)
        {
            printf("Error in opening file(s).\n");
            return;
        }

        char buffer[BUFFER_SIZE] = {0};
        int bytes_read;
        while ((bytes_read = fread(buffer, sizeof(char), BUFFER_SIZE, file)) > 0)
        {
            fwrite(buffer, sizeof(char), bytes_read, new);
        }
        fclose(new);
        fclose(file);

        index--;

    }

}

void custom_ls(DIR *directory)
{

    struct dirent *entry;
    while ((entry = readdir(directory)))
    {
        if (entry->d_type == 4)
        {
            printf("Folder: %s\n", entry->d_name);
        } else
        {
            printf("File: %s\n", entry->d_name);
        }
    }

}

void custom_mv(char **args, char *directory_path)
{

    int index = 0;
    while (args[index][0] != '\0')
    {
        index++;
    }
    if (index == 0 || (index == 1))
    {
        printf("Usage: mv ${INPUT_FILE_1} ${INPUT_FILE_2} ... ${DESTINATION_DIRECTORY}\n");
        return;
    }
    index--;

    char temp_path[BUFFER_SIZE];
    if (args[index][0] == '/')
    {

        strcpy(temp_path, args[index]);

    } else
    {
    
        strcpy(temp_path, directory_path);
        if (temp_path[strlen(temp_path) - 1] != '/')
        {
            temp_path[strlen(temp_path)] = '/';
        }
        int k = 0;
        while (args[index][k] != '\0')
        {
            if (args[index][k] == '.')
            {
                if ((args[index][k + 1] == '/') || (args[index][k + 1] == '\0'))
                {
                    k += 2;
                }
                if (args[index][k + 1] == '.')
                {
                    if ((args[index][k + 2] == '/') || (args[index][k + 2] == '\0'))
                    {
                        if (strlen(temp_path) != 1)
                        {
                            temp_path[strlen(temp_path) - 1] = '\0';
                        }
                        for (int i = strlen(temp_path) - 1; temp_path[i] != '/'; i--)
                        {
                            temp_path[i] = '\0';
                        }
                        k += 3;
                    } else
                    {
                        printf("%s: Not a directory.\n", args[index]);
                        return;
                    }
                }
            } else
            {
                temp_path[strlen(temp_path)] = args[index][k++];
            }
        }
        if ((strlen(temp_path) != 1) && (temp_path[strlen(temp_path) - 1] == '/'))
        {
            temp_path[strlen(temp_path) - 1] = '\0';
        }
    
    }

    DIR* temp = opendir(temp_path);
    if(temp == NULL)
    {
        printf("%s: Not a directory.\n", args[index]);
        closedir(temp);
        return;
    }
    closedir(temp);
    index--;

    while (index >= 0)
    {

        FILE *file = fopen(args[index], "rb");
        char new_path[BUFFER_SIZE];
        for (int i = 0; i < BUFFER_SIZE; i++)
        {
            new_path[i] = '\0';
        }
        strcpy(new_path, temp_path);
        new_path[strlen(new_path)] = '/';
        strcat(new_path, args[index]);
        FILE *new = fopen(new_path, "wb");
        if (file == NULL || new == NULL)
        {
            printf("Error in opening file(s).\n");
            return;
        }

        char buffer[BUFFER_SIZE] = {0};
        int bytes_read;
        while ((bytes_read = fread(buffer, sizeof(char), BUFFER_SIZE, file)) > 0)
        {
            fwrite(buffer, sizeof(char), bytes_read, new);
        }
        fclose(new);
        fclose(file);
        remove(args[index]);

        index--;

    }

}