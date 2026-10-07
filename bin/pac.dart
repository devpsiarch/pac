import 'package:pac/lex.dart';
import 'package:pac/runtime.dart';

void main(List<String> arguments) {
    Lexer l = Lexer();
    String? content = l.readCode("example_code/main.pac");
    if(content == null){
        return;
    }

    l.lex(content);
    l.desc();
    Runtime vm = Runtime();
    dynamic result = vm.execute(l.tokens);
    print("Result of execution is $result");
    // print("arr: ${vm.stack}");
}
