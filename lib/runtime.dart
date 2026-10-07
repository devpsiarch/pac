import 'package:pac/lex.dart';


const int stackLen = 500;
class Runtime {
    List<dynamic> stack = List<dynamic>.filled(stackLen,null);
    int top = 0;
    int frame = 0;
    Runtime();
    dynamic execute(List<Token> tokens){
        for(int i = 0 ; i < tokens.length ; i++){
            switch (tokens[i].type) {
                case TokenType.eof:
                    return stack[top-1];
                case TokenType.begin:
                case TokenType.end:
                    continue;
                case TokenType.identifer:
                    stack[top] = tokens[i].literal;
                    top++;
                case TokenType.plus:
                case TokenType.div:
                case TokenType.minus:
                case TokenType.mult:
                    if(top - 2 < 0){
                        print("Not enough elements on the stack to perform operation ($top).");
                        return null;
                    }
                    dynamic op1 = stack[top-2]; 
                    dynamic op2 = stack[top-1];
                    if(op1.runtimeType != op2.runtimeType){
                        print("Mismatch of operands types during execution of stack instruction.");
                        return null;
                    }
                    top -= 2;
                    if(tokens[i].type == TokenType.plus) stack[top] = op1 + op2;
                    if(tokens[i].type == TokenType.minus) stack[top] = op1 - op2;
                    if(tokens[i].type == TokenType.mult) stack[top] = op1 * op2;
                    if(tokens[i].type == TokenType.div) stack[top] = op1 ~/ op2;
                    top++;
                break;
                default:
                    print("Unreconized TokenType found during execution.");
                    return null;
            }
        }
    }
}
