## Postalman

Postalman für Delphi ist ein Adressparser der auf [libpostal](https://github.com/openvenues/libpostal) basiert bzw. [libpostal](https://github.com/openvenues/libpostal) integriert. Natürlich ist auch die Übersetzung der Header dabei, so dass Sie nicht unbedingt PostalMan verwenden müssen wenn Sie nur [libpostal](https://github.com/openvenues/libpostal) verwenden wollen.

PostalMan integriert neben [libpostal](https://github.com/openvenues/libpostal) noch die Möglichkeit Validatoren einzusetzen. Damit besteht nicht nur ein Weg Adressen zu validieren sondern auch Adressen mit weiteren Informationen anzureichern. Beispielsweise mit den Daten von Nomanitim Adressen mit Längengrad und Breitengrad zu versehen.

Im Laufe der Zeit werde ich noch weitere Möglichkeiten integrieren,  die Geschlechterbestimmung auf Basis der Vornamen das vermutete Alter, die Korrektheit der Schreibweise von Strassen und Orten. Einen Großteil habe ich schon in alten 
Quellen, aber mein damaliger Stil passt nicht ganz zu den modernen Zeiten.

Außerdem sind freie Daten, zumindest für Deutschland, nicht wirklich gut verfügbar und meine alten Daten darf ich aus lizenzrechtlichen Gründen nicht verwenden.

Die Verwendung von Postalman ist denkbar einfach. Der Quelltext ist relativ gut dokumentiert und die Testanwendung zeigt die Verwendung und die möglichen Optionen recht gut.

Für Windows (nur 64 Bit) müssen Sie [1] [libpostal](https://github.com/openvenues/libpostal) entweder selbst bauen, folgen Sie hierzu den Anweisungen die sie bei libpostal finden, oder sie benutzen die vorbereiteten Binaries (1,5 GB) [2] von [pypostalwin](https://github.com/selva221724/pypostalwin). Den Link hierzu finden Sie ebenfalls dort. Alternativ hierzu können Sie 

auch die dll im Verzeichnis binaries verwenden, welche aktueller ist. [3]

Ja nach verwendeter DLL erwartet Postalman die für libpostal notwendigen Daten entweder unter dem Vezeichnis c:\libpostal\data [1], c:\workbench\libpostal [2] oder unter c:\libpostal

Um den Datenpfad zu ändern muss dieser bereits beim Erzeugen der DLL angegeben werden. Wenn Sie die DLL selbst erstellen achten Sie darauf das die Beschreibung unter [1] Abhängigkeiten erzeugt (von msys2), meine Beschreibung die ich unter binaries/readme.md gepostet habe benötigt zwar zur Erstellung auch ein installiertes msys2, ist aber ansonsten frei von Abhängigkeiten. 

Der Pfad den Sie dort als Datenpfad angeben muss auch im Programm als Datenpfad verwendet werden.

---

Postalman for Delphi is an address parser based on [libpostal](https://github.com/openvenues/libpostal) and integrating [libpostal](https://github.com/openvenues/libpostal). Of course, the translation of the headers is also included, so you don’t necessarily have to use PostalMan if you only want to use [libpostal](https://github.com/openvenues/libpostal).

In addition to [libpostal](https://github.com/openvenues/libpostal), PostalMan also integrates the possibility of using validators. This is not only a way to validate addresses but also to enrich addresses with additional information. For example, using the data from Nomanitim to provide addresses with longitude and latitude.

In the course of time I will integrate further possibilities, for example gender determination based on first names, presumed age, correctness of spelling of streets and places. I have already found a large part in old 
sources, but my style at that time does not quite fit modern times.

Besides, free data, at least for Germany, is not really well available and I am not allowed to use my old data for licensing reasons.

Using Postalman is very simple. The source code is relatively well documented and the test application shows the usage and possible options quite well.

For Windows (64 Bit only), you must either build [libpostal](https://github.com/openvenues/libpostal) yourself, following the instructions you find at libpostal, or use the prepared binaries (1.5 GB) from  [pypostalwin](https://github.com/selva221724/pypostalwin). Alternatively you can use you can also use the dll in the binaries directory, which is more recent. [3]

Depending on the DLL used, Postalman expects the data necessary for libpostal either under the directory c:\libpostal\data [1], c:\workbench\libpostal [2] or under c:\libpostal.

To change the data path it must be specified when creating the DLL. If you create the DLL yourself make sure that the description under [1] creates dependencies (from msys2), my description which I posted under binaries/readme.md needs an installed msys2 for the creation, but is otherwise free of dependencies. 

The path you specify there as data path must also be used in the program as data path.
