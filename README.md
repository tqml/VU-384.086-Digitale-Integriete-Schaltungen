# OMN - Own Made Network

## Was ist das OMN?
Das OMN ist ein Netzwerk von Studenten, welche anderen Studenten das Studieren erleichtern. Dazu werden Skripten, Lehrinhalte, Übungen, Beispiele und Lösungen in einer aufgearbeiteten Form zur Verfügung gestellt.

## Was ist das Ziel vom OMN?
Das OMN möchte sämtliche Inhalte für jede Lehrveranstaltung digitalisieren, damit diese in einer sauberen Form als Dokument erstellt werden können. Sind diese Inhalte digital vorhanden, können Korrekturen und Erweiterungen leichter und schneller vorgenommen werden, als an bestehenden handschriftlichen Lösungen und Zusammenfassungen. Dabei soll besonders darauf acht gelegt werden, dass über alle Lehrveranstaltungen hinweg eine konsistente Definition von Variablen und Namen eingehalten wird, um das Lernen zu erleichtern. Die Lernunterlagen sollen untereinander kompatibel sein.

## Warum gibt es für jede Lehrveranstaltung ein eigenes Git Repository (Repo)?
Der Sinn hinter den Git Repos liegt darin, dass mit nur einem Befehl (git clone URL) alle freien Informationen einer Lehrveranstaltung auf deinen lokalen PC heruntergeladen werden können, und nicht mühsam aus verschiedensten Quellen zusammengesucht werden müssen.

## Wie bekomme ich neue Inhalte?
Mit dem Befehl (git pull upstream master) erhältst du alle neuen Inhalte, welches es für die betreffende Lehrveranstaltung frei zugänglich gibt. Du musst dazu nicht mehr das Forum nach neuen Inhalten durchsuchen und sie mit deinen Inhalten vergleichen.

## Wo finde ich die Lehrnunterlagen als pdf?
Die opn Lehrnunterlagen werden zu jedem Quartalsanfang kompiliert und als Release auf GitHub veröffentlicht. Die cld Lehrnunterlagen werden für dich persönlich kompiliert und an deine e-Mail adresse geschickt.

## Was ist der Unterschied zwischen dem opn (open) und cld (closed) Ordner?
Der opn (open) Ordner ist für jeden einsehbar und unterliegt der GNU GPLv3. Jeder kann hier stöbern und sich ansehen, was das OMN zur Verfügung stellt und neue Inhalte dazu beitragen. Der cld (closed) Ordner ist nur für OMN Mitglieder zugänglich, welche sich am OMN beteiligen.

## Warum gibt es einen open und einen closed Ordner?
Das OMN soll wachsen und dazu benötigt es die Unterstützung von Studenten. Um zu verhindern, dass die aufwendig erstellten Zusammenfassungen und Beispielsammlungen von Studenten nur zum eigenen Vorteil verwendet werden ohne etwas dem OMN zurück zu geben, gibt es einen closed Ordner.

## Wie werde ich Mitglied?
Das ist ganz einfach. Schau in das TODO File und suche dir eine Aufgabe aus, welche noch nicht erledigt wurde. Wenn du zwei Punkte gesammelt hast, erstelle ein Issue, indem du kurz schreibst was du gemacht hast um Zugriff auf den closed Bereich zu erhalten.

# Wie kann ich etwas beitragen?
Es gibt hier zwei Möglichkeiten.

## Direkt mittels Git und GitHub
Wenn du dich mit Git, GitHub und LaTeX auskennst, wähle bitte diesen Weg.

### Einmalige Initialisierung
Hier wird beschrieben, welche Schritte einmalig durchführen musst, um das Repo auf deinen PC zu bekommen.

1. Registriere und melde dich bei GitHub an.
1. Lade dir Git herunter.  [https://git-scm.com/download/win](https://git-scm.com/download/win)
1. Lade dir einen LaTeX Editor herunter. Empfohlen für Windows nutzer, TeXStudio [https://github.com/texstudio-org/texstudio/releases/download/2.12.14/texstudio-2.12.14-win-qt5.exe](https://github.com/texstudio-org/texstudio/releases/download/2.12.14/texstudio-2.12.14-win-qt5.exe)
1. Geh in GitHub auf die Lehrveranstaltung, zu der du etwas beitragen möchtest. Diese Git Repo heißt für jede Lehrveranstaltung UPSTREAM
1. Klick rechts oben auf das Feld "Fork" um einen Abkömmling zu erstellen. GitHub erstellt dir eine Kopie vom UPSTREAM Repo. Deine Kopie heißt jetzt ORIGIN.
1. Klick in deinem soeben erstellten Abkömmling auf das grüne Feld "Clone or Download" Symbol.
1. Das ist DEINE ORIGIN_URL, kopiere Sie.
1. Öffne deinen Explorer und erstelle einen Ordner für Uni.
1. Öffne diesen Ordner und rechtsklicke und klick auf Git Bash here.
1. Kopiere (Clone) deinen Fork auf deinen lokalen PC. Gib dazu in die Konsole folgende Befehle ohne dem $ Zeichen ein.  Die URL musst du durch deine kopierte URL ersetzen.

    ```
    $ git clone ORIGIN_URL
    $ git submodule init conf
    $ git submodule update conf
    ```
1. Git lädt das open und conf Repo auf deinen PC herunter.
1. Wir fügen jetzt in den nächsten Schritten das UPSTREAM Projekt als link hinzu, damit du neue Inhalte erhalten kannst.
1. Geh dazu in GitHub auf die UPSTREAM Lehrveranstaltung, zu der du etwas beitragen möchtest.
1. Klicke auf das grüne Feld "Clone or Download".
1. Das ist die UPSTREAM_URL, kopiere Sie.
1. Füge das UPSTREAM Repo mit folgendem Befehl hinzu.

    ```
    $ git remote add -t master upstream UPSTREAM_URL
    ```
1. Überprüfe deine remote Repos. Es sollten hier 4 Zeilen erscheinen

    ```
    $ git remote -v
    origin   ORIGIN_URL (fetch)
    origin   ORIGIN_URL (push)
    upstream UPSTREAM_URL (fetch)
    upstream UPSTREAM_URL (push)
    ```
    
### Wiederkehrend
Hier wird beschrieben, welche Schritte notwendig sind damit du etwas beitragen kannst. Füre diese Schritte jedes mal in dieser Reinfolge aus.

1. Hole dir die neuesten Inhalte vom UPSTREAM Repo.

    ```
    $ git pull upstream master
    ```
1. Führe deine Änderungen durch. z.B. (neue LaTeX Dokumente, neue Source Code, neue PDFs, usw.)
1. Führe einen test Build durch um zu sehen, ob dein code auch wirklich funktioniert.
    
    ```
    $ make test
    ```
    Im /conf/out Ordner wird ein test.pdf erstellt.
1. Schau dir deine Änderungen mit

    ```
    $ git status
    ```
    an.
    Das kann dann so aussehen:

    ```
    On branch master
    Your branch is up-to-date with 'origin/master'.
    Changes not staged for commit:
    (use "git add ..." to update what will be committed)
    (use "git checkout -- ..." to discard changes in working directory)

    modified: opn/exm/mdl/chp/3/3/relaxion.tex

    no changes added to commit (use "git add" and/or "git commit -a")
    ```
1. Füge die Datein, welche du hinzufügen möchtest mit 

    ```
    $ git add opn/exm/mdl/chp/3/3/relaxion.tex
    ```
    hinzu und schau dir mit
    
    ```
    $ git status
    ```
    an, ob git die Datei auch akzeptiert hat. Git hat die Datei akzeptiert, da sie unter dem Text "Changes to be commited" steht.

    ```
    On branch master
    Your branch is up-to-date with 'origin/master'.
    Changes to be committed:
    (use "git reset HEAD ..." to unstage)

    modified: opn/exm/mdl/chp/3/3/relaxion.tex

    Changes not staged for commit:
    (use "git add ..." to update what will be committed)
    (use "git checkout -- ..." to discard changes in working directory)
    ```
1. Schreibe einen aussagekräftigen Kommentar zu deinen Änderungen mit:

    ```
    $ git commit -m"Dein aussagekräftiger Kommentar zu deinen Änderungen"
    ```
    Die Ausgabe kann so aussehen:
    
    ```
    [master 3475954] Deine Änderungen
    1 file changed, 2 insertions(+), 2 deletions(-)
    ```
1. Push diesen commit auf deinen Fork, also ORIGIN mit:

    ```
    $ git push origin master
    ```
1. Geh auf die GitHub Seite der UPSTREAM Lehrveranstaltung und erstelle einen Pull-Request, damit deine Änderungen in das UPSTREAM Repo übernommen werden und wieder für alle zur Verfügung steht.

## Indirekt über ein Issue
Wenn du von Git und GitHub keine Ahnung hast, kannst du dennoch etwas beitragen. Du kannst alle Aufgaben erledigen, welche als text editiert werden können. Dazu muss in der TODO Liste stehen, dass diese Aufgabe auch als Issue durchgeführt werden kann. Beachte bitte, dass du für jede Aufgabe, welche du über ein Issue löst um EINEN Punkt weniger erhältst, als wenn du direkt mit Git arbeitest.

1. Erstell eine Liste an Änderungen/ Korrekturen/ Verbesserungen
1. Führe einen test Build durch um zu sehen, ob dein code auch wirklich funktioniert.
    
    ```
    $ make test
    ```
    Im /conf/out Ordner wird ein test.pdf erstellt.
1. Erstelle ein Issue und kopiere dort die Liste hinein

## Ich bin für den closed Bereich freigeschalten. Wie bekomme ich die Inhalte?

1. Geh in den Ordner in welchem sich die Lehrveranstaltung befindet für die du freigeschaltet wurdest.
1. Öffne die git konsole mit rechtsklick Git Bash here
1. führe folgende Befehle aus:

    ```
    $ git submodule init cld
    $ git submodule update cld
    ```
1. Lies das README und TODO im closed Bereich. Es unterscheidet sich von den opn Dokumenten.

## Wie kann ich die Lernunterlagen selber kompilieren?
Geh dazu in den Hauptordner des Repo und führe den nachfolgenden Befehl aus. Kompilieren geht derzeit nur auf Linux.

```
$ make all
```
    
## Muss ich bei jeder Lehrveranstaltung etwas beitragen um für den closed Bereich freigeschalten zu werden?
NEIN. Das Ziel ist, dass du bei der ersten Lehrveranstaltung eine Aufgabe im open Bereich erfüllst, und dann beliebig viele Aufgaben im closed Bereich. Je mehr Aufgaben du im closed Bereich erfüllst, desto mehr closed Inhalte bekommst du von anderen Lehrveranstaltung ohne dafür auch nur irgendetwas machen zu müssen.

## Ich bin gerade so im Stress und kann leider nichts beitragen, aber wenn ich die Prüfung bestanden habe, werde ich etwas Beitragen. Könntet Ihr mich bitte Freischalten?
NEIN, wenn es dir nicht Wert ist etwas Zeit für gute Lernunterlagen zu opfern, bist du es auch nicht Wert diese zu erhalten.

## Ich möchte gerne etwas im closed Bereich beitragen, bin aber dafür leider noch nicht freigeschaltet.
Netter Versuch. Zuerst im open Bereich, dann im closed. 

## Darf ich die Lernunterlagen mit Freunden teilen oder Veröffentlichen?
NEIN, die Lehrunterlagen sind nur für dich persönlich gedacht. Damit hilfst du uns, den Anreiz von neuen Beiträgen hoch zu halten und das hilft letztendlich allen.

## Ich hab eine Frage zu einem Rechenbeispiel, Theorie, Mündliche Frage, usw.
Erstelle für jede Frage EIN Issue. In den Titel schreibst du hinein um welches Beispiel oder Theoriefrage, usw. es sich handelt. Ist deine Frage beantwortet, wird dein Issue geschlossen und die Lösung deiner Frage wird in das Repo eingepflegt. Hast du eine Frage zu einem Beispiel, dass bereits beantwortet ist/gelöst ist, kannst du das Issue wieder öffnen. Mit dieser Vorgehensweise wollen wir elend lange Threads vermeiden, wo komplett chaotisch über mehrere Posts hinweg verschiedenste Probleme/Fragen behandelt werden und auch ein nachträgliches Lesen sehr aufwendig ist.
