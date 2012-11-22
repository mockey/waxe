package wx;

import wx.Window;

@:wx("scrolled_window")
class ScrolledWindow extends Panel, implements MacroCffi {
	
	public static function create(inParent:Window, ?inID:Null<Int>, ?inPosition:Position,
	?inSize:Size, ?inStyle:Int) {
		if (inParent==null)
			throw Error.INVALID_PARENT;
		var handle = _create(
			[inParent.wxHandle, inID, "", inPosition, inSize, inStyle]
		);
		return new ScrolledWindow(handle);
	}
	
	@:wx_func("set_scrollbars")
	public function setScrollBars(ppuX:Int, ppuY:Int, nuX:Int, nuY:Int,
	xPos = 0, yPos = 0, noRefresh = false) {
		return _set_scrollbars(wxHandle, ppuX, ppuY, nuX, nuY, xPos, yPos, noRefresh);
	}
	
}
