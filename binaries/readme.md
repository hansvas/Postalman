Es war mir nicht möglich eine verwendbare DLL mit den Informationen die ich auf [libpostal] [https://github.com/openvenues/libpostal] gefunden habe zu bauen. Der Grund war, das diese Art libpostal für Windows zu bauen, neue Abhängigkeiten schafft die aber leider nicht aufgelöst werden können. 

Die Alternative pypostalwin ist schon etwas älter und setzt eine Installation des Datenverzeichnisses unter c:\workbench\libpostal vorraus.

Nach einigem Suchen und einer Nacht des Ausprobierens fand ich folgende Lösung die nahe der Originalanleitung ist aber msys2 nur zum Bauen benötigt. :

Ich installierte msys2, öffnete einen msys2 mingw Prompt: 

pacman -S autoconf automake curl git make libtool gcc mingw-w64-x86_64-gcc \
git clone https://github.com/openvenues/libpostal \
cd libpostal \
cp -rf windows/* ./ \
./bootstrap.sh \
./configure --datadir=/c \
make -j4 \
make install \

Danach findet sich libpostal-1.dll im Verzeichnis /msys64/home/user/libpostal/src/.libs
Das Datenverzeichnis findet sich unter c:\libpostal, die notwendigen Daten wurden automatisch heruntergeladen.

Wenn Sie das Verzeichnis ändern wollen müssen Sie die Zeile \
./configure --datadir=/c \

anpassen. Das Laufwerk geben Sie als /c,/d usw. an. Die daran anschließenden Verzeichniss werden direkt angehängt. Beachten Sie das "libpostal" automatisch angehängt wird. Aus c/ wird dem entsprechend c:\libpostal, 
aus c/data wird c:\data\libpostal. Der Pfad unter dem die Daten gespeichert werden muss auch im Testprogramm bzw. bei Initialisierung der DLL verwendet werden, dementsprechend auch in allen eigenen Programmen verwendet werden.

Wer sich an den Build nicht herantraut oder einen anderen Pfad wünscht kann mich anschreiben, wenn ich Zeit habe kann ich ja mal ein Build durchlaufen lassen.

---

I was not able to build a usable DLL with the information I found on [libpostal] [https://github.com/openvenues/libpostal]. The reason was that this way of building libpostal for Windows creates new dependencies which unfortunately cannot be resolved. 

The alternative pypostalwin is a bit older and requires an installation of the data directory under c:\workbench\libpostal.

After some searching and a night of trial and error I found the following solution which is close to the original instructions but only requires msys2 to build. :

I installed msys2, opened a msys2 mingw prompt: 

pacman -S autoconf automake curl git make libtool gcc mingw-w64-x86_64-gcc \
git clone https://github.com/openvenues/libpostal \
cd libpostal \
cp -rf windows/* ./ \
./bootstrap.sh \
./configure --datadir=/c \
make -j4 \
make install \

After that you will find libpostal-1.dll in the directory /msys64/home/user/libpostal/src/.libs
The data directory can be found at c:\libpostal, the necessary data was downloaded automatically.

If you want to change the directory you have to change the line \
./configure --datadir=/c \

Specify the drive as /c, /d, etc. The subsequent directories are appended directly. Note that libpostal is automatically appended. Accordingly, c/ becomes c:\libpostal and c/data becomes c:\data\libpostal.

You must also use the resulting directory in the test program (and your own programs).
