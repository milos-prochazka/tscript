/// Tokenizer pro TScript jazyk
/// 
/// Převádí zdrojový kód na posloupnost tokenů.
library;

/// Typ tokenu
enum TsTokenType {
  keyword,      // Klíčové slovo (if, else, while, ...)
  identifier,   // Identifikátor (název proměnné, funkce, ...)
  number,       // Číselný literál
  string,       // Řetězcový literál
  operator,     // Operátor (+, -, *, /, ==, !=, ...)
  separator,    // Oddělovač (;, :, ,, ...)
  comment,      // Komentář
  error,        // Chyba v syntaxi
}

/// Token - základní stavební jednotka jazyka
class TsToken {
  /// Typ tokenu
  final TsTokenType type;
  
  /// Původní text tokenu ve zdrojovém kódu
  final String text;
  
  /// Zpracovaná hodnota tokenu
  /// - Pro čísla: num hodnota
  /// - Pro řetězce: String bez uvozovek a s vyhodnocenými escape sekvencemi
  /// - Pro ostatní: text tokenu
  final dynamic value;
  
  /// Číslo řádku (1-indexed)
  final int line;
  
  /// Číslo sloupce (1-indexed)
  final int column;
  
  /// Chybová zpráva (pouze pro typ error)
  final String? errorMessage;

  TsToken({
    required this.type,
    required this.text,
    required this.value,
    required this.line,
    required this.column,
    this.errorMessage,
  });

  @override
  String toString() {
    if (type == TsTokenType.error) {
      return 'TsToken(error at $line:$column: $errorMessage)';
    }
    return 'TsToken($type, "$text", value: $value, at $line:$column)';
  }
}

/// Řádek obsahující tokeny
class TsLine {
  /// Číslo řádku (1-indexed)
  final int lineNumber;
  
  /// Seznam tokenů na tomto řádku
  final List<TsToken> tokens;

  TsLine({
    required this.lineNumber,
    required this.tokens,
  });

  @override
  String toString() => 'TsLine($lineNumber): ${tokens.length} tokens';
}

/// Tokenizer pro TScript
class TsTokenizer {
  /// Klíčová slova jazyka
  final List<String> keywords;
  
  /// Operátory a oddělovače (seřazené od nejdelších pro správné zpracování)
  final List<String> operators;
  
  /// Zdrojový kód k analýze
  String _source = '';
  
  /// Aktuální pozice ve zdrojovém kódu
  int _pos = 0;
  
  /// Aktuální řádek (1-indexed)
  int _line = 1;
  
  /// Aktuální sloupec (1-indexed)
  int _column = 1;

  TsTokenizer({
    required this.keywords,
    required this.operators,
  });

  /// Tokenizuje zdrojový kód a vrací seznam řádků s tokeny
  List<TsLine> tokenize(String source) {
    _source = source;
    _pos = 0;
    _line = 1;
    _column = 1;

    List<TsLine> allLines = [];
    List<TsToken> currentLineTokens = [];
    int currentLineNumber = 1;

    while (!_isAtEnd()) {
      _skipWhitespace();
      
      if (_isAtEnd()) break;

      // Přeskočit komentáře
      if (_peek() == '#') {
        var comment = _readComment();
        currentLineTokens.add(comment);
        continue;
      }

      // Konec řádku
      if (_peek() == '\n') {
        _advance();
        
        // Uložit aktuální řádek pokud obsahuje tokeny
        if (currentLineTokens.isNotEmpty) {
          allLines.add(TsLine(
            lineNumber: currentLineNumber,
            tokens: List.from(currentLineTokens),
          ));
          currentLineTokens.clear();
        }
        
        currentLineNumber = _line;
        continue;
      }

      var token = _readNextToken();
      if (token != null) {
        currentLineTokens.add(token);
      }
    }

    // Uložit poslední řádek
    if (currentLineTokens.isNotEmpty) {
      allLines.add(TsLine(
        lineNumber: currentLineNumber,
        tokens: currentLineTokens,
      ));
    }

    // Spojit řádky začínající na +
    return _mergeLineContinuations(allLines);
  }

  /// Spojí řádky, které začínají znakem + (pokračování z předchozího řádku)
  List<TsLine> _mergeLineContinuations(List<TsLine> lines) {
    if (lines.isEmpty) return lines;

    List<TsLine> result = [];
    List<TsToken> mergedTokens = [];
    int baseLineNumber = lines[0].lineNumber;

    for (int i = 0; i < lines.length; i++) {
      var line = lines[i];
      
      // Kontrola, zda řádek začíná na +
      bool isContinuation = false;
      if (line.tokens.isNotEmpty) {
        var firstToken = line.tokens.first;
        // Řádek je pokračování, pokud první token je + a je na sloupci 1
        isContinuation = firstToken.column == 1 && 
                        firstToken.text == '+' && 
                        firstToken.type == TsTokenType.operator;
        if (isContinuation) {
          // Odstranit první token +
          line.tokens.removeAt(0);
        }
      }

      if (isContinuation && result.isNotEmpty) {
        // Přidat tokeny k předchozímu řádku
        mergedTokens.addAll(line.tokens);
      } else {
        // Uložit předchozí sloučený řádek
        if (mergedTokens.isNotEmpty) {
          result.add(TsLine(
            lineNumber: baseLineNumber,
            tokens: List.from(mergedTokens),
          ));
          mergedTokens.clear();
        }
        
        // Začít nový řádek
        baseLineNumber = line.lineNumber;
        mergedTokens.addAll(line.tokens);
      }
    }

    // Uložit poslední řádek
    if (mergedTokens.isNotEmpty) {
      result.add(TsLine(
        lineNumber: baseLineNumber,
        tokens: mergedTokens,
      ));
    }

    return result;
  }

  /// Přečte další token ze vstupu
  TsToken? _readNextToken() {
    if (_isAtEnd()) return null;

    int tokenLine = _line;
    int tokenColumn = _column;

    var ch = _peek();

    // Řetězce
    if (ch == '"' || ch == "'") {
      return _readString(tokenLine, tokenColumn);
    }

    // Čísla
    if (_isDigit(ch)) {
      return _readNumber(tokenLine, tokenColumn);
    }

    // Hexa čísla
    if (ch == '0' && _pos + 1 < _source.length && 
        (_source[_pos + 1] == 'x' || _source[_pos + 1] == 'X')) {
      return _readHexNumber(tokenLine, tokenColumn);
    }

    // Identifikátory a klíčová slova
    if (_isIdentifierStart(ch)) {
      return _readIdentifier(tokenLine, tokenColumn);
    }

    // Operátory a oddělovače
    return _readOperator(tokenLine, tokenColumn);
  }

  /// Přečte řetězec
  TsToken _readString(int tokenLine, int tokenColumn) {
    var quote = _advance();
    var text = quote;
    var value = StringBuffer();
    
    while (!_isAtEnd() && _peek() != quote) {
      if (_peek() == '\n') {
        // Neuzavřený řetězec
        return TsToken(
          type: TsTokenType.error,
          text: text,
          value: null,
          line: tokenLine,
          column: tokenColumn,
          errorMessage: 'Neuzavřený řetězec',
        );
      }
      
      if (_peek() == '\\') {
        text += _advance();
        if (!_isAtEnd()) {
          var escaped = _advance();
          text += escaped;
          
          // Zpracování escape sekvencí
          switch (escaped) {
            case 'n':
              value.write('\n');
              break;
            case 't':
              value.write('\t');
              break;
            case 'r':
              value.write('\r');
              break;
            case '\\':
              value.write('\\');
              break;
            case "'":
              value.write("'");
              break;
            case '"':
              value.write('"');
              break;
            case 'u':
              // Unicode escape sekvence
              if (!_isAtEnd() && _peek() == '{') {
                // \u{...} formát
                text += _advance(); // {
                var hexCode = '';
                while (!_isAtEnd() && _peek() != '}') {
                  var hexChar = _advance();
                  text += hexChar;
                  hexCode += hexChar;
                }
                if (!_isAtEnd() && _peek() == '}') {
                  text += _advance(); // }
                  try {
                    var codePoint = int.parse(hexCode, radix: 16);
                    value.write(String.fromCharCode(codePoint));
                  } catch (e) {
                    value.write('\\u{$hexCode}');
                  }
                }
              } else {
                // \uXXXX formát (4 hex číslice)
                var hexCode = '';
                for (int i = 0; i < 4 && !_isAtEnd(); i++) {
                  var hexChar = _advance();
                  text += hexChar;
                  hexCode += hexChar;
                }
                try {
                  var codePoint = int.parse(hexCode, radix: 16);
                  value.write(String.fromCharCode(codePoint));
                } catch (e) {
                  value.write('\\u$hexCode');
                }
              }
              break;
            default:
              value.write(escaped);
          }
        }
      } else {
        var ch = _advance();
        text += ch;
        value.write(ch);
      }
    }
    
    if (_isAtEnd()) {
      // Neuzavřený řetězec
      return TsToken(
        type: TsTokenType.error,
        text: text,
        value: null,
        line: tokenLine,
        column: tokenColumn,
        errorMessage: 'Neuzavřený řetězec',
      );
    }
    
    text += _advance(); // uzavírací uvozovka
    
    return TsToken(
      type: TsTokenType.string,
      text: text,
      value: value.toString(),
      line: tokenLine,
      column: tokenColumn,
    );
  }

  /// Přečte číslo
  TsToken _readNumber(int tokenLine, int tokenColumn) {
    var text = '';
    
    // Celá část
    while (!_isAtEnd() && (_isDigit(_peek()) || _peek() == '_')) {
      text += _advance();
    }
    
    // Desetinná část
    if (!_isAtEnd() && _peek() == '.' && 
        _pos + 1 < _source.length && _isDigit(_source[_pos + 1])) {
      text += _advance(); // .
      while (!_isAtEnd() && (_isDigit(_peek()) || _peek() == '_')) {
        text += _advance();
      }
    }
    
    // Exponent
    if (!_isAtEnd() && (_peek() == 'e' || _peek() == 'E')) {
      text += _advance();
      if (!_isAtEnd() && (_peek() == '+' || _peek() == '-')) {
        text += _advance();
      }
      while (!_isAtEnd() && (_isDigit(_peek()) || _peek() == '_')) {
        text += _advance();
      }
    }
    
    // Odstranit podtržítka pro parsování
    var cleanText = text.replaceAll('_', '');
    
    try {
      var value = num.parse(cleanText);
      return TsToken(
        type: TsTokenType.number,
        text: text,
        value: value,
        line: tokenLine,
        column: tokenColumn,
      );
    } catch (e) {
      return TsToken(
        type: TsTokenType.error,
        text: text,
        value: null,
        line: tokenLine,
        column: tokenColumn,
        errorMessage: 'Neplatné číslo: $text',
      );
    }
  }

  /// Přečte hexadecimální číslo
  TsToken _readHexNumber(int tokenLine, int tokenColumn) {
    var text = '';
    text += _advance(); // 0
    text += _advance(); // x nebo X
    
    while (!_isAtEnd() && (_isHexDigit(_peek()) || _peek() == '_')) {
      text += _advance();
    }
    
    // Odstranit podtržítka pro parsování
    var cleanText = text.replaceAll('_', '');
    
    try {
      var value = int.parse(cleanText.substring(2), radix: 16);
      return TsToken(
        type: TsTokenType.number,
        text: text,
        value: value,
        line: tokenLine,
        column: tokenColumn,
      );
    } catch (e) {
      return TsToken(
        type: TsTokenType.error,
        text: text,
        value: null,
        line: tokenLine,
        column: tokenColumn,
        errorMessage: 'Neplatné hexadecimální číslo: $text',
      );
    }
  }

  /// Přečte identifikátor nebo klíčové slovo
  TsToken _readIdentifier(int tokenLine, int tokenColumn) {
    var text = '';
    
    while (!_isAtEnd() && _isIdentifierPart(_peek())) {
      text += _advance();
    }
    
    // Kontrola, zda je to klíčové slovo
    var type = keywords.contains(text) 
        ? TsTokenType.keyword 
        : TsTokenType.identifier;
    
    return TsToken(
      type: type,
      text: text,
      value: text,
      line: tokenLine,
      column: tokenColumn,
    );
  }

  /// Přečte operátor nebo oddělovač
  TsToken _readOperator(int tokenLine, int tokenColumn) {
    // Hledat nejdelší odpovídající operátor
    String? matchedOp;
    
    for (var op in operators) {
      if (_pos + op.length <= _source.length) {
        var substring = _source.substring(_pos, _pos + op.length);
        if (substring == op) {
          if (matchedOp == null || op.length > matchedOp.length) {
            matchedOp = op;
          }
        }
      }
    }
    
    if (matchedOp != null) {
      var text = '';
      for (int i = 0; i < matchedOp.length; i++) {
        text += _advance();
      }
      
      return TsToken(
        type: TsTokenType.operator,
        text: text,
        value: text,
        line: tokenLine,
        column: tokenColumn,
      );
    }
    
    // Neznámý znak
    var ch = _advance();
    return TsToken(
      type: TsTokenType.error,
      text: ch,
      value: null,
      line: tokenLine,
      column: tokenColumn,
      errorMessage: 'Neplatný znak: $ch',
    );
  }

  /// Přečte komentář
  TsToken _readComment() {
    int tokenLine = _line;
    int tokenColumn = _column;
    var text = '';
    
    while (!_isAtEnd() && _peek() != '\n') {
      text += _advance();
    }
    
    return TsToken(
      type: TsTokenType.comment,
      text: text,
      value: text,
      line: tokenLine,
      column: tokenColumn,
    );
  }

  /// Přeskočí bílé znaky (kromě nových řádků)
  void _skipWhitespace() {
    while (!_isAtEnd()) {
      var ch = _peek();
      if (ch == ' ' || ch == '\t' || ch == '\r') {
        _advance();
      } else {
        break;
      }
    }
  }

  /// Vrátí aktuální znak bez posunu
  String _peek() {
    if (_isAtEnd()) return '\0';
    return _source[_pos];
  }

  /// Posune se na další znak
  String _advance() {
    if (_isAtEnd()) return '\0';
    
    var ch = _source[_pos];
    _pos++;
    
    if (ch == '\n') {
      _line++;
      _column = 1;
    } else {
      _column++;
    }
    
    return ch;
  }

  /// Kontrola konce vstupu
  bool _isAtEnd() => _pos >= _source.length;

  /// Kontrola, zda je znak číslice
  bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;

  /// Kontrola, zda je znak hex číslice
  bool _isHexDigit(String ch) {
    var code = ch.codeUnitAt(0);
    return (code >= 48 && code <= 57) ||  // 0-9
           (code >= 65 && code <= 70) ||  // A-F
           (code >= 97 && code <= 102);   // a-f
  }

  /// Kontrola, zda může znak začínat identifikátor
  bool _isIdentifierStart(String ch) {
    var code = ch.codeUnitAt(0);
    return (code >= 65 && code <= 90) ||   // A-Z
           (code >= 97 && code <= 122) ||  // a-z
           ch == '_';
  }

  /// Kontrola, zda může být znak součástí identifikátoru
  bool _isIdentifierPart(String ch) {
    return _isIdentifierStart(ch) || _isDigit(ch) || ch == '\$';
  }
}
