#define MALLOC1(t) ((t*) malloc(sizeof(t)))

typedef struct _edge_t {
    _edge_t *next;
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

// REMEMBER TO FREE THE RETURN RESULT
edge_t *node_fan(i_node_t *ing){
    edge_t *out = NULL, *itr = ing->children, *ritr = NULL, *tmp = NULL ;
    
    while(itr != NULL){
        r_node_t *r = (r_node_t *) itr->node;
        ritr = r->children;
        while(ritr != NULL){
            tmp = MALLOC1(edge_t);
            tmp->next = out;
            tmp->node = ritr->node;
            
            out = tmp;
            
            ritr = ritr->next;
        }
        
        itr = itr->next;
    }
    
    return out;
}