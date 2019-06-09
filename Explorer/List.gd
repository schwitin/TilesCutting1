extends Control

signal item_new(name)
signal item_removed(name)
signal item_selected(name)
signal item_renamed(oldName, newName)
signal custom_button_pressed(name, action)

var custom_actions = []

func _ready():
	#test()
	pass


func test():
	var items = []
	items.append("Kunde_X")
	items.append("Kunde_Y")
	set_items(items)


func set_items(items):
	var itemList = get_node("VBoxContainer/ItemList")
	itemList.clear()
	for item in items:
		itemList.add_item(item)
	if items.size() > 0:
		select_item(0)


func set_text(text):
	var node = get_node("VBoxContainer/Ueberschrift")
	node.set_text(text)


func add_button(text, action):
	if custom_actions.find(action) < 0:
		var button = Button.new()
		button.set_h_size_flags(SIZE_EXPAND)
		button.set_text(text)
		button.connect("pressed", self, "_on_custom_button_pressed", [action])
		var container = get_node("VBoxContainer/Actions")
		container.add_child(button)
		custom_actions.append(action)

func get_item_list_node():
	return get_node("VBoxContainer/ItemList")


func get_item_text(index):
	var node = get_item_list_node()
	return node.get_item_text(index)


func get_items_count():
	var node = get_item_list_node()
	return node.get_item_count()


func has_item(_name):
	for idx in range(get_items_count()):
		if _name == get_item_text(idx):
			return true
	return false


func get_selected_items():
	var node = get_item_list_node()
	return node.get_selected_items()


func get_selected_index():
	var selectedItems = get_selected_items()
	if selectedItems.size() == 0:
		return -1
	else:
		return selectedItems[0]


func select_item(index):
	var itemsCount = get_items_count()
	if index < itemsCount && index >= 0:
		get_item_list_node().select(index)
		_on_item_selected(index)


func select_item_by_name(name):
	for idx in range(get_items_count()):
		if name == get_item_text(idx):
			select_item(idx)
			return



func popup_dialog(dialog):
	dialog.popup_centered()
	var pos = dialog.get_pos()
	pos.y = 30
	dialog.set_pos(pos)


func _on_Next_pressed():
	if get_items_count() == 0:
		return
	
	var selectedItems = get_selected_items()
	if selectedItems.size() == 0:
		select_item(0)
		return
	
	var selectedIdx = selectedItems[0]
	if selectedIdx + 1 < get_items_count():
		select_item(selectedIdx + 1)


func _on_Previous_pressed():
	if get_items_count() == 0:
		return
	
	var selectedItems = get_selected_items()
	if selectedItems.size() == 0:
		select_item(0)
		return
	
	var selectedIdx = selectedItems[0]
	if selectedIdx - 1 >= 0:
		select_item(selectedIdx - 1)


func _on_Add_pressed():
	var dialog = get_node("NewItemDialog")
	var lineEdit = get_node("NewItemDialog/InputContainer/LineEdit")
	lineEdit.set_text("Neuer_Eintrag")
	popup_dialog(dialog)


func _on_NewItemDialog_confirmed():
	var lineEdit = get_node("NewItemDialog/InputContainer/LineEdit")
	var name = lineEdit.get_text()
	if !has_item(name):
		get_item_list_node().add_item(name)
		emit_signal("item_new", name)


func _on_Remove_pressed():
	var selectedIdx = get_selected_index()
	if selectedIdx >= 0:
		var dialog = get_node("DeleteDialog")
		popup_dialog(dialog)


func _on_DeleteDialog_confirmed():
	var selectedIdx = get_selected_index()
	if selectedIdx >= 0:
		var name = get_item_text(selectedIdx)
		get_item_list_node().remove_item(selectedIdx)
		emit_signal("item_removed", name)


func _on_Rename_pressed():
	var selectedIdx = get_selected_index()
	if selectedIdx >= 0:
		var name = get_item_text(selectedIdx)
		var lineEdit = get_node("RenameDialog/InputContainer/LineEdit")
		lineEdit.set_text(name)
		var dialog = get_node("RenameDialog")
		popup_dialog(dialog)


func _on_RenameDialog_confirmed():
	var selectedIdx = get_selected_index()
	if selectedIdx >= 0:
		var node = get_item_list_node()
		var oldName = node.get_item_text(selectedIdx)
		var lineEdit = get_node("RenameDialog/InputContainer/LineEdit")
		var newName = lineEdit.get_text()
		if !has_item(newName):
			node.set_item_text(selectedIdx, newName)
			emit_signal("item_renamed", oldName, newName)


func _on_item_selected( index ):
	emit_signal("item_selected", get_item_text(index))


func _on_custom_button_pressed(action):
	var selectedIdx = get_selected_index()
	if selectedIdx >= 0:
		var name = get_item_text(selectedIdx)
		emit_signal("custom_button_pressed", name, action)