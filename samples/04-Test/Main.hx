package;

import wx.Window;
import wx.Sizer;

class Main {
	
	static function main() {
		wx.App.boot(function() new Main());
	}
	
	function new() {
		var frame = wx.Frame.create(null, "Test", {width: 800, height: 600});
		
		//var panel = wx.Panel.create(frame);
		var panel = wx.ScrolledWindow.create(frame, null);
		panel.setScrollBars(20, 20, 50, 50);
		var sizer = wx.BoxSizer.create(true);
		
		var radioBox = wx.RadioBox.create(panel, "Radio Box", [
			"item 0", "item 1", "item 2", "item 3", "item 4", "item 5", "item 6", "item 7", "item 8", "item 9"
		], 2, wx.RadioBox.SPECIFY_COLS);
		sizer.add(radioBox, 0, Sizer.BORDER_ALL, 10);
		
		var txt = wx.StaticText.create(panel, "selected item: 0");
		sizer.add(txt, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		radioBox.onSelected = function(_) txt.label = "selected item: " + radioBox.selectedIndex;
		
		var num = 8;
		var btn1 = wx.Button.create(panel, "Select/Deselect item");
		btn1.onClick = function(_) {
			radioBox.selectedIndex = radioBox.selectedIndex == num ? 0 : num;
			radioBox.items[num].label = radioBox.selectedIndex == num ? "selected" : "item " + num;
		}
		sizer.add(btn1, 0, Sizer.BORDER_ALL, 10);
		
		var btn2 = wx.Button.create(panel, "Enable/Show item");
		btn2.onClick = function(_) {
			radioBox.items[4].enabled = !radioBox.items[4].enabled;
			radioBox.items[5].visible = !radioBox.items[5].visible;
		}
		sizer.add(btn2, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		
		
		var listBox = wx.ListBox.create(panel, [
			"item 0", "item 1", "item 2", "item 3", "item 4", "item 5"
		]);
		sizer.add(listBox, 0, Sizer.BORDER_ALL, 10);
		
		var btn3 = wx.Button.create(panel, "Append item");
		btn3.onClick = function(_) trace(listBox.appendItem("appended"));
		sizer.add(btn3, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		
		var btn4 = wx.Button.create(panel, "Insert item");
		btn4.onClick = function(_) trace(listBox.insertItem("inserted", 2));
		sizer.add(btn4, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		
		var btn5 = wx.Button.create(panel, "Delete item");
		btn5.onClick = function(_) listBox.deleteItem(
			listBox.selection > -1 ? listBox.selection : 0
		);
		sizer.add(btn5, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		
		var btn6 = wx.Button.create(panel, "Clear items");
		btn6.onClick = function(_) listBox.clear();
		sizer.add(btn6, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		
		var sound = new nme.media.Sound(new nme.net.URLRequest("test.ogg"), true);
		if (sound == null)
			trace("WARNING: sound file failed to load");
		var channel = null;
		var btn7 = wx.Button.create(panel, "Play/stop sound");
		btn7.onClick = function(_) {
			if (channel == null) channel = sound.play(0, -1);
			else {
				channel.stop();
				channel = null;
			}
		}
		sizer.add(btn7, 0, Sizer.BORDER_LEFT | Sizer.BORDER_RIGHT, 10);
		
		var nmeStage = wx.NMEStage.create(panel, {x: 300, y: 0}, {width: 300, height: 300});
		var s = new nme.display.Sprite();
		var gfx = s.graphics;
		gfx.beginFill(0xFF0000);
		gfx.drawCircle(100, 100, 100);
		nmeStage.stage.addChild(s);
		
		panel.sizer = sizer;
		wx.App.setTopWindow(frame);
		frame.shown = true;
	}
	
}
