#include <iostream>
#include <stack>
#include <string>
#include <stdlib.h>
#include "lex.yy.c"
using namespace std;
typedef struct _node {
   char *name;
   struct _node *next;
} node;
typedef node *symboltable;

symboltable addtbl ( symboltable T, char *id )
{
   node *p;

   p = T;
   while (p) {
      if (!strcmp(p->name,id)) { //Identifier already exists
        return T;
      }
      p = p -> next;
   }

    // Adding new identifier
   p = (node *)malloc(sizeof(node));
   p -> name = (char *)malloc((strlen(id)+1) * sizeof(char));
   strcpy(p -> name, id);
   p -> next = T;
   return p;
}

symboltable searchtbl ( symboltable T, char *id )
{
   node *p;

   p = T;
   while (p) {
      if (!strcmp(p->name,id)) {
         return p;
      }
      p = p -> next;
   }
   return NULL;
}

typedef struct treenode{
    int type; //OP or ID or NUM
    union {
        char op;
        symboltable T; // for ID
        symboltable C; // for NUM
    } u;
    struct treenode *left, *right;
} tree;

void input(symboltable T){
    if(T == NULL) return;
    input(T->next);
    yylex(); // for \n
    yylex();
    cout<<T->name<<" = ";
    T->name = yytext;
    cout<<T->name<<endl;
}

void printParseTree(tree *root, int space = 0){
    if (root == NULL) return;
    for (int i = 0; i < space-6; i++) cout << " ";
    if(space)cout<<"---> ";
    if (root->type == 0){ // ID
        cout << "ID(" << root->u.T->name << ")" << endl;
    } 
    else if(root->type == 1){ // OP
        cout << "OP(" << root->u.op << ")" << endl;
    }
    else if(root->type == 2){ // NUM
        cout << "NUM(" << root->u.C->name << ")" << endl;
    }
    printParseTree(root->left, space + 6);
    printParseTree(root->right, space + 6);
}

int eval(tree *root){
    if(root == NULL) return 0;
    if(root->type == 0){ // ID
        return atoi(root->u.T->name);
    }
    else if(root->type == 2){ // NUM
        return atoi(root->u.C->name);
    }
    else {
        int left = eval(root->left);
        int right = eval(root->right);
        if(root->u.op == '+') return left + right;
        else if(root->u.op == '-') return left - right;
        else if(root->u.op == '*') return left * right;
        else if(root->u.op == '/') return left / right;
        else if(root->u.op == '%') return left % right;
    }
    return 0;
}


int main ()
{
    symboltable T = NULL; // for ID
    symboltable C = NULL; // for NUM

    stack<tree *> s;
    int token;
    tree* root = NULL;
    int balanced = 0;
    while((token = yylex()) != 0){
        // cout<<yytext<<" "<<token<<endl;
        if(token == ERR){
            string error = yytext;
            while(yylex() != WS) error += yytext;
            cout<<"*** Error: Invalid operator " << error <<" found"<< endl;
            return 1;
        }
        else if(token == LP){
            balanced++;
            tree* node = (tree *)malloc(sizeof(tree));
            node->type = 3;
            node->u.op = '(';   
            node->left = NULL;
            node->right = NULL;
            if(s.empty()){
                s.push(node);
                continue;
            }
            tree* tos = s.top();
            if(tos->left && tos->right){
                cout<<"*** Error: Right parenthesis expected in place of (" << endl;
                return 1; //prev op already has two children, we cant add another expr in here
            }
            s.push(node);
        }
        else if(token == RP){
            balanced--;
            if(s.empty()){
                cout<<"*** Error: LP expected in place of )" << endl;
                return 1; //no left parenthesis
            }
            tree* node = s.top();
            
            if(node->left && node->right) s.pop();
            else {
                cout<<"*** Error: ID/NUM/LP expected in place of )" << endl;
                return 1; //prev op does not have two children
            }
        }
        else if(token == OP){
            tree* node = (tree *)malloc(sizeof(tree));
            node->type = 1;
            node->u.op = *yytext;
            node->left = NULL;
            node->right = NULL;

            if(s.empty()){
                cout<<"*** Error: LP expected in place of " << yytext << endl;
                return 1; //no left parenthesis :: + 
            }

            tree* tos = s.top();
            if(tos->u.op == '('){
                s.pop();
            }
            else {
                cout<<"*** Error: ID/NUM/LP expected in place of " << yytext << endl;
                return 1; //no left parenthesis or in place of ID/NUM :: (+ c *)
            }
            // cout<<"Pushing "<<yytext<<endl;

            if(!s.empty()){
                tree* par = s.top();
                if(par->left && par->right){
                    cout<<"*** Error: Right parenthesis expected in place of " << yytext << endl;
                    return 1; // prev op already has two children 
                }
                if(par->left == NULL){
                    par->left = node;
                } else {
                    par->right = node;
                }
            }
            else {
                root = node;
            }
            s.push(node);
        }
        else if(token == ID){
            T = addtbl(T, yytext);
            symboltable p = searchtbl(T, yytext);
            tree* node = (tree *)malloc(sizeof(tree));
            node->type = 0;
            node->u.T = p;
            node->left = NULL;
            node->right = NULL;
            
            tree* par = s.top();
            if(!par){
                cout<<"*** Error: Operator expected in place of " << yytext << endl;
                return 1; //no operator  :: c
            }
            if(par->type == 3 && par->u.op == '('){
                cout<<"*** Error: Operator expected in place of " << yytext << endl;
                return 1; //no operator ::  (x * y)
            }
            if(par->left && par->right){
                cout<<"*** Error: Right parenthesis expected in place of " << yytext << endl;
                return 1; // prev op already has two children 
            }
            if(par->left == NULL){
                par->left = node;
            } else {
                par->right = node;
            }
        }
        else if(token == NUM){
            C = addtbl(C, yytext);
            tree* node = (tree *)malloc(sizeof(tree));
            node->type = 2;
            node->u.C = C;
            node->left = NULL;
            node->right = NULL;
            
            tree* par = s.top();
            if(!par){
                cout<<"*** Error: Operator expected in place of " << yytext << endl;
                return 1; //no operator  :: 2
            }
            if(par->type == 1 && par->u.op == '('){
                cout<<"*** Error: Operator expected in place of " << yytext << endl;
                return 1; //no operator ::  (x * y)
            }
            if(par->left && par->right){
                cout<<"*** Error: Right parenthesis expected in place of " << yytext << endl;
                return 1; // prev op already has two children 
            }
            if(par->left == NULL){
                par->left = node;
            } else {
                par->right = node;
            }
        }
        else if(token == WS){
            continue;
        }
        else{
            cout<<"*** Error: Invalid token " << yytext << endl;
        }

        if(balanced == 0){
            cout<<"Parsing is successful"<<endl;
            break;
        }
    }

    printParseTree(root);
    cout<<endl;    
    // cout<<"Parse tree is successfully created"<<endl;

    if(T) {
        cout<<"Reading variable values from the input"<<endl;
        input(T);
    }

    cout<<"The expression evaluates to "<<eval(root)<<endl;

    return 0;
}