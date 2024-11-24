#include <commands.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define ARGUMENTS_SIZE 16

int main()
{

    char directory_path[BUFFER_SIZE] = {0};
    getcwd(directory_path, BUFFER_SIZE);

    signal(SIGINT, SIG_IGN);
    signal(SIGSTOP, SIG_IGN);
    signal(SIGTSTP, SIG_IGN);

    while (1)
    {

        DIR *directory = opendir(directory_path);
        printf("%s$: ", directory_path);

        char c = '\0';
        char commands[ARGUMENTS_SIZE][1024];
        for (int i = 0; i < ARGUMENTS_SIZE; i++)
        {
            for (int j = 0; j < 1024; j++)
            {
                commands[i][j] = '\0';
            }
        }
        int command = 0;
        while (c != '\n')
        {
            int index = 0;
            while (1)
            {
                scanf("%c", &c);
                if (c == '\"')
                {
                    while (1)
                    {
                        scanf("%c", &c);
                        if (c == '\"')
                        {
                            command++;
                            break;
                        }
                        commands[command][index++] = c;
                    }
                } else
                {
                    if ((c == ' ') || (c == '\t') || (c == '\n'))
                    {
                        command++;
                        break;
                    }
                    commands[command][index++] = c;
                }
            }
        }

        if (strcmp(commands[0], "") == 0)
        {
        } else if (strcmp(commands[0], "cat") == 0)
        {
            char **args = (char **) malloc((ARGUMENTS_SIZE - 1) * sizeof(char *));
            for (int i = 0; i < ARGUMENTS_SIZE - 1; i++)
            {
                args[i] = commands[i + 1];
            }
            custom_cat(args);
        } else if (strcmp(commands[0], "cd") == 0)
        {
            char *arg = commands[1];
            custom_cd(arg, directory_path);
        } else if (strcmp(commands[0], "cp") == 0)
        {
            char **args = (char **) malloc((ARGUMENTS_SIZE - 1) * sizeof(char *));
            for (int i = 0; i < ARGUMENTS_SIZE - 1; i++)
            {
                args[i] = commands[i + 1];
            }
            custom_cp(args, directory_path);
        } else if (strcmp(commands[0], "ls") == 0)
        {
            custom_ls(directory);
        } else if (strcmp(commands[0], "mv") == 0)
        {
            char **args = (char **) malloc((ARGUMENTS_SIZE - 1) * sizeof(char *));
            for (int i = 0; i < ARGUMENTS_SIZE - 1; i++)
            {
                args[i] = commands[i + 1];
            }
            custom_mv(args, directory_path);
        } else if (strcmp(commands[0], "exit") == 0)
        {
            break;
        } else
        {
            printf("%s: Command not found.\n", commands[0]);
        }

        closedir(directory);
        
    }

    return 0;

}