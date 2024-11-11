// Single-line comment: Test of all tokens in tinyC

/* Multi-line comment:
   Testing various keywords, identifiers, constants, string literals, and punctuators 
*/

int main() {
    int a = 100;         // integer constant
    a <<= 2;             // shift operator
    float b = 3.14e-2;   // floating constant
    char c = 'x';        // character constant
    c = '\n';            // escape sequence
    char str[] = "TinyC Lexer Test";  // string literal
    int _id123 = 0;      // identifier with underscore and digits
    
    // Keywords
    if (a > 10) {
        while (b < 1.0) {
            a++;
        }
    }

    // Identifiers and punctuators
    a = a + b * 10 - c / 2;
    str[0] = c;
    
    // Punctuators
    int *p = &a;       // pointer and address-of operators
    int arr[5] = {1, 2, 3, 4, 5};  // array initialization
    p = (a > 0) ? &a : &arr[0];    // conditional operator
    
    // More Keywords and identifiers
    return a;
}

// Testing string literals and escape sequences
char *msg = "Line1\nLine2\tTabbed";
char *msg2 = "This is a \"quote\"";
char *msg3 = "";