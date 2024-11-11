#include "y.tab.c"
#include "lex.yy.c"
extern int yyparse();

symboltable findID(symboltable T, char* id) {
    node* p = T;
    while (p) {
        if(p->type == ID && !strcmp(p->id, id)) return p;
        p = p->next;
    }
    return NULL;
}

symboltable findNUM(symboltable T, int val) {
    node* p = T;
    while (p) {
        if(p->type == NUM && p->val == val) return p;
        p = p->next;
    }
    return NULL;
}

symboltable insertID(symboltable T, char* id) {
    node* p = findID(T, id);
    if (p) return T;
    p = (node*)malloc(sizeof(node));
    p->type = ID;
    p->id = (char*)malloc((strlen(id)+1)*sizeof(char));
    strcpy(p->id, id);
    p->valDefined = false;
    p->next = T;
    return p;
}

symboltable insertNUM(symboltable T, int val) {
    node* p = findNUM(T, val);
    if (p) return T;
    p = (node*)malloc(sizeof(node));
    p->type = NUM;
    p->val = val;
    p->next = T;
    return p;
}

void updateSymbolVal(symboltable T, char* id, int val) {
    node* p = findID(T, id);
    if (p) {
        p->valDefined = true;
        p->val = val;
    }
}



treenode* createNode(int type, symboltable T, treenode* left, treenode* right){
    treenode* node = (treenode*)malloc(sizeof(treenode));
    node->type = type;
    node->T = T;
    node->left = left;
    node->right = right;
    return node;
}

treenode* createLeafNode(int type, symboltable T){
    return createNode(type, T, NULL, NULL);
}

treenode* createInternalNode(int type, treenode* left, treenode* right){
    return createNode(type, NULL, left, right);
}

int eval(treenode* root){
    if(root->type == NUM){
        return root->T->val;
    }
    else if(root->type == ID){
        if(root->T->valDefined){
            return root->T->val;
        }
        else{
            yyerror("ID '%s' not defined", root->T->id);
        }
    }
    else{
        int left = eval(root->left);
        int right = eval(root->right);
        switch(root->type){
            case plus: return left + right;
            case minus: return left - right;
            case mul: return left * right;
            case dvd: {
                if(right == 0) yyerror("Division by zero");
                return left / right;
            }
            case mod: {
                if(right == 0) yyerror("Modulo by zero");
                return left % right;
            }
            case pwr: {
                if(left == 0 && right == 0) yyerror("0^0 is undefined");
                if(right < 0) yyerror("Negative exponent");
                return pow(left, right);
            }
        }
    }
    return 0;
}

void printTree (treenode* root, int level) {
    if (root == NULL) return;
    printTree(root->right, level + 1);
    for (int i = 0; i < level; i++) printf("    ");
    switch (root->type) {
        case plus: printf("+\n"); break;
        case minus: printf("-\n"); break;
        case mul: printf("*\n"); break;
        case dvd: printf("/\n"); break;
        case mod: printf("%%\n"); break;
        case pwr: printf("**\n"); break;
        case ID: printf("ID: %s\n", root->T->id); break;
        case NUM: printf("NUM: %d\n", root->T->val); break;
    }
    printTree(root->left, level + 1);
}

void deleteTree(treenode* root){
    if(root == NULL) return;
    deleteTree(root->left);
    deleteTree(root->right);
    free(root);
}


int main(){
    yyparse();
    return 0;
}

