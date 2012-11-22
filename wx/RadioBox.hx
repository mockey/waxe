package wx;

import wx.Window;

@:wx("radio_box")
class RadioBox extends Window, implements MacroCffi {
	
	//defs from: http://docs.wxwidgets.org/trunk/defs_8h.html
	public static inline var SPECIFY_ROWS = 0x0008; //wxVERTICAL 
	public static inline var SPECIFY_COLS =	0x0004; //wxHORIZONTAL
	
	public static function create(inParent:Window, ?inID:Int, inValue="",
	?inPosition:Position, ?inSize:Size, ?inChoices:Array<String>,
	inRowsOrCols:Int=SPECIFY_COLS, ?inStyle:Int) {
		if (inParent == null)
			throw Error.INVALID_PARENT;
		var handle = _create(
			[inParent.wxHandle, inID, inValue, inPosition, inSize, inStyle],
			inChoices, inRowsOrCols
		);
		return new RadioBox(handle, inChoices.length);
	}
	
	function new(inHandle:Dynamic, inCount:Int) {
		super(inHandle);
		items = [];
		for (i in 0...inCount) items.push(new Item(i, wxHandle));
	}
	
	public var items:Array<Item>;
	
	@:wx_prop("selected_index")
	public var selectedIndex:Int;
	
	@:wx_event("COMMAND_RADIOBOX_SELECTED")
	public var onSelected:Dynamic->Void;
	/*
	public function getItemLabel(idx:Int):String {
		return wx_radio_box_get_item_label(wxHandle, idx);
	}
	public function setItemLabel(idx:Int, label:String) {
		wx_radio_box_set_item_label(wxHandle, idx, label);
	}
	
	public function isItemEnabled(idx:Int):Bool {
		return wx_radio_box_get_item_enabled(wxHandle, idx);
	}
	public function enableItem(idx:Int, yes:Bool):Bool {
		return wx_radio_box_set_item_enabled(wxHandle, idx, yes);
	}
	
	public function isItemShown(idx:Int):Bool {
		return wx_radio_box_get_item_shown(wxHandle, idx);
	}
	public function showItem(idx:Int, show:Bool):Bool {
		return wx_radio_box_set_item_shown(wxHandle, idx, show);
	}
	
	static var wx_radio_box_get_item_label = Loader.load("wx_radio_box_get_item_label", 2);
	static var wx_radio_box_set_item_label = Loader.load("wx_radio_box_set_item_label", 3);
	static var wx_radio_box_get_item_enabled = Loader.load("wx_radio_box_get_item_enabled", 2);
	static var wx_radio_box_set_item_enabled = Loader.load("wx_radio_box_set_item_enabled", 3);
	static var wx_radio_box_get_item_shown = Loader.load("wx_radio_box_get_item_shown", 2);
	static var wx_radio_box_set_item_shown = Loader.load("wx_radio_box_set_item_shown", 3);
	*/
}

@:wx("radio_box")
private class Item implements wx.MacroCffi {
	var wxHandle:Dynamic;
	var index:Int;
	@:wx_prop_idx("item_label") public var label:String;
	@:wx_prop_idx("item_enabled") public var enabled:Bool;
	@:wx_prop_idx("item_shown") public var visible:Bool;
	
	public function new(idx:Int, handle:Dynamic) {
		wxHandle = handle;
		index = idx;
	}
}
