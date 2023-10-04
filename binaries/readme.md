I was not able to build a working dll for windows with the instructions found on https://github.com/openvenues/libpostal, the downloadable dll from pypostalwin has a fixed folder structur and expext the datafolder installed under C:\Workbench.

Anyway, after a bit searching and a night of trying, i did the following

i installed msys2
i opened a command prompt msys2 mingw64 

pacman -S autoconf automake curl git make libtool gcc mingw-w64-x86_64-gcc
git clone https://github.com/openvenues/libpostal
cd libpostal
cp -rf windows/* ./
./bootstrap.sh
./configure --datadir=/c
make -j4
make install

after that, you will find a libpostal-1.dll under 
  /msys64/home/user/libpostal/src/.libs

notes :
this method needs the data where you entered the data path during build process.
In this example it has to be c:\libpostal

#./configure --datadir=/c
/c results in c: the build files automatically adds libpostal to it,
so the resulting data path is c:\libpostal


