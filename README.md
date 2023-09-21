## Postalman

Postalman for Delphi is an address parser based on [libpostal](https://github.com/openvenues/libpostal) and integrating [libpostal](https://github.com/openvenues/libpostal). Of course, the translation of the headers is also included, so you don’t necessarily have to use PostalMan if you only want to use [libpostal](https://github.com/openvenues/libpostal).

In addition to [libpostal](https://github.com/openvenues/libpostal), PostalMan also integrates the possibility of using validators. This is not only a way to validate addresses but also to enrich addresses with additional information. For example, using the data from Nomanitim to provide addresses with longitude and latitude.

In the course of time I will integrate further possibilities, for example gender determination based on first names, presumed age, correctness of spelling of streets and places. I have already found a large part in old 
sources, but my style at that time does not quite fit modern times.

Besides, free data, at least for Germany, is not really well available and I am not allowed to use my old data for licensing reasons.

Using Postalman is very simple. The source code is relatively well documented and the test application shows the usage and possible options quite well.

For Windows (64 Bit only), you must either build [libpostal](https://github.com/openvenues/libpostal) yourself, following the instructions you find at libpostal, or use the prepared binaries (1.5 GB) from  [pypostalwin](https://github.com/selva221724/pypostalwin). You can also find the link there. As an alternative you can download the relase and use the libpostal binaries from there.

Postalman expects libpostal to be installed in the C:\Workbench directory, but you can change the installation of the DLL and the data at any time.

The Release für Windows 64 includes the libpostmal binaries also. Just copy it to any directory and extract the files. 



---

Postalman für Delphi ist ein Adressparser der auf [libpostal](https://github.com/openvenues/libpostal) basiert bzw. [libpostal](https://github.com/openvenues/libpostal) integriert. Natürlich ist auch die Übersetzung der Header dabei, so dass Sie nicht unbedingt PostalMan verwenden müssen wenn Sie nur [libpostal](https://github.com/openvenues/libpostal) verwenden wollen.

PostalMan integriert neben [libpostal](https://github.com/openvenues/libpostal) noch die Möglichkeit Validatoren einzusetzen. Damit besteht nicht nur ein Weg Adressen zu validieren sondern auch Adressen mit weiteren Informationen anzureichern. Beispielsweise mit den Daten von Nomanitim Adressen mit Längengrad und Breitengrad zu versehen.

Im Laufe der Zeit werde ich noch weitere Möglichkeiten integrieren,  die Geschlechterbestimmung auf Basis der Vornamen das vermutete Alter, die Korrektheit der Schreibweise von Strassen und Orten. Einen Großteil habe ich schon in alten 
Quellen, aber mein damaliger Stil passt nicht ganz zu den modernen Zeiten.

Außerdem sind freie Daten, zumindest für Deutschland, nicht wirklich gut verfügbar und meine alten Daten darf ich aus lizenzrechtlichen Gründen nicht verwenden.

Die Verwendung von Postalman ist denkbar einfach. Der Quelltext ist relativ gut dokumentiert und die Testanwendung zeigt die Verwendung und die möglichen Optionen recht gut.

Für Windows (nur 64 Bit) müssen Sie [libpostal](https://github.com/openvenues/libpostal) entweder selbst bauen, folgen Sie hierzu den Anweisungen die sie bei libpostal finden, oder sie benutzen die vorbereiteten Binaries (1,5 GB) von [pypostalwin](https://github.com/selva221724/pypostalwin). Den Link hierzu finden Sie ebenfalls dort. Postalman erwartet die Installation von libpostal im Verzeichnis C:\Workbench, sie können die Installation der DLL und der Daten aber jederzeit ändern. Alternativ können Sie das jeweils aktuelle Release herunterladen und in ein beliebiges Verzeichnis entpacken, und die Testanwendung von dort ausführen.

Das Release beinhaltet die Binaries für libpostal

