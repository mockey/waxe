#include "HaxeAPI.h"

value wx_item_container_append_item(value inContainer, value inLabel)
{
	wxItemContainer *container;
	if (!ValueToWX(inContainer, container))
		val_throw(alloc_string("Invalid Container"));
	int idx = container->Append(Val2Str(inLabel));
	return WXToValue(idx);
}
DEFINE_PRIM(wx_item_container_append_item, 2);

value wx_item_container_insert_item(value inContainer, value inLabel, value inIndex)
{
	wxItemContainer *container;
	if (!ValueToWX(inContainer, container))
		val_throw(alloc_string("Invalid Container"));
	unsigned int pos = Val2Int(inIndex);
	int idx = container->Insert(Val2Str(inLabel), pos);
	return WXToValue(idx);
}
DEFINE_PRIM(wx_item_container_insert_item, 3);

value wx_item_container_delete_item(value inContainer, value inIndex)
{
	wxItemContainer *container;
	if (!ValueToWX(inContainer, container))
		val_throw(alloc_string("Invalid Container"));
	unsigned int pos = Val2Int(inIndex);
	container->Delete(pos);
	return alloc_null();
}
DEFINE_PRIM(wx_item_container_delete_item, 2);

value wx_item_container_clear(value inContainer)
{
	wxItemContainer *container;
	if (!ValueToWX(inContainer, container))
		val_throw(alloc_string("Invalid Container"));
	container->Clear();
	return alloc_null();	
}
DEFINE_PRIM(wx_item_container_clear, 1);
