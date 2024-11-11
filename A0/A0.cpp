#include <iostream>
#include <stack>
#include <vector>
#include <cctype>
#include <string>
#include <map>

using namespace std;

// Function to tokenize the expression
vector<string> tokenize(const string& expr) {
    vector<string> tokens;
    for (int i = 0; i < expr.length(); ++i) {
        if (isdigit(expr[i])) {
            string num(1, expr[i]);
            while (i + 1 < expr.length() && isdigit(expr[i + 1])) {
                num += expr[++i];
            }
            tokens.push_back(num);
        } else if (expr[i] == '+' || expr[i] == '-' || expr[i] == '*' || expr[i] == '/' || expr[i] == '(' || expr[i] == ')') {
            tokens.push_back(string(1, expr[i]));
        }
    }
    return tokens;
}

// Reverse Polish Notation 
// Function to convert infix expression to postfix
vector<string> infixToPostfix(const vector<string>& tokens) {
    stack<string> s;
    vector<string> postfix;
    map<string, int> precedence;
    precedence["+"] = 1;
    precedence["*"] = 2;

    for (const string& token : tokens) {
        if (isdigit(token[0])) {
            postfix.push_back(token);
        } else if (token == "(") {
            s.push(token);
        } else if (token == ")") {
            while (!s.empty() && s.top() != "(") {
                postfix.push_back(s.top());
                s.pop();
            }
            s.pop(); // Pop the '('
        } else { // Operator
            while (!s.empty() && precedence[s.top()] >= precedence[token]) {
                postfix.push_back(s.top());
                s.pop();
            }
            s.push(token);
        }
    }
    while (!s.empty()) {
        postfix.push_back(s.top());
        s.pop();
    }
    return postfix;
}

// Function to evaluate postfix expression
int evaluatePostfix(const vector<string>& postfix) {
    stack<int> s;
    for (const string& token : postfix) {
        if (isdigit(token[0])) {
            s.push(stoi(token));
        } else {
            int op2 = s.top(); s.pop();
            int op1 = s.top(); s.pop();
            if (token == "+") s.push(op1 + op2);
            else s.push(op1 * op2);
        }
    }
    return s.top();
}

// Main function to evaluate the expression
int main() {
    string expression;
    cout << "Enter an expression: ";
    getline(cin, expression);

    vector<string> tokens = tokenize(expression);
    vector<string> postfix = infixToPostfix(tokens);
    int result = evaluatePostfix(postfix);

    cout << "Result: " << result << endl;

    return 0;
}