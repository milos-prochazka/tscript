
import 'package:tscript/tokenizer.dart';

void main(List<String> arguments) {
  final tk = TsTokenizer(
    keywords: ['if', 'else', 'while', 'return'],
    operators: ['+', '-', '*', '/', '==', '!=', '>', '<'],
  );

  final lines = tk.tokenize(r"""
# This is a comment
if a == 5 
+  return a + 10.33e+5 "22222\u{10041} \u0048"
end
""");

  for (var line in lines) {
    print('Line ${line.lineNumber}:');
    for (var token in line.tokens) {
      print(token.toString());
    }
  }
}
