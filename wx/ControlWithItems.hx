package wx;

import wx.Window;

@:wx("item_container")
class ControlWithItems extends Window, implements MacroCffi {
	var items:Array<Item>;
	
	function new(inHandle:Dynamic, inCount:Int) {
		super(inHandle);
		items = [];
		for (i in 0...inCount) items.push(new Item(i, wxHandle));
	}
	
	@:wx_func("append_item")
	public function appendItem(label:String, ?data:Dynamic):Int {
		items.push(new Item(items.length, wxHandle, data));
		return _append_item(wxHandle, label);
	}
	
	public function appendItems(items:Array<{label:String, ?data:Dynamic}>):Int {
		return 0;
	}
	
	@:wx_func("insert_item")
	public function insertItem(label:String, idx:Int, ?data:Dynamic):Int {
		items.insert(idx, new Item(idx, wxHandle, data));
		updateIndexes(idx + 1);
		return _insert_item(wxHandle, label, idx);
	}
	
	public function insertItems(items:Array<{label: String, ?data:Dynamic}>):Int {
		return 0;
	}
	
	@:wx_func("delete_item")
	public function deleteItem(idx:Int) {
		items.splice(idx, 1);
		updateIndexes(idx);
		_delete_item(wxHandle, idx);
	}
	
	@:wx_func("clear")
	public function clear() {
		items = [];
		_clear(wxHandle);
	}
	
	public function replaceItems(items:Array<{label: String, ?data:Dynamic}>) {
		
	}
	
	function updateIndexes(idx:Int) {
		for (i in idx...items.length) items[i].index = i;
	}
	
	/*static var _append_item = Loader.load("wx_item_container_append_item", 2);
	static var _insert_item = Loader.load("wx_item_container_insert_item", 3);
	static var _delete_item = Loader.load("wx_item_container_delete_item", 2);
	static var _clear = Loader.load("wx_item_container_clear", 1);*/
}

private class Item {
	var wxHandle:Dynamic;
	public var index:Int;
	public var data:Dynamic;
	@:wx_prop_idx("item_label") public var label:String;
	
	public function new(idx:Int, handle:Dynamic, ?dat:Dynamic) {
		index = idx;
		wxHandle = handle;
		data = dat;
	}
}
