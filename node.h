#include <stdlib.h>
#include <search.h>
#include <string.h>
#include <stdio.h>

#define MALLOC1(t) ((t*) malloc(sizeof(t)))



typedef struct _edge_t {
  struct _edge_t *next;
  void    *node;
} edge_t;

typedef struct _i_node_t {
  edge_t *children ;
  char   *name     ;
} i_node_t;

typedef struct _r_node_t {
  edge_t *children ;
} r_node_t;

i_node_t *i_node_create(char *name){
  i_node_t *node = MALLOC1(i_node_t);
  node->children = NULL;
  node->name     = name;

  return node;
}

r_node_t *r_node_create(){
  r_node_t *node = MALLOC1(r_node_t);
  node->children = NULL;
  return node;
}
void node_connect(i_node_t*, r_node_t*);
void add_graph_entry(unsigned int, char*);
void node_connect(i_node_t *ing, r_node_t *r_id) {
  edge_t *i2r = MALLOC1(edge_t),
         *r2i = MALLOC1(edge_t);

  i2r->node = r_id;
  i2r->next = r_id->children;
  r_id->children = i2r;

  r2i->node = ing;
  r2i->next = ing->children;
  ing->children = r2i;
}

//REMEMBER TO FREE THE RETURN RESULT
void node_fan(i_node_t *ing){
  if (ing == NULL){
    printf("slut");
    exit(1);
  }
  edge_t *itr = ing->children, *ritr = NULL, *tmp = NULL ;
   if (itr == NULL){
    printf("whore\n");
    exit(1);
  }
//FILE *in_pipe = fopen("in_pipe", "a");
  while(itr != NULL){
    fprintf(stdout, "BOO\n");
    r_node_t *r = (r_node_t *) itr->node;
    ritr = r->children;
    while(ritr != NULL){
    
      fprintf(stdout, "%s,",((i_node_t *)ritr->node)->name);

      ritr = ritr->next;
    }
    fprintf(stdout, "\t");
    itr = itr->next;
  }
  fflush(stdout); 
}


r_node_t *recipe_ids;
ENTRY e, *ep;
void init_graph(){
  hcreate(45307);  
  int i =1;
  recipe_ids = (r_node_t*) malloc(45307 * sizeof(r_node_t));
  FILE *fp = fopen("round1.csv", "r");
  char line[1024];
  while (fgets(line, sizeof (line), fp) != NULL){
    // remove the new line
    line[strlen(line)-1] = '\0';
    char* tmp = strtok(line, ",");
    int id = atoi(tmp);
    tmp = strtok(NULL, ",");
    add_graph_entry(i, tmp);
  }
  //printf("%d\n",i);
  printf("I'm done reading the file bitches!\n");
}

void add_graph_entry(unsigned int  recipe_id, char *name){
  r_node_t recipe = (r_node_t) recipe_ids[recipe_id-1];

  i_node_t *ingredient = NULL;
  e.key = name;
  if((ep = hsearch(e,FIND))!=NULL){ 
    
    ingredient = (i_node_t *) ep->data;/* PRAS -- get node from graph */;
  }else {
    ingredient = i_node_create(name);
    e.data = ingredient;
    ep = hsearch(e, ENTER);
    if (ep == NULL){
      fprintf(stderr, "entry failed\n");
      exit(1);
    }
  }

  node_connect(ingredient, &recipe);
}






