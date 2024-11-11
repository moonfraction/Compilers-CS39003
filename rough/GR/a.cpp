#include "lex.yy.c"
#include "y.tab.c"

symboltable* updateSymbolTable(symboltable* head, char* idx, int v){
    symboltable* cur = head;
    while(cur != NULL){
        if(!strcmp(cur -> id, idx)){
            cur -> val = v;
            return head;
        }
        cur = cur -> next;
    }
    char* temp = strdup(idx);
    symboltable* newNode = new symboltable(temp, v);
    newNode -> next = head;
    return newNode;
}

int getFromSymbolTable(symboltable* head, char* idx){
    symboltable* cur = head;
    int ans;
    while(cur != NULL){
        if(!strcmp(cur -> id, idx)){
            ans = cur -> val;
            break;
        }
        cur = cur -> next;
    }
    return ans;
}

exprtree* createNumNode(int val){
    exprtree* newNode;
    newNode -> t=1;
    newNode -> data.val = val;
    return newNode;
}

exprtree* createIdNode(char* idx){
    exprtree* newNode;
    newNode -> t= 2;
    newNode -> data.id = strdup(idx);
    return newNode;
}

exprtree* createOpNode(int op, exprtree* left, exprtree* right){
    exprtree* newNode;
    newNode -> t=3;
    newNode -> data.opn.op = op;
    newNode -> data.opn.left = left;
    newNode -> data.opn.right = right;
    return newNode;
}

int evaluateExpr(exprtree* root, symboltable* head){
    if(root -> t == 1){
        return root -> data.val;
    }
    else if(root -> t == 2){
        return getFromSymbolTable(head, root -> data.id);
    }
    else{
        int val1 = evaluateExpr(root -> data.opn.left, head);
        int val2 = evaluateExpr(root -> data.opn.right, head);
        return calculateExpr(root -> data.opn.op, val1, val2);
    }
}

int calculateExpr(int op, int val1, int val2){
    int ans;
    switch (op){
    case 1: 
        ans = val1+val2; 
        break;
    case 2: 
        ans = val1-val2; 
        break;
    case 3: 
        ans = val1*val2; 
        break;
    case 4: 
        ans = val1/val2; 
        break;
    case 5: 
        ans = val1%val2; 
        break;
    case 6: 
        ans = (pow(val1,val2)+1e-9); 
        break;
    }
    return ans;
}

int main(){
    yyparse();
    return 0;
}