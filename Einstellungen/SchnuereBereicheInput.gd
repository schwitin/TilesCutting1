extends Button

var schnuereBereichClass = preload("res://Model/SchnuereBereich.gd")
var schnuere_input_scene = preload("res://Einstellungen/SchnuereBereichInput.tscn")

var bereiche = {} setget bereiche_set

var bereicheContainer
var removeButton
var addButton
var slider

var selected_input_field

signal changed(abstaende_values)

func _ready():
	bereicheContainer = get_node("PopupPanel/Container/BereicheContainer")
	removeButton = get_node("PopupPanel/Container/AddRemoveContainer/RemoveButton")
	addButton = get_node("PopupPanel/Container/AddRemoveContainer/AddButton")
	slider = get_node("PopupPanel/VSlider")
	
	_on_AddButton_pressed()


func bereiche_set(_bereiche_arr):
	bereicheContainer.queue_free()
	bereiche.erase()
	for bereich in _bereiche_arr:
		add_bereich(bereich)
	
	set_text()


func _on_AddButton_pressed():
	var schnuereBereich = schnuereBereichClass.new(get_beispiel_ziegel_typ())
	print("_on_AddButton_pressed", schnuereBereich.deckbreite)
	add_bereich(schnuereBereich)
	update_button_visibility()
	emit_signal("changed", bereiche.values())
	set_text()


func _on_RemoveButton_pressed():
	var abstandInput = bereiche.keys().back()	
	bereicheContainer.remove_child(abstandInput)
	bereiche.erase(abstandInput)
	bereicheContainer.minimum_size_changed()
	update_button_visibility()
	emit_signal("changed", bereiche.values())
	set_text()


func update_button_visibility():
	addButton.set_hidden(false)
	addButton.set_hidden(bereiche.keys().size() > 4)
	removeButton.set_hidden(bereiche.keys().size() < 2)


func add_bereich(bereich):
	print("addbereich")
	var schnuere_input = schnuere_input_scene.instance()
	schnuere_input.connect("selected", self, "_on_InputField_selected")
	schnuere_input.connect("value_changed", self, "_on_bereich_value_changed")
	schnuere_input.schnuere_bereich = bereich
	# abstandInput.connect("changed", self, "set_text")
	bereiche[schnuere_input] = bereich
	bereicheContainer.add_child(schnuere_input)


func _on_DachdimensionInput_pressed():
	get_node("PopupPanel").popup_centered()


func _on_InputField_selected(input_field):
	self.selected_input_field = null
	for bereich in bereiche.keys():
		bereich.alle_abwaehlen_ausser(input_field)
	
	slider.set_min(input_field.anpassung_min)
	slider.set_max(input_field.anpassung_max)
	slider.set_step(input_field.anpassung_schritt)
	slider.set_value(input_field.anpassung_wert)
	
	self.selected_input_field = input_field


func _on_slider_value_changed( value ):
	if null != self.selected_input_field:
		self.selected_input_field.anpassung_wert = value


func _on_bereich_value_changed(bereich):
	# print("_on_bereich_value_changed")
	set_text()
	emit_signal("changed", bereiche.values())
	
func set_text():
	var gesamtbreite = 0
	var anzahl_bereiche = 0
	for b in bereiche.values():
		anzahl_bereiche += 1 
		gesamtbreite += b.get_berichbreite()
		
		
	self.text = "" + String(gesamtbreite) + " | " + String(anzahl_bereiche)
	
	
	
func get_beispiel_ziegel_typ():
	var data = {
			"Name": "Rubin 9V",
			"Hersteller": "BRAAS",
			"Laenge" : "472",
			"Breite" : "313",
			"VersatzY": "35",
			"DecklaengeMin" : "370",
			"DecklaengeMax" : "400",
			"Deckbreite" : "267"
		}
	var ziegelTypClass = load("res://Model/ZiegelTyp1.gd")
	var ziegel_typ = ziegelTypClass.new(data)
	return ziegel_typ