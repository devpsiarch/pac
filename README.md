# PAC Programming Language

PAC is a minimalist, stack-based interpreted programming language. It processes expressions using Postfix (Reverse Polish) notation inside scoped execution blocks (`BEGIN` ... `END`).

## Example Code


```

BEGIN
	3 4 +
	BEGIN
		2 1 +
	END
	+
END

```

### Execution Trace
1. Pushes `3` and `4`, then adds them $\rightarrow$ Stack: `[7]`
2. Enters nested block, pushes `2` and `1`, then adds them $\rightarrow$ Stack: `[7, 3]`
3. Evaluates final addition operator $\rightarrow$ Stack: `[10]`

## Usage (Dart API)

```dart
import 'package:pac/lexer.dart';
import 'package:pac/runtime.dart';

void main() {
  // or read from file
  final content = '''
  BEGIN
      10 2 -
      4 /
  END
  ''';

  Lexer l = Lexer();
  l.lex(content);
  l.desc();

  Runtime vm = Runtime();
  dynamic result = vm.execute(l.tokens);

  print("Result of execution is $result"); // Output: 2
}

```

## Operations

| Operator | Description | Stack Action |
| --- | --- | --- |
| `BEGIN` / `END` | Scope block markers | Controls block context |
| `+` | Addition | Pops `b`, pops `a`, pushes `a + b` |
| `-` | Subtraction | Pops `b`, pops `a`, pushes `a - b` |
| `*` | Multiplication | Pops `b`, pops `a`, pushes `a * b` |
| `/` | Division | Pops `b`, pops `a`, pushes `a / b` |

## Current Limitations
* **Integer Numerics And Strings Only**: Evaluator only supports integer and string literals.
* **No Control Flow**: Missing conditional branching (`IF` / `ELSE`) and iteration/jumps (`GOTO`, `WHILE`).
* **No Custom Functions**: Execution is strictly linear across token streams.
