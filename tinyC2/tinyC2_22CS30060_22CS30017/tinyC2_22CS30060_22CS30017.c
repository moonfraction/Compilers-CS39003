#include "lex.yy.c"
#include "y.tab.c"

void add_node(tree parent, tree child)
{
    parent->size++;
    if (parent->size == 1 || (parent->size & parent->size - 1) == 0)
        parent->adj_list = realloc(parent->adj_list, parent->size * 2 * sizeof(tree_node *));
    parent->adj_list[parent->size - 1] = child;
}

tree create_node_int(int value)
{
    tree_node *node = malloc(sizeof(tree_node));
    node->type = 0;
    node->size = 0;
    node->adj_list = NULL;
    node->u.int_value = value;
    return node;
}

tree create_node_float(float value)
{
    tree_node *node = malloc(sizeof(tree_node));
    node->type = 1;
    node->size = 0;
    node->adj_list = NULL;
    node->u.float_value = value;
    return node;
}

tree create_node_name(char *name)
{
    tree_node *node = malloc(sizeof(tree_node));
    node->type = 2;
    node->size = 0;
    node->adj_list = NULL;
    node->u.name = name;
    return node;
}

tree create_node_char(char value)
{
    tree_node *node = malloc(sizeof(tree_node));
    node->type = 3;
    node->size = 0;
    node->adj_list = NULL;
    node->u.character = value;
    return node;
}

void print_tree(tree node, int depth)
{
    for (int i = 0; i < depth; i++)
        printf("    ");
    printf("-->");
    if (node->type == 0)
        printf("%d\n", node->u.int_value);
    else if (node->type == 1)
        printf("%f\n", node->u.float_value);
    else if (node->type == 2)
        printf("%s\n", node->u.name);
    else if (node->type == 3)
        printf("%c\n", node->u.character);
    else
        printf("Error\n");

    for (int i = 0; i < node->size; i++)
    {
        print_tree(node->adj_list[i], depth + 1);
    }
}


int main(int argc, char **argv){
    yyparse();
    return 0;
}
