#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include "node.h"



int main(int argv, char **argc) {

  char input[500];
  char ingredients[10][50];
  
  int i = 0,n;

  FILE *pipe;
  pipe = open("pipe", O_RDWR);

  init_graph();

  do {

    //fgets(input, 100, pipe);
    do {
      n = read(pipe, input, 500);
      input[n] = '\0';
      printf("%s\n",input);
      char* tmp = strtok(input, "\t");
      i = 0;
      while(tmp != NULL) {
        strcpy(ingredients[i++], tmp);
        tmp = strtok(NULL,"\t");
      }
    } while(n>0);//still reading
    e.key = "butter";
    ep = hsearch(e, FIND);
    i_node_t* ii = ep->data;
    node_fan(ii);
  
  } while(strcmp(input, "exit\n"));
  return 0;
}
