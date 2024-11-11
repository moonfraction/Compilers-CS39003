#include "lex.yy.c"
#include "y.tab.c"
#include <math.h>

int main(){
    yyparse();
    setatt(PT);

    printf("+++ The annotated tree is\n");
    print_tree(PT, 0);
    printf("\n");

    for (int i = -5; i <=5; i++){
        printf("+++ f(%2d) = %10d\n", i, evalpoly(PT, i));
    }

    printf("\n+++ f'(x) = ");
    printderivative(PT);
    if(const_poly) printf("0");
    
    return 0;
}

void add_node(tree parent, tree child){
    parent->size++;
    if (parent->size == 1 || (parent->size & parent->size - 1) == 0)
        parent->children = realloc(parent->children, parent->size * 2 * sizeof(tree_node *));
    parent->children[parent->size - 1] = child;
}

tree create_node(int inh, int val, char* type){
    tree new_node = (tree)malloc(sizeof(tree_node));
    new_node->inh = inh;
    new_node->val = val;
    new_node->type = type;
    new_node->size = 0;
    new_node->children = NULL;
    return new_node;
}

void print_tree(tree node, int depth)
{
    for (int i = 1; i < depth; i++)
        printf("    ");
    if(depth) printf("--> ");

    if(!(strcmp(node->type, "s")) ) printf("S []\n");
    else if(!(strcmp(node->type, "p")) ) {
        int i = node->inh;
        if(i==1) printf("P [inh = +]\n");
        else if(i==-1) printf("P [inh = -]\n");
        else printf("P []\n");
    }
    else if(!(strcmp(node->type, "+"))) printf("+ []\n");
    else if(!(strcmp(node->type, "-"))) printf("- []\n");
    else if(!(strcmp(node->type, "t"))){
        int i = node->inh;
        if(i==1) printf("T [inh = +]\n");
        else if(i==-1) printf("T [inh = -]\n");
        else printf("T []\n");
    }
    else if(!(strcmp(node->type, "1"))) printf("1 [val = 1]\n"); 
    else if(!(strcmp(node->type, "0"))) printf("0 [val = 0]\n"); 
    else if(!(strcmp(node->type, "D"))) printf("%d [val = %d]\n", node->val, node->val);
    else if(!(strcmp(node->type, "^"))) printf("^ []\n"); 
    else if(!(strcmp(node->type, "X"))) printf("X []\n");
    else if(!(strcmp(node->type, "x"))) printf("x []\n");
    else if(!(strcmp(node->type, "n"))) {
        printf("N [val = %d]\n", node->val);
    }
    else if(!(strcmp(node->type, "m")) ) {
        printf("M [inh = %d, val = %d]\n", node->inh, node->val);
    }
    else printf("%s [inh = %d, val = %d]\n", node->type, node->inh, node->val);

    for (int i = 0; i < node->size; i++)
        print_tree(node->children[i], depth + 1);
}

void setatt(tree node){
    if(!strcmp(node->type, "s")){
        if(node->size == 2){
            int PorM = strcmp(node->children[0]->type, "+") == 0 ? 1 : -1;
            node->children[1]->inh = PorM;
        }
    }
    else if(!strcmp(node->type, "p")){
        node->children[0]->inh = node->inh;
        if(node->size == 3){
            int PorM = strcmp(node->children[1]->type, "+") == 0 ? 1 : -1;
            node->children[2]->inh = PorM;
        }
    }
    else if(!strcmp(node->type, "n")){
        if(node->size == 2){
            node->children[1]->inh = node->children[0]->val;
        }
    }
    else if(!strcmp(node->type, "m")){
        if(node->size == 2){
            node->children[1]->inh = (node->inh)*10 + (node->children[0]->val);
        }
    }

    for(int i = 0; i < node->size; i++){
        setatt(node->children[i]);
    }

    if(!strcmp(node->type, "m")){
        if(node->size == 2){
            node->val = node->children[1]->val;
        }
        else node->val = node->inh*10 + node->children[0]->val;
    }
    else if(!strcmp(node->type, "n")){
        if(node->size == 2){
            node->val = node->children[1]->val;
        }
        else node->val = node->children[0]->val;
    }   
}

int evalpoly(tree node, int x){
    if(!strcmp(node->type, "s")){
        if(node->size == 2){
            return evalpoly(node->children[1], x);
        }
        else return evalpoly(node->children[0], x);
    }
    else if(!strcmp(node->type, "p")){
        if(node->size == 3){
            return evalpoly(node->children[2], x) + evalpoly(node->children[0], x);
        }
        else return evalpoly(node->children[0], x);
    }
    else if(!strcmp(node->type, "n")){
        return node->val;
    }
    else if(!strcmp(node->type, "X")){
        if(node->size == 1) return x;
        else {
            int xp = evalpoly(node->children[2], x);
            return pow(x, xp);
        }
    }
    else if(!strcmp(node->type, "t")){
        if(node->size == 1){
            int v;
            if(!strcmp(node->children[0]->type, "X")) v = evalpoly(node->children[0], x);
            else if(!strcmp(node->children[0]->type, "n")) v = evalpoly(node->children[0], x);
            else v = 1;
            if(node->inh == -1) return -v;
            else return v;
        }
        else{
            int N_val = evalpoly(node->children[0], x);
            int X_val = evalpoly(node->children[1], x);
            if(node->inh == -1) return N_val*X_val*(-1);
            else return N_val*X_val;
        }
    }
    return 0;
}

void printderivative(tree node){
    if(!strcmp(node->type, "p")){
        if(node->size == 3){
            printderivative(node->children[0]);
            printderivative(node->children[2]);
        }
        else printderivative(node->children[0]);
    }
    else if(!strcmp(node->type, "t")){
        if(node->size == 1){ // 1 | X | N
            if(!strcmp(node->children[0]->type, "X")) {
                if(node->inh == -1) printf(" - ");
                if(!const_poly) if(node->inh == 1) printf(" + ");
                const_poly = 0;

                if(node->children[0]->size == 1) printf("1");
                else if(node->children[0]->size == 3){
                    int xp = evalpoly(node->children[0]->children[2], 0);
                    if(xp==2) printf("2x");
                    else printf("%dx^%d", xp, xp-1);
                }
            }
        }
        else{ // N * X
            if(node->inh == -1) printf(" - ");
            if(!const_poly) if(node->inh == 1) printf(" + ");
            const_poly = 0;

            int N_val = evalpoly(node->children[0], 0);
            tree X_val = node->children[1];
            if(X_val->size == 1) printf("%d", N_val);
            else if(X_val->size == 3){
                int xp = evalpoly(X_val->children[2], 0);
                if(xp==2) printf("%dx", N_val*2);
                else printf("%dx^%d", N_val*xp, xp-1);
            }
        }
    }
    else for (int i = 0; i < node->size; i++)
        printderivative(node->children[i]);

}