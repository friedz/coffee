
======
coffee
======

----------------------------------------------------
Was du über das caffee listen skript wissen solltest
----------------------------------------------------

:Author: Friedrich Schwedler <friedrich@mathphys.stura.uni-heidelberg.de>
:Date: Julie 2017
:Copyright: Beerware License
:Version: 1.1
:Manual section: 7
:Manual group: MathPhys HowTo's

Übersicht
=========

coffee [ -h | -0 | -f `DATEI` | -e `EDITOR` | `DATEI` ]

Options
=======

--file=DATEI, -f             benutze `DATEI` für die Liste
--empty, -0                  generiere eine leere Liste
--editor=EDITOR, -e EDITOR   benutze `EDITOR` um die Liste zu schreiben
--help, -h                   Zeige eine eine kurze Erklärung der Optionen

Datei Format
============
In jeder Zeile Steht ein Name, die Anzahl an Kreuzen und ob schon bezahlt wurde, dabei müssen LaTeX Zeichen escaped werden (also `\\&` statt `&` usw)

  .. code-block::

     Name
     Name,[Anzahl]
     Name,[Anzahl],[Bezahlt]
     Name,,[Bezahlt]

Wenn nur ein `Name` geschrieben wird legt das Skript eine leere Zeile mit dem `Namen` an.

Wenn noch eine `Anzahl` angegeben ist wird die Zeile mit entsprechend vielen Kreutzen gefüllt (zahlen >= 25 werden wie 25 behandelt).

Wird `Bezahlt` auf einen Wert für `ja` gesetzt wird die Zeile entfernt wenn sie eine `Anzahl` >= 25 hat und wenn es weniger sind wird die Zeile in der Kommandozeilen Ausgabe `grün` markiert und muss in der Ausgedruckten Liste `per Hand durchgestrichen` werden.

0 <= Anzahl <= 25
    Zahlen die größer als 25 sind werden wie 25 behandelt, es lassen sich also nicht mehrere Zeilen in einen Eintrag zusammen fassen

Bezahlt = `ja|nein`
    Es ist auch möglich in vielen Anderen Sprachen `ja` zu schreiben alle nicht bekanten Wörter werden als `nein` interpretiert, insbesondere auch wenn nichts geschrieben ist.

    Mögliche Varianten für `ja`: [ `jo`, `jopp`, `ja`, `true`, `1`, `yes`, `si`, `да`, `oui`, `sim`, `ken`, `sea`, `jes`, `はい`, `ndiyo`, `gee`, `haa'n`, `oo`, `是`, `baleh`, `areh`, `na'am`, `a-yo`, `evet` ] die groß und klein Schreibung ist egal.
