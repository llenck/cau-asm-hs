Implementiert eine Pseudo-Machinensprache, die an der CAU als beispiel für machinensprache gelehrt wird.

In example.asm ist ein Beispielprogramm, welches das ergebnis eines logischen oders von Speicherzelle 100 und 101 in 102 schreibt. Dies lässt sich ausführen mit `runhaskell main.hs example.asm`.  
Wenn dem Programm Input gegeben soll (was hier sinnvoll ist, da alle Speicherzellen standardmäßig auf 0 gesetzt werden), kann man dem Programm als weiteres Argument eine Liste aus Key-Value Pairs von Zelle zu Wert gegeben werden, z.B:  
```
$ runhaskell main.hs example.asm "[(100, 0), (101, 1)]"
Parsed instructions: [TST 100,JMP 4,TST 101,INC 102,HLT]

Executing: 
1: TST 100
3: TST 101
4: INC 102
5: HLT

Result:
[(100,0),(101,1),(102,1)]
```
