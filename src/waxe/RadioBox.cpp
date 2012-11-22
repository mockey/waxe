#include "HaxeAPI.h"

value wx_radio_box_create(value inParams, value inChoices, value inRowsOrCols)
{
	CreationParams params(inParams);
	wxArrayString choices;
	Val2ArrayString(inChoices, choices);
	wxRadioBox *window = new wxRadioBox(params.parent, params.id, params.text,
			params.position, params.size, choices, val_int(inRowsOrCols), params.flags);
	return WXToValue(window);
}
DEFINE_PRIM(wx_radio_box_create, 3)

WIN_PROPERTY(wx_radio_box, wxRadioBox, selected_index, GetSelection, SetSelection, Val2Int)
WIN_PROPERTY_IDX(wx_radio_box, wxRadioBox, item_label, GetString, SetString, Val2Str)
WIN_PROPERTY_IDX(wx_radio_box, wxRadioBox, item_enabled, IsItemEnabled, Enable, Val2Bool)
WIN_PROPERTY_IDX(wx_radio_box, wxRadioBox, item_shown, IsItemShown, Show, Val2Bool)
