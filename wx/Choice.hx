package wx;

class Choice extends ControlWithItems {
	public static inline var CB_SORT = 0x0008;
	
	public static function create(inParent:Window, ?inID:Int, ?inPosition:Position,
	?inSize:Size, ?inChoices:Array<String>, ?inStyle:Int) {
		if (inParent == null)
			throw Error.INVALID_PARENT;
		var handle = wx_choice_create(
			[inParent.wxHandle, inID, "", inPosition, inSize, inStyle],
			inChoices
		);
		return new Choice(handle);
	}
	
	@:wx_event("COMMAND_CHOICE_SELECTED")
	public var onSelected:Dynamic->Void;
}
