# Popis jazyka TScript

- TScript je jednoduchý skriptovací jazyk, který se zaměřuje na snadnou čitelnost a jednoduchost. Jazyk podporuje základní datové typy, jako jsou čísla, řetězce a boolean, a umožňuje provádět základní aritmetické a logické operace.
- Syntaxe je basicovského typu.
- Skript má hlavní úroveň
  - Na hlavní úrovni jsou definované globální proměnné,funkce a program který se provede po spuštění skriptu.
  - Proměnné i funkce musí být definovány před prvním použitím.
  - Program hlavní úrovně může být kdekoli (i mezi definicí proměnných a funkcí).
 
 ## Deklarace proměnných
 
 - Každá proměnná musí být deklarována před prvním použitím.
 - Je možné deklarovat následující skalární proměnné
   - num - Typ číslo. Odpovídá double, umožňuje aritetické i logické operace (podobně jako čísla v javascriptu). Do proměnné num je možno vnožit i bool výsledek porovnání (true 1, false 0).
   - str - Textový řetězec. Podporuje základní operace.
   - objekt - Vestavěné objekty i objekty definované pomocí TScriptu.
- Je možné definovat následující kolekce
   - Pole - seznam libovolných skalárních proměnných. Pole jsou vždy pouze jednorozměrná.
   - Slovník - Klíčem vždy řetězec, hodnota libovolná skalánní proměnná.
 - Definice proměnné
   - num -  `num variable1` 
   - str - `str variable2`
   - objekt - `myObject variable3`
   - pole num - `num[] variable4`
   - pole str - `str[] variable5`
   - pole objektů - `myObject[] variable6`
   - slovník num - `num{} variable7`
   - slovník str - `str{} variable8`
   - slovník objektů - `myObject{} variable9`
  - Při deklaraci je možné proměnné přiřadit počáteční hodnotu pomocí operátoru `=`
    - Příklad: `num variable1 = 10`
    - Příklad: `str variable2 = "Ahoj světe"`
    - Příklad: `num[] variable3 = [1, 2, 3, 4, 5]`
    - Příklad: `str{} variable4 = {"klic1": "hodnota1", "klic2": "hodnota2"}`
 - Výchozí hodnota při deklaraci bez inicializace
   - num - 0
   - str - prázdný řetězec ""
   - pole - prázdné pole
   - slovník - prázdný slovník  
  - Je možné deklarovat i více proměnných najednou, oddělených čárkou. Ale pouze stejného typu a bez inicializace.
    - Příklad: `str var1,var2,var3`
    - Příklad: `num var1,var2,var3`
   
## Přiřazení hodnoty proměnné

- Hodnotu je možné přiřadit pomocí operátoru `=`
  - Příklad: `variable1 = 20`
  - Příklad: `variable2 = "Nový text"`
  - Příklad: `variable3[1] = 2`
  - Příklad: `variable4["klic3"] = "hodnota3"`

## Indexování polí a slovníků

- Pole jsou indexována od nuly.
- Přístup k prvkům pole se provádí pomocí hranatých závorek `[]` s indexem uvnitř.
  - Příklad: `variable3[0]` přistupuje k prvnímu prvku pole.
- Slovníky používají řetězce jako klíče.
- Přístup k hodnotám ve slovníku se provádí pomocí hranatých závorek `[]` s klíčem uvnitř.
  - Příklad: `variable4["klic1"]` přistupuje k hodnotě spojené s klíčem "klic1".
- V rámci indexování je možné použít i výrazy, které vrací číslo (pro pole) nebo řetězec (pro slovníky).
  - Příklad: `variable3[variable1]` kde `variable1` je číslo určující index pole.
  - Příklad: `variable4["klic" + str(variable1)]` kde `variable1` je číslo, které se převede na řetězec a použije jako součást klíče.

## Výrazy

- TScript podporuje základní aritmetické operace pro čísla: sčítání (`+`), odčítání (`-`), násobení (`*`), dělení (`/`), modulo (`%`).
- Podporuje také logické operace: AND (`&&`), OR (`||`), NOT (`!`).
- Podporuje relační operátory pro porovnání čísel a řetězců: rovnost (`==`), nerovnost (`!=`), větší než (`>`), menší než (`<`), větší nebo rovno (`>=`), menší nebo rovno (`<=`).
- Výrazy mohou být kombinovány a mohou obsahovat závorky pro určení precedence.
- Příklad výrazu: `result = (variable1 + 10) * 2 - variable2 / 5`
- Příklad logického výrazu: `isValid = (variable1 > 10) && (variable2 != "test")`

## Bloky kódu
- Bloky kódu začínají slovem `do` a končí slovem `end`, případně `end do`.
- Proměnné definované uvnitř bloku kódu jsou lokální pro tento blok. 
- Objekty, řetezce, pole a slovníky existují pouze v bloku a na konci zpráce s blokem jsou uvolněny z paměti.

## Komentáře

- Podporuje pouze jedřádkové komentáře začínající křížkem `#`.
  - Příklad: `# Toto je komentář`

