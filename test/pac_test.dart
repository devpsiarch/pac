import 'package:test/test.dart';
import 'package:pac/lex.dart';
import 'package:pac/runtime.dart';

void main() {
  group('Lexer Tests', () {
    late Lexer lexer;

    setUp(() {
      lexer = Lexer();
    });

    test('empty input returns only EOF', () {
      lexer.lex('');
      expect(lexer.tokens, [
        Token(TokenType.eof, null),
      ]);
    });

        

    test('lexes single character operators', () {
      lexer.lex('+ - * /');
      expect(lexer.tokens, [
        Token(TokenType.plus, null),
        Token(TokenType.minus, null),
        Token(TokenType.mult, null),
        Token(TokenType.div, null),
        Token(TokenType.eof, null),
      ]);
    });

    test('lexes keywords BEGIN and END', () {
      lexer.lex('BEGIN END');
      expect(lexer.tokens, [
        Token(TokenType.begin, null),
        Token(TokenType.end, null),
        Token(TokenType.eof, null),
      ]);
    });

    test('lexes literals correctly', () {
      lexer.lex('1 2 3 67 69 420');
      expect(lexer.tokens, [
        Token(TokenType.identifer, 1),
        Token(TokenType.identifer, 2),
        Token(TokenType.identifer, 3),
        Token(TokenType.identifer, 67),
        Token(TokenType.identifer, 69),
        Token(TokenType.identifer, 420),
        Token(TokenType.eof, null),
      ]);
    });

    test('does not mistake keywords embedded inside identifiers', () {
      lexer.lex('BEGINNER ENDING');
      expect(lexer.tokens, [
        Token(TokenType.eof, null),
      ]);
    });
  });


group('Interpretation tests', () {
  late Lexer l;
  late Runtime vm;

  setUp(() {
    l = Lexer();
    vm = Runtime();
  });

  test('Simple literal evaluation', () {
    final content = '42';
    l.lex(content);
    dynamic result = vm.execute(l.tokens);
    expect(result, equals(42));
  });

  test('Simple addition with literals', () {
    final content = '3 4 +';
    l.lex(content);
    dynamic result = vm.execute(l.tokens);
    expect(result, equals(7));
  });

  test('Nested BEGIN/END block addition (Provided Example)', () {
    final content = '''
    BEGIN
        3 4 +
        BEGIN
        2 1 +
        END
        +
    END
    ''';
    l.lex(content);
    l.desc();
    dynamic result = vm.execute(l.tokens);
    expect(result, equals(10));
  });

  test('Subtraction and Division operand ordering', () {
    final content = '''
    BEGIN
        10 2 -
        4 /
    END
    ''';
    l.lex(content);
    dynamic result = vm.execute(l.tokens);
    expect(result, equals(2));
  });

  test('Multiple operations across nested blocks', () {
    final content = '''
    BEGIN
        10
        BEGIN
            5 2 *
        END
        -
    END
    ''';
    l.lex(content);
    dynamic result = vm.execute(l.tokens);
    expect(result, equals(0));
  });

  test('Deeply nested BEGIN/END blocks', () {
    final content = '''
    BEGIN
        BEGIN
            BEGIN
                100 20 /
            END
            2 *
        END
        10 +
    END
    ''';
    l.lex(content);
    dynamic result = vm.execute(l.tokens);
    expect(result, equals(20));
  });
});

}
