#include "HaxeAPI.h"

value wx_choice_create(value inParams, value inChoices)
{
	CreationParams params(inParams);
	wxArrayString choices;
	Val2ArrayString(inChoices, choices);
	wxChoice *window = new wxChoice(params.parent, params.id, params.text,
			params.position, params.size, choices, params.flags);
	return WXToValue(window);
}
DEFINE_PRIM(wx_choice_create, 2)

WIN_PROPERTY(wx_choice, wxChoice, selected_index, GetCurrentSelection, SetSelection, Val2Int)
WIN_PROPERTY_IDX(wx_choice, wxChoice, item_label, GetString, SetString, Val2Str)
