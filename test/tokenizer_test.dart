import 'package:tscript/tokenizer.dart';
import 'package:test/test.dart';

void main() {
  group('TsTokenizer String Tests', () {
    late TsTokenizer tokenizer;

    setUp(() {
      tokenizer = TsTokenizer(
        keywords: ['if', 'else', 'while'],
        operators: ['+', '-', '*', '/', '==', '!='],
      );
    });

    test('Typ 1: Jednořádkový řetězec s escape sekvencemi', () {
      var result = tokenizer.tokenize("'Hello\\nWorld'");
      expect(result.length, 1);
      expect(result[0].tokens.length, 1);
      
      var token = result[0].tokens[0];
      expect(token.type, TsTokenType.string);
      expect(token.text, "'Hello\\nWorld'");
      expect(token.value, 'Hello\nWorld');
    });

    test('Typ 1: Unicode escape sekvence \\uXXXX', () {
      var result = tokenizer.tokenize("'Test\\u0041B'");
      expect(result[0].tokens[0].value, 'TestAB');
    });

    test('Typ 1: Unicode escape sekvence \\u{...}', () {
      var result = tokenizer.tokenize("'Emoji\\u{1F600}!'");
      expect(result[0].tokens[0].value, 'Emoji😀!');
    });

    test('Typ 1: Chyba při novém řádku', () {
      var result = tokenizer.tokenize("'Unclosed\nstring'");
      expect(result[0].tokens[0].type, TsTokenType.error);
      expect(result[0].tokens[0].errorMessage, contains('Neuzavřený'));
    });

    test('Typ 2: Jednořádkový řetězec bez escape (kromě zdvojených uvozovek)', () {
      var result = tokenizer.tokenize('"Hello World"');
      expect(result[0].tokens[0].type, TsTokenType.string);
      expect(result[0].tokens[0].value, 'Hello World');
    });

    test('Typ 2: Zdvojené uvozovky pro vložení "', () {
      var result = tokenizer.tokenize('"Say ""Hello"""');
      expect(result[0].tokens[0].value, 'Say "Hello"');
    });

    test('Typ 2: Chyba při novém řádku', () {
      var result = tokenizer.tokenize('"Line1\nLine2"');
      expect(result[0].tokens[0].type, TsTokenType.error);
      expect(result[0].tokens[0].errorMessage, contains('nový řádek'));
    });

    test('Typ 3: Víceřádkový řetězec s escape sekvencemi', () {
      var result = tokenizer.tokenize("'''Line1\nLine2\nLine3'''");
      expect(result[0].tokens[0].type, TsTokenType.string);
      expect(result[0].tokens[0].value, 'Line1\nLine2\nLine3');
    });

    test('Typ 3: Víceřádkový s Unicode', () {
      var result = tokenizer.tokenize("'''Multi\\nLine\\u0041'''");
      expect(result[0].tokens[0].value, 'Multi\nLineA');
    });

    test('Typ 4: Víceřádkový řetězec bez escape', () {
      var result = tokenizer.tokenize('"""Line1\nLine2"""');
      expect(result[0].tokens[0].type, TsTokenType.string);
      expect(result[0].tokens[0].value, 'Line1\nLine2');
    });

    test('Typ 4: Čtyři uvozovky pro vložení """', () {
      var result = tokenizer.tokenize('"""Use """"quotes""""."""');
      expect(result[0].tokens[0].value, 'Use """quotes""".');
    });

    test('Různé typy řetězců v jednom kódu', () {
      var source = '''
'single'
"double"
\'\'\'triple
single\'\'\'
"""triple
double"""
''';
      var result = tokenizer.tokenize(source);
      
      expect(result.length, 4);
      expect(result[0].tokens[0].value, 'single');
      expect(result[1].tokens[0].value, 'double');
      expect(result[2].tokens[0].value, 'triple\nsingle');
      expect(result[3].tokens[0].value, 'triple\ndouble');
    });
  });

  group('TsTokenizer Basic Tests', () {
    late TsTokenizer tokenizer;

    setUp(() {
      tokenizer = TsTokenizer(
        keywords: ['if', 'else', 'while', 'for'],
        operators: ['+', '-', '*', '/', '==', '!=', '<=', '>=', '++', '--'],
      );
    });

    test('Čísla s podtržítky', () {
      var result = tokenizer.tokenize('1_000_000');
      expect(result[0].tokens[0].type, TsTokenType.number);
      expect(result[0].tokens[0].value, 1000000);
    });

    test('Hexadecimální čísla', () {
      var result = tokenizer.tokenize('0x1A3F');
      expect(result[0].tokens[0].type, TsTokenType.number);
      expect(result[0].tokens[0].value, 0x1A3F);
    });

    test('Desetinná čísla', () {
      var result = tokenizer.tokenize('3.14159');
      expect(result[0].tokens[0].type, TsTokenType.number);
      expect(result[0].tokens[0].value, 3.14159);
    });

    test('Exponenciální formát', () {
      var result = tokenizer.tokenize('1.5e10');
      expect(result[0].tokens[0].type, TsTokenType.number);
      expect(result[0].tokens[0].value, 1.5e10);
    });

    test('Identifikátory', () {
      var result = tokenizer.tokenize('myVar _private \$dollar');
      expect(result[0].tokens.length, 3);
      expect(result[0].tokens[0].type, TsTokenType.identifier);
      expect(result[0].tokens[0].value, 'myVar');
      expect(result[0].tokens[1].value, '_private');
      expect(result[0].tokens[2].value, '\$dollar');
    });

    test('Klíčová slova', () {
      var result = tokenizer.tokenize('if else while for');
      expect(result[0].tokens.length, 4);
      for (var token in result[0].tokens) {
        expect(token.type, TsTokenType.keyword);
      }
    });

    test('Komentáře', () {
      var result = tokenizer.tokenize('x = 5 # this is a comment');
      expect(result[0].tokens.length, 4);
      expect(result[0].tokens[3].type, TsTokenType.comment);
      expect(result[0].tokens[3].value, '# this is a comment');
    });

    test('Spojení řádků pomocí +', () {
      var source = '''x = 1
+ 2
+ 3''';
      var result = tokenizer.tokenize(source);
      
      // Všechny tokeny by měly být na jednom logickém řádku
      expect(result.length, 1);
      expect(result[0].lineNumber, 1);
      
      // Tokeny: x, =, 1, +, 2, +, 3
      expect(result[0].tokens.length, 7);
      
      // Ověření, že tokeny mají správné řádky (původní pozice)
      expect(result[0].tokens[0].line, 1); // x
      expect(result[0].tokens[3].line, 2); // +
      expect(result[0].tokens[5].line, 3); // +
    });

    test('Pozice tokenů', () {
      var result = tokenizer.tokenize('abc 123');
      expect(result[0].tokens[0].line, 1);
      expect(result[0].tokens[0].column, 1);
      expect(result[0].tokens[1].line, 1);
      expect(result[0].tokens[1].column, 5);
    });
  });
}
