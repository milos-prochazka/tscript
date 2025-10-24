# Tokenizer

**verze 1**

- Tokenizer čte vstupní soubor a převádí jej na posloupnost tokenů. Tokeny jsou základní stavební kameny jazyka, jako jsou klíčová slova, identifikátory, operátory a literály.

- Tokenizer je implementován jako třída `TsTokenizer`, která obsahuje metody pro čtení vstupního souboru a generování tokenů.

- Vstupem je textový řetězec obsahující zdrojový kód, který má být analyzován.

- Výstupem je seznam tokenů (třída `TsToken`), kde každý token je reprezentován jako objekt obsahující typ tokenu a jeho hodnotu.

- Tokenizer také zajišťuje správné zpracování bílých znaků, komentářů a chyb v syntaxi.

- Tokenizer je v jazyce Dart.

- Rozlišuje následující typy tokenů:
  - Klíčová slova (např. `if`, `else`, `while`), zadaná v poli `keywords`.
  - Identifikátory (např. názvy proměnných a funkcí)
    -  Začínají písmenem nebo podtržítkem, následují písmena, číslice nebo podtržítka a znaky $.
  - Literály (čísla a řetězce).
    -  Čísla mohou být celá (např. `123`), desetinná (např. `3.14`) nebo v exponenciálním formátu (např. `1.5e10`).
    -  Podporována jsou i hexa čísla (např. `0x1A3F`).
    -  Čísla mohou obsahovat podtržítka pro lepší čitelnost (např. `1_000_000`).
    -  Řetězce mohou být uzavřeny v jednoduchých (`'...'`) nebo dvojitých (`"..."`) uvozovkách a mohou obsahovat unikódové znaky (např. `\u 0600`, nebo `\u{1F600}` pro jiný hexa číslic než 4) a speciální znaky (např. `\n`, `\t`, `\\`, `\'`, `\"`).
  - Operátory a oddělovače (např. `+`, `-`, `*`, `/`) zadané v poli `operators`. Jsou možné i vícemístné operátory (např. `==`, `!=`, `<=`, `>=`, `++`, `--`, `&&`, `||`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<`, `>>`, `>>>`).
  - Komentáře (pouze jednořádkové uvozené znakem `#`). Komentář může být i na konci řádku za kódem.

- U každého tokenu je zaznamenána jeho pozice ve vstupním souboru (řádek a sloupec), což usnadňuje ladění a zpracování chyb. Dále obsahuje puvodní text tokenu, jeho typ (např. klíčové slovo, identifikátor, číslo, řetězec, operátor, oddělovač, komentář) a hodnotu (např. číslo jako `num`, řetězec bez uvozovek, atd).

- Vrací tokeny v seznamu po řádcích (třída `TsLine`), kde každý řádek je seznamem tokenů na daném řádku.
- 
- Vyjímkou jsou řádky které které mají jako první znak + (úplně první znak, řádky začínající bílým znakem do toho pravidla nepatří). Tyto řádky jsou vráceny spolu s předchozím řádkem jeko jeden řádek (takto je možno spojit i více řádků). U vracených tokenů, ale musí být zachován původní řádek a sloupec.

- Tokenizer sám ošetřuje chyby, jako jsou neuzavřené řetězce nebo neplatné znaky, a generuje odpovídající chybové zprávy. Ale neobsahuje další logiku syntaxe nebo sémantiky. Tyto úkoly jsou obvykle řešeny v dalších fázích zpracování jazyka, jako je parser nebo sémantický analyzátor.
  