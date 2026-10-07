import 'dart:io';


enum TokenType {
    plus,minus,mult,div,begin,end,identifer,eof
}

class Token {
    final TokenType type;
    final dynamic literal;

    Token(this.type,this.literal);
    void describe() {
        if (literal != null) {
            print('Type: ${type.name}, Literal: $literal (Type: ${literal.runtimeType})');
        } else {
            print('Type: ${type.name}');
        }
    }
    
    // we need to override these to be able to compair to objects of the same 
    // type , currenltly being used only in the test file
    @override int get hashCode => Object.hash(type, literal);
    @override bool operator ==(Object other) =>
        identical(this, other) ||
        other is Token &&
        runtimeType == other.runtimeType &&
        type == other.type &&
        literal == other.literal;
}

class Lexer {
    int line = 0;
    int index = 0;
    List<Token> tokens = [];
    Lexer();
    String? readCode(String filename){
        try {
            final file = File(filename);
            return file.readAsStringSync();
        }catch (e){
            print("Reading code file failed, reason: ${e.toString()}");
            return null;
        }
    }
    bool scanToken(String content){
        while(index < content.length && content[index] == ' '){ 
            index++;
        }
        if(index >= content.length) return true;
        switch (content[index]){
            case '+':
                tokens.add(Token(TokenType.plus,null));
                index++;
            case '-':
                tokens.add(Token(TokenType.minus,null));
                index++;
            case '*':
                tokens.add(Token(TokenType.mult,null));
                index++;
            case '/':
                tokens.add(Token(TokenType.div,null));
                index++;
            case '\n':
                line++;
                index++;
            default:
                if(int.tryParse(content[index]) != null){
                    String mark = "";
                    while(index < content.length && int.tryParse(content[index]) != null){
                        mark += content[index];
                        index++;
                    }
                    tokens.add(Token(TokenType.identifer,int.tryParse(mark)));
                    index++;
                }else{
                    String mark = "";
                    while(index < content.length && content[index] != " " && content[index] != "\n"){
                        mark += content[index];
                        index++;
                    }
                    switch (mark) {
                        case "BEGIN":
                            tokens.add(Token(TokenType.begin,null));
                        case "END":
                            tokens.add(Token(TokenType.end,null));
                        default:
                            return false;
                    }
                    return true;
                }
        }
        return true;
    }
    void lex(String content){
        clear();
        while(index < content.length){
            if(!scanToken(content)){
                print("unreconized keyword, line: ${line+1},char: ${index+1}");
                clear();
                break;
            }
        }
        tokens.add(Token(TokenType.eof,null));
    }
    void desc(){
        for(int i = 0 ; i < tokens.length ; i++){
            tokens[i].describe();
        }
    }
    void clear() => tokens = [];
}
