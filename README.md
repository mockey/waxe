Waxe
====

Waxe is a Haxe language binding for the wxWidgets cross-platform GUI toolkit. It can be used for the Neko and C++ targets of Haxe.

All code is based on the official repo at:
http://code.google.com/p/waxe/,
the work of Hugh Sanderson (http://gamehaxe.com/)

I just added some missing pieces and hope I will continue to do so as time allows.
For a list of additions see the [Wiki page](https://github.com/mockey/waxe/wiki/Additions).

	
Additions:
	
2012-11-23, cambiata:
	
* added working buildscript for windows (src/Windows-Build.xml) and bat file (build-windows-ndll.bat) to simplify compilation of ndll/Windows/waxe.ndll
* added MessageDialog
* added onTextUpdate handler to TextCtrl
* added set() method to ListBox - thanks to misterpah