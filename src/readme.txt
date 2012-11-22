Getting started on mac ...

Download + extract wxWidgets 2.9.2.
Put this "next to" the waxe root, or set the WXROOT variable appropriately
Configure + build static libraries:
./configure --disable-shared --disable-svg with_libtiff=no with_regex=no with_expat=no --enable-stc --disable-debug_flag  --with-opengl CXXFLAGS=-fvisibility=hidden OBJCXXFLAGS=-fvisibility=hidden OBJCFLAGS=-fvisibility=hidden
make

I copied the resulting setup to the waxe svn:
cp lib/wx/include/osx_carbon-unicode-static-2.9/wx/setup.h ../waxe/src/include/mac_setup.h


Linux - cross compile for 32 Bits:

./configure  --disable-shared --with-opengl CC="cc -m32" CXX="g++ -m32" --build=i486-pc-linux-gnu --with-gtk with_libtiff=no with_expat=no with_regex=no --without-gtkprint


Lunux 64:

./configure -q --disable-shared --with-opengl CC="cc -fpic -fPIC" CXX="g++ -fpic -fPIC" --with-gtk with_libtiff=no with_expat=no with_regex=no --without-gtkprint

./configure --disable-shared --with-opengl CFLAGS="-fpic -fPIC" CXXFLAGS="-fpic -fPIC" --with-gtk --with-libtiff=no --with-regex=no --without-gtkprint --enable-webview

make

copy setup file from lib file


Building on Windows:
Download wxWidgets 2.9.2 and extract next to the waxe directory
 edit Config.vc:
     BUILD = release
	  MONOLITHIC = 0
	  USE_OPENGL = 1
	  RUNTIME_LIBS = static

nmake -f makefile.vc

cp lib/vc_lib/mswu/wx/setup.h src/include/windows_setup.h



