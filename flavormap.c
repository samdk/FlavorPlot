#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main(int argv, char **argc) {
	
	char input[500];
	char ingredients[10][50];
	
	int i = 0;
	
	FILE *pipe;
	pipe = open("pipe", O_RDWR);
	
	do {
		fgets(input, 100, pipe);
		char* tmp = strtok(input, "\t");
		i = 0;
		while(tmp != NULL) {
			strcpy(ingredients[i++], tmp);
			tmp = strtok(NULL,"\t");
		}
		
		
		
	} while(strcmp(input, "exit\n"));
	return 0;
}
