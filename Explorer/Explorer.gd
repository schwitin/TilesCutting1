extends Control

var einstellungenDictionary
var einstellungenDao
var selectedDachName
var selectedDach
var selectedSchnitt

signal schnitt_bearbeiten(schnitt)


func set_einstellungen(_einstellungenDictionary):
	einstellungenDictionary = _einstellungenDictionary


func _init():
	var einstellungenDaoClass = load("res://Model/EinstellungenDAO.gd")
	einstellungenDao = einstellungenDaoClass.new()
	

func _ready():
	var daecher_node = get_daecher_node()
	daecher_node.set_text("Dächer")
	get_schnitte_node().set_text("Schnitte")
	get_schnitte_node().add_button("✓", "bearbeiten")
	var files = einstellungenDao.list()
	get_daecher_node().set_items(files)
	var daecherNode = get_node("HBoxContainer/Daecher")
	var schnitteNode = get_node("HBoxContainer/Schnitte")
	if selectedDachName != null:
		daecherNode.select_item_by_name(selectedDachName)
		if selectedSchnitt != null:
			schnitteNode.select_item_by_name(selectedSchnitt.name)
	

func get_daecher_node():
	return get_node("HBoxContainer/Daecher")


func get_schnitte_node():
	return get_node("HBoxContainer/Schnitte")


func save():
	einstellungenDao.save(selectedDachName, selectedDach)


func _on_Daecher_item_selected( name ):
	var dach = einstellungenDao.read(name)
	var itemList = []
	for schnitt in dach:
		itemList.append(schnitt.name)
	selectedDachName = name
	selectedDach = dach
	get_schnitte_node().set_items(itemList)


func _on_Daecher_item_new( name ):
	einstellungenDao.neues_dach(name)
	var daecherNode = get_node("HBoxContainer/Daecher")
	daecherNode.select_item_by_name(name)


func _on_Daecher_item_removed( name ):
	einstellungenDao.delete(name)
	get_schnitte_node().set_items([])


func _on_Daecher_item_renamed( oldName, newName ):
	var selectedShnittName = selectedSchnitt.name
	einstellungenDao.rename(oldName, newName)
	_on_Daecher_item_selected(newName)
	var schnitteNode = get_node("HBoxContainer/Schnitte")
	schnitteNode.select_item_by_name(selectedShnittName)


func _on_Schnitte_item_new( name ):
	if selectedDachName != null:
		einstellungenDao.add_schnitt(selectedDachName, name)


func _on_Schnitte_item_removed( name ):
	if selectedDachName != null:
		einstellungenDao.remove_schnitt(selectedDachName, name)


func _on_Schnitte_item_renamed( oldName, newName ):
	if selectedDachName != null:
		selectedSchnitt.name = newName
		einstellungenDao.rename_schnitt(selectedDachName, oldName, newName)


func _on_Schnitte_item_selected( name ):
	if selectedDachName != null:
		for schnitt in selectedDach:
			if schnitt.name == name:
				selectedSchnitt = schnitt


func _on_Schnitte_custom_button_pressed( name, action ):
	if selectedSchnitt != null:
		if action == "bearbeiten":
			emit_signal("schnitt_bearbeiten", selectedSchnitt)
