extends Button

var abstand_input_scene
var abstandClass
var abstaende = {} setget abstaende_set
var abstandInputContainer
var removeButton
var addButton

signal changed(abstaende_values)

func _ready():
	abstand_input_scene = preload("res://Einstellungen/AbstandInput.tscn")
	abstandClass = load("res://Model/Abstand.gd")
	abstandInputContainer = get_node("PopupPanel/Container/AbstandInputContainer")
	removeButton = get_node("PopupPanel/Container/AddRemoveContainer/RemoveButton")
	addButton = get_node("PopupPanel/Container/AddRemoveContainer/AddButton")
	
	_on_AddButton_pressed()
	update_button_visibility()


func abstaende_set(_abstaende_arr):
	abstandInputContainer.queue_free()
	abstaende.erase()
	for abstand in _abstaende_arr:
		add_abstand(abstand)
	
	set_text()


func _on_AddButton_pressed():
	var abstand = abstandClass.new()
	add_abstand(abstand)
	update_button_visibility()
	emit_signal("changed", abstaende.values())
	set_text()


func _on_RemoveButton_pressed():
	var abstandInput = abstaende.keys().back()	
	abstandInputContainer.remove_child(abstandInput)
	abstaende.erase(abstandInput)
	abstandInputContainer.minimum_size_changed()
	update_button_visibility()
	emit_signal("changed", abstaende.values())
	set_text()


func update_button_visibility():
	addButton.visible = abstaende.keys().size() < 6
	removeButton.visible = abstaende.keys().size() > 1


func add_abstand(abstand):
	var abstandInput = abstand_input_scene.instance()
	abstandInput.abstand = abstand
	abstandInput.connect("changed", self, "set_text")
	abstaende[abstandInput] = abstand
	abstandInputContainer.add_child(abstandInput)


func _on_DachdimensionInput_pressed():
	get_node("PopupPanel").popup_centered()

func set_text():
	var abstand = 0
	var anzahl = 0
	for a in abstaende.values():
		anzahl += a.anzahl
		abstand += (a.abstand * a.anzahl)
		
		
	self.text = "" + String(abstand) + " | " + String(anzahl)