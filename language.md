# Popis jazyka TScript

- TScript je jednoduchý skriptovací jazyk, který se zaměřuje na snadnou čitelnost a jednoduchost. Jazyk podporuje základní datové typy, jako jsou čísla, řetězce a boolean, a umožňuje provádět základní aritmetické a logické operace.
- Syntaxe je basicovského typu.
- Skript má hlavní úroveň
  - Na hlavní úrovni jsou definované globální proměnné, funkce a program který se provede po spuštění skriptu.
  - Proměnné i funkce musí být definovány před prvním použitím.
  - Program hlavní úrovně může být kdekoli (i mezi definicí proměnných a funkcí).

## Deklarace proměnných

- Každá proměnná musí být deklarována před prvním použitím.
- Je možné deklarovat následující skalární proměnné:
  - **NUM** - Typ číslo. Odpovídá double, umožňuje aritmetické i logické operace (podobně jako čísla v JavaScriptu). Do proměnné NUM je možno vložit i bool výsledek porovnání (TRUE = 1, FALSE = 0).
  - **INT** - Typ celé číslo. Odpovídá minimálně 32-bitovému celému číslu. Podporuje aritmetické a logické operace. Do proměnné INT je možno vložit i bool výsledek porovnání (TRUE = 1, FALSE = 0). Při přiřazení z INT na NUM dojde k automatické konverzi. Obrácená konverze (z NUM na INT) musí být provedena explicitně.
  - **STR** - Textový řetězec. Podporuje základní operace.
  - **objekt** - Vestavěné objekty i objekty definované pomocí TScriptu.
- Je možné definovat následující kolekce:
  - **Pole** - seznam libovolných skalárních proměnných. Pole jsou vždy pouze jednorozměrná.
  - **Slovník** - Klíčem vždy řetězec, hodnota libovolná skalární proměnná.
- Deklarace proměnné:
  - NUM - `NUM variable1`
  - STR - `STR variable2`
  - objekt - `myObject variable3`
  - pole NUM - `NUM[] variable4`
  - pole STR - `STR[] variable5`
  - pole objektů - `myObject[] variable6`
  - slovník NUM - `NUM{} variable7`
  - slovník STR - `STR{} variable8`
  - slovník objektů - `myObject{} variable9`
- Při deklaraci je možné proměnné přiřadit počáteční hodnotu pomocí operátoru `=`:
  - Příklad: `NUM variable1 = 10`
  - Příklad: `STR variable2 = "Ahoj světe"`
  - Příklad: `NUM[] variable3 = [1, 2, 3, 4, 5]`
  - Příklad: `STR{} variable4 = {"klic1": "hodnota1", "klic2": "hodnota2"}`
- Výchozí hodnota při deklaraci bez inicializace:
  - NUM - 0
  - STR - prázdný řetězec ""
  - pole - prázdné pole
  - slovník - prázdný slovník
- Je možné deklarovat i více proměnných najednou, oddělených čárkou. Ale pouze stejného typu a bez inicializace:
  - Příklad: `STR var1,var2,var3`
  - Příklad: `NUM var1,var2,var3`

## Přiřazení hodnoty proměnné

- Hodnotu je možné přiřadit pomocí operátoru `=`:
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
  - Příklad: `variable4["klic" + STR(variable1)]` kde `variable1` je číslo, které se převede na řetězec a použije jako součást klíče.

## Výrazy

- TScript podporuje základní aritmetické operace pro čísla: sčítání (`+`), odčítání (`-`), násobení (`*`), dělení (`/`), modulo (`%`), celosčíslené dělení (`//`), umocnění (`^`);.
- Podporuje také logické operace: AND (`AND` nebo `&&`), OR (`OR` nebo `||`), NOT ( `NOT` nebo `!`), XOR (`XOR`).
- Podporuje bitové operace: AND (`BAND` nebo `&`), OR (`BOR` nebo `|`), XOR (`BXOR`), NOT (`BNOT` nebo `~`), posun vlevo (`<<`), posun vpravo (`>>`).
- Podporuje zřetězení řetězců pomocí operátoru `+`.
- Podporuje relační operátory pro porovnání čísel a řetězců: rovnost (`==`), nerovnost (`!=`), větší než (`>`), menší než (`<`), větší nebo rovno (`>=`), menší nebo rovno (`<=`).
- Výrazy mohou být kombinovány a mohou obsahovat závorky pro určení precedence.
- Příklad výrazu: `result = (variable1 + 10) * 2 - variable2 / 5`
- Příklad logického výrazu: `isValid = (variable1 > 10) && (variable2 != "test")`

## Bloky kódu

- Bloky kódu začínají slovem `DO` a končí slovem `END`, případně `END DO`.
- Bloky kódu mohou být pojmenovány pomocí štítku (label):
  - Příklad: `DO myBlock`
- Kompletní příkaz syntaxe pro blok:
  - `DO [label] ... END`
- Bloky kódu mohou být opakovaně vykonávány pomocí smyček.
  - Příklad: `DO WHILE (condition) ... LOOP`
  - Příklad: `DO UNTIL (condition) ... LOOP`
  - Příklad: `DO ... LOOP UNTIL (condition)`
  - Příklad: `DO ... LOOP WHILE (condition)`
- Kompletní příkaz syntaxe pro smyčky:
  - `DO [label] [{WHILE|UNTIL} (condition)] ... LOOP [{WHILE|UNTIL} (condition)]`
  - Podmínka je volitelná na začátku i na konci smyčky (mohou být obě, jedna nebo žádná).
  - Blok `DO ... LOOP` se opakuje bez podmínky se opakuje trvale.
- Bloky kódu mohou být vnořené.
- Proměnné definované uvnitř bloku kódu jsou lokální pro tento blok.
- Objekty, řetězce, pole a slovníky existují pouze v bloku a na konci práce s blokem jsou uvolněny z paměti.

### Bloky kódu s podmínkou

- Podmíněné bloky kódu začínají slovem `IF` a končí slovem `END` nebo `END IF`.
- Podmíněné bloky kódu mohou obsahovat volitelné větve `ELSE IF` a `ELSE`.
- Kompletní příkaz syntaxe pro podmíněný blok kódu:
  - `IF (condition) ... [ELSE IF (condition) ...] [ELSE ...] END [IF]`.
- Jako podmínka se používá výraz může být výraz obsahující porovnávací a logické operátory.
- Proměnné definované uvnitř bloku kódu jsou lokální pro tento blok.
- Objekty, řetězce, pole a slovníky existují pouze v bloku a na konci práce s blokem jsou uvolněny z paměti.

## Blok iterací

- Prvním typem iterací je prosté počítadlo.
  - Proměnná iterátoru je automaticky vytvořena a inicializována na počáteční hodnotu.
  - Pokud proměnná iterátoru již existuje, její hodnota je přepsána počáteční hodnotou.
  - Implicitně se používá proměnná typu INT.
    - Příklad: `FOR i = 1 TO 10 STEP 2 ... NEXT`
  - Proměnnou iterátoru je možné deklarovat jako NUM.
    - Příklad: `FOR NUM x = 1.3 TO 10 STEP 3.14 ... NEXT`
- Dalším typem iterací je cyklus, který se používá pro iteraci přes prvky pole nebo klíče slovníku.
  - Příklad: `FOR item IN array ... NEXT`
  - Příklad: `FOR key IN dictionary ... NEXT`
  - Proměnná iterátoru je automaticky vytvořena a inicializována na první prvek pole nebo první klíč slovníku.
  - Typ proměnné iterátoru je odvozen od typu prvků pole nebo hodnot ve slovníku.
  - Pokud proměnná iterátoru již existuje, její hodnota je přepsána prvním prvkem pole nebo prvním klíčem slovníku.
- Kompletní příkaz syntaxe pro blok iterací:
  - `FOR [type] variable = start TO end [STEP step] ... NEXT`
  - `FOR variable IN array ... NEXT`
  - `FOR variable IN dictionary ... NEXT`
- Proměnné definované uvnitř bloku iterací jsou lokální pro tento blok.
- Objekty, řetězce, pole a slovníky existují pouze v bloku iterace a při každé iteraci jsou znovu vytvořeny.

## Blok výběru

- Bloky výběru začínají slovem `SELECT` a končí slovem `END` nebo `END SELECT`.
- Bloky výběru obsahují jednu nebo více větví `CASE` a volitelnou větev `DEFAULT`.
- CASE může obsahovat jeden nebo více hodnot oddělených čárkou.
- Podmínkou CASE může být hodnota:
  - Příklad číslo: `CASE 1, 2, 3`
  - Příklad řetězec: `CASE "A", "B", "C"`
- Podmínkou CASE může být rozsah hodnot pomocí operátoru `TO` (pouze pro čísla):
  - Příklad číslo: `CASE 1 TO 10`
- Podmínkou CASE může být i porovnání pomocí relačních operátorů:
  - Příklad číslo: `CASE > 100`
  - Příklad číslo: `CASE <= 50`
- Pokud hodnota výrazu odpovídá některé z hodnot v CASE, vykoná se odpovídající blok kódu.
- Pokud žádná hodnota neodpovídá a je přítomna větev DEFAULT, vykoná se blok kódu v DEFAULT.
- Kód vybraný klauzulí CASE nebo DEFAULT končí na dalším CASE, DEFAULT nebo na END.
- Kompletní příkaz syntaxe pro blok výběru:
  - `SELECT variable ... [CASE expr1 ...] [CASE expr2 ...] ... [DEFAULT ...] END [SELECT]`.
- Proměnné definované uvnitř bloku výběru jsou lokální pro tento blok.
- Objekty, řetězce, pole a slovníky existují pouze v bloku a na konci práce s blokem jsou uvolněny z paměti.

## Výraz výběru

- TScript podporuje výraz výběru pomocí klíčového slova `SWITCH`.
- Výraz výběru začíná slovem `SWITCH` a končí slovem `END` nebo `END SWITCH`.
- Varianta výrazu výběru používá klíčová slova `BY` pro určení proměnné nebo výrazu, který se porovnává s hodnotami v jednotlivých větvích.
- Každá větev začíná podmínkou následovanou operátorem `=>` a blokem kódu, který se vykoná, pokud podmínka platí.
- Každá podmínka může být:
  - Jedna nebo více hodnot oddělených čárkou.
    - Příklad číslo: `1, 2, 3 => ...`
    - Příklad řetězec: `"A", "B", "C" => ...`
  - Rozsah hodnot pomocí operátoru `TO` (pouze pro čísla).
    - Příklad číslo: `1 TO 10 => ...`
  - Porovnání pomocí relačních operátorů.
    - Příklad číslo: `> 100 => ...`
    - Příklad číslo: `<= 50 => ...`
  - Každá podmínk a odpovídající hodnota je v jednom řádku.
- Pokud hodnota výrazu odpovídá některé z hodnot v podmínkách, vykoná se odpovídající blok kódu za oddělovacím operátorem `=>`.
- Příklad použití:

  ``` TScript
    SWITCH dest BY source
      -1,-2=> "Záporné číslo"
      0=> "Nula"
      1=> "Jedna" 
      2=> "Dva"
      3 TO 5=> "Tři až pět"
      >5=> "Víc než pět" 
      DEFAULT=> "Jiné" 
    END SWITCH
  ```

## Funkce

- Funkce jsou definovány pomocí klíčového slova `FUNC` a končí slovem  `END FUNC`, nebo`END`.
- Funkce mohou mít volitelné parametry, které jsou definovány za názvem funkce.
- Blok parametrů může být uzavřen v kulatých závorkách `()` (nepovinné), parametry jsou odděleny čárkou.
  - Příklad: `FUNC INT myFunction(param1, param2) ... END FUNC`
  - Případně bez závorek: `FUNC NUM myFunction param1, param2 ... END FUNC`
- Parametry mohou být jakéhokoli podporovaného typu (NUM, INT, STR, objekt, pole, slovník).
  - Příklad: `FUNC INT calculateSum(NUM a, NUM b) ... END FUNC`
  - Příklad: `FUNC STR processData(STR name, myObject data) ... END FUNC`
- Pokud za funkcí není uveden typ vracené hodnoty, funkce nevrací žádnou hodnotu.
  - Příklad: `FUNC myProcedure(NUM param1, STR param2) ... END FUNC`
- Parametry jsou předávány hodnotou (call by value).
- Objekty jsou předávány odkazem (call by reference).
- Textové řetězce, pole a slovníky jsou předávány odkazem (call by reference).
- Funkce mohou vracet hodnotu pomocí klíčového slova `RETURN`.
  - Příklad: `RETURN result`
  - Příklad pokud funkce nevrací hodnotu: `RETURN`
- Typ vracené hodnoty se zapisuje za `FUNC`
  - Příklad: `FUNC NUM getValue() ... END FUNC`
  - Příklad: `FUNC STR getText() ... END FUNC`
- Kompletní příkaz syntaxe pro definici funkce:
  - `FUNC [type] functionName([param1, param2, ...]) ... END FUNC`
- Vracená hodnota může být použita v dalších výrazech.
  - Příklad: `result = myFunction(10, 20) + 5`
- Vracená hodnota může být ignorována, pokud není potřeba.
  - Příklad: `myFunction(10, 20)`
- Pokud za voláním funkce nenásleduje výraz nemusí být parametry v kulatých závorkách.
  - Příklad: `myFunction param1, param2`
  - Příklad: `result = myFunction param1, param2`
- Proměnné definované uvnitř funkce jsou lokální pro tuto funkci.

## Moduly

- TScript podporuje moduly pro organizaci kódu do samostatných souborů.
- Každý soubor je modulem a může obsahovat definice proměnných a funkcí.
- Modul začíná klíčovým slovem `MODULE` za může následovat název modulu.
  - Bez názvu je má modul název podle názvu souboru.
  - Příklad: `MODULE moduleName`
- Klíčové slovo `MODULE` není povinné, pokud je název modulu shodný s názvem souboru.
- Moduly mohou být importovány do jiných modulů pomocí klíčového slova `IMPORT`.
  - Příklad: `IMPORT "moduleName"`
- Po importu modulu jsou všechny jeho veřejné funkce a proměnné dostupné v importujícím modulu.
  - Příklad použití funkce z importovaného modulu: `result = moduleName.functionName(param1, param2)`
- Za běhu programu existuje pouze jedna instance každého modulu (je singleton).

## Třídy

- Třídy jsou speciální typy modulů.
- Třídy jsou moduly které mají v záhlaví klíčové slovo `CLASS` místo `MODULE`.
- Narozdíl od modulu který je singleton, třída může mít více instancí.
- Instance třídy se vytváří při deklaraci proměnné.
  - Příklad: `myObject obj`

## Konstruktory modulů a tříd

- Moduly a třídy neobsahují konstruktory. Konstrukci provádí program na hlavní úrovni modulu, nebo třídy.

## Destruktory modulů a tříd

- Moduly a třídy mohou obsahovat destruktory pro uvolnění prostředků při ukončení programu nebo zničení instance třídy.
- Destruktor je definován jako funkce s názvem `DESTROY` bez parametrů a bez návratového typu.
  - Příklad:

    ``` TScript
    FUNC DESTROY
      # Kód pro uvolnění prostředků
    END FUNC
    ```

## Vyjímky

- TScript podporuje zpracování výjimek pomocí klíčových slov `TRY`, `CATCH` a `FINALLY`.
- Blok `TRY` obsahuje kód, který může vyvolat výjimku.
- Blok `CATCH` obsahuje kód pro zpracování výjimky, pokud je vyvolána v bloku `TRY`.
  - Může obsahovat volitelný parametr, který představuje kód výjimky.
    Příklad: `CATCH system.notOpen`
  - Blok `CATCH` může zachytit všechny výjimky, pokud není uveden žádný parametr.
    - Příklad: `CATCH`
  - Bloků `CATCH` mohou být více pro zachycení různých typů výjimek a jeden blok může obsahovat více typů výjimek oddělených čárkou.
    - Příklad: `CATCH system.notOpen, system.ioError`
- Blok `FINALLY` obsahuje kód, který se vždy vykoná po bloku `TRY`, bez ohledu na to, zda byla vyvolána výjimka nebo ne.
- Kompletní příkaz syntaxe pro zpracování výjimek:
  - `TRY ... CATCH ... [FINALLY ...] END TRY`
- Výjimka je vyvolána pomocí klíčového slova `THROW` následovaného kódem výjimky.
  - Příklad: `THROW system.ioError`
- Výjimka je v systému reprezentována jako jedinečný kód typu INT.
- Vyjímky je možno deklarovat v modulu nebo třídě pomocí klíčového slova `EXCEPTION`.
  - Příklad: `EXCEPTION myException`
    - Kód výjimky je automaticky přiřazen.
  - Příklad s explicitním kódem: `EXCEPTION myException = 100`
    - Takto deklarovaná výjimka se může vyskytnout pouze v definice vestavěného objektu. Běžné objekty jazyka TScript neumožňují definici vlastních kódů výjimek.
- Ostatní informace o výjimce (např. pozice nebo textový popis) se uchovávají v systému a předpokládá se, že hostitelská aplikace je zpřístupní jazyku TScript pomocí vestavěného objektu. Předpokládá se jednoduchý objekt, který uchovává informace pouze o poslední výjimce.

## Komentáře

- Podporuje pouze jednořádkové komentáře začínající křížkem `#`:
  - Příklad: `# Toto je komentář`

## Vestavěné objekty

- Vestavěné objekty jsou v jazyce TScript vždy definovány cílovým prostředím (hostitelská aplikace).
- TScript proto nedefinuje žádné vestavěné objekty sám o sobě.
- V TScriptu existuje podpora pro definici vestavěných objektů.
- Vestavěné objekty mohou mít vlastnosti a metody, které jsou přístupné pomocí tečkové notace.
  - Definice vestavěného začíná klíčovým slovem `INTERNAL MODULE` nebo `INTERNAL CLASS`.
  - V těle objektu jsou definovány funkce a vlastnosti.
  - Funkce jsou definovány stejně jako běžné funkce, ale bez těla funkce (pouze hlavička).
  - Vlastnosti jsou definovány jako proměnné bez inicializace.
    - Příklad vlastnosti: `NUM propertyName`
  - Vlastnosti mohou být přístupné pro čtení i zápis, nebo pouze pro čtení pomocí klíčového slova `READONLY`.
    - Příklad readonly vlastnosti: `READONLY STR propertyName`
  - Definice vestavěného objektu slouží pouze pro kompilaci skriptu, skutečná implementace je poskytována hostitelskou aplikací.

    Slouží také pro generování interface v jazyce hostitelské aplikace.

