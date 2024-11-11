// External declarations and function definitions
extern int global_var;
static float static_var = 3.14;

// Function prototype
_Bool prototype_func(int a, char b);

// Function definition with various declaration specifiers
static inline int test_func(const int *restrict ptr, volatile long num) {
    // Compound statement
    {
        // Declarations
        int local_var = 42;
        char str[] = "Hello, world!";
        float complex_num = 1.0 + 2.7e-3;

        // Expressions
        local_var++;
        local_var += 5;
        local_var = (int)(local_var * 3.14);

        // Postfix expressions
        local_var--;
        prototype_func(local_var, str[0]);

        // Unary expressions
        int *ptr = &local_var;
        int val = *ptr;

        // Cast expressions
        float f = (float)local_var / 2;

        // Multiplicative and additive expressions
        int result = (local_var * 2) + (val / 2) - (local_var % 5);

        // Shift expressions
        unsigned int shifted = (val << 2) >> 1;

        // Relational and equality expressions
        if (local_var > 0 && local_var <= 100 && local_var != 50) {
            // Logical expressions
            int logical_result = (local_var > 50) || (local_var < 25 && local_var >= 10);
        }

        // Conditional expression
        int max = (local_var > val) ? local_var : val;

        // Assignment expressions
        local_var *= 2;
        ptr += 1;

        // Comma expression
        int x, y;
        x = 5, y = 10;

        // Labeled statements
        label:
            printf("Labeled statement\n");

        // Selection statements
        if (local_var == 42) {
            printf("local_var is 42\n");
        } else if (local_var > 42) {
            printf("local_var is greater than 42\n");
        } else {
            printf("local_var is less than 42\n");
        }

        switch (local_var) {
            case 0:
                printf("Zero\n");
                break;
            case 42:
                printf("The answer\n");
                break;
            default:
                printf("Something else\n");
        }

        // Iteration statements
        while (local_var > 0) {
            local_var--;
        }

        do {
            local_var++;
        } while (local_var < 10);

        for (int i = 0; i < 5; i++) {
            if (i == 2) continue;
            if (i == 4) break;
            printf("%d ", i);
        }

        // Jump statements
        goto label;

        return local_var;
    }
}

void id_list(a, b, c)
int a, b, c;
{
    printf("a = %d, b = %d, c = %d\n", a, b, c);
}

// Main function to tie it all together
int main() {
    int result = test_func(&global_var, 100);
    return result;
}
