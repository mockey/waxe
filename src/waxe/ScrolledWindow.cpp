#include "HaxeAPI.h"

value wx_scrolled_window_create(value inParams)
{
	CreationParams params(inParams);
	wxScrolledWindow *window = new wxScrolledWindow(
		params.parent, params.id, params.position, params.size, params.flags
	);

	return WXToValue(window);
}
DEFINE_PRIM(wx_scrolled_window_create, 1);

value wx_scrolled_window_set_scrollbars(value *args, int nargs)
{
	if (nargs < 8)
		val_throw(alloc_string("Too few arguments"));
	wxScrolledWindow *window;
	if (!ValueToWX(args[0], window))
		val_throw(alloc_string("Invalid Window"));
	int ppuX = Val2Int(args[1]);
	int ppuY = Val2Int(args[2]);
	int nuX = Val2Int(args[3]);
	int nuY = Val2Int(args[4]);
	int xPos = Val2Int(args[5]);
	int yPos = Val2Int(args[6]);
	bool noRefresh = Val2Bool(args[7]);
	window->SetScrollbars(ppuX, ppuY, nuX, nuY, xPos, yPos, noRefresh);
	return alloc_null();
}
DEFINE_PRIM_MULT(wx_scrolled_window_set_scrollbars);
