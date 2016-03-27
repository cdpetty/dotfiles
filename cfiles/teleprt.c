#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <stdlib.h>

char* getComponent(char component[], char* path){
    int iterator;
    char* pathPointer = path;
    for(iterator = 0; *pathPointer != '/' && *pathPointer; iterator++, pathPointer++);
    memcpy(component, path, iterator);
    component[iterator] = '\0';
    return (*pathPointer == '\0') ? pathPointer : ++pathPointer;
}


int doesMatch(char component[], char* name){
    return strncmp(component, name, strlen(component));
}

char* getDir(char component[], char* name){

    DIR *directory;
    struct dirent *de;

    if (!(directory = opendir(name))){
        fputs("TP error: cannot open directory", stderr);
        exit(1);
    }

    while ( (de = readdir(directory)) ){
        if (de->d_type == DT_DIR) {
            if (doesMatch(component, de->d_name) == 0) {
                closedir(directory);
                return de->d_name;
            }
        }
    }
    return NULL;
}

int main(int argc, char **argv, char **envp){

    if (argc == 1){
        puts(getenv("HOME"));
    } else {
        char component[30];
        char* path = *(++argv);

        char realPath[70];
        bzero(realPath, sizeof(realPath));
        if (*path == '/'){
            strcat(realPath, "/.");
            path++;
        } else {
            strcat(realPath, ".");
        }

        while (*path) {
            path = getComponent(component, path);
            strcat(realPath, "/");
            char* newDir = getDir(component, realPath);
            if (newDir){
                strcat(realPath, newDir);
            } else {
                puts(".");
                return 0;
            }
        }

        puts(realPath);
    }
    return 0;
}
