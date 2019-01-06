extends HBoxContainer

var inputFieldScene = preload("res://Einstellungen/InputField.tscn")
var schnuereBereichClass = preload("res://Model/SchnuereBereich.gd")

var deckbreite_node
var ziegel_node
var schnuere_node
var gesamtbreite_node
var selected_input_field

# model
var schnuere_bereich setget schnuere_bereich_set

signal selected(input_field)
signal value_changed(schnuere_bereich)

func _ready():
	if null == schnuere_bereich:
		self.schnuere_bereich = schnuereBereichClass.new(get_beispiel_ziegel_typ())


func schnuere_bereich_set(_schnuere_bereich):
	schnuere_bereich = _schnuere_bereich
	var children = get_children()
	for child in children:
		remove_child(child)
		
	gesamtbreite_node = create_label_node("?")
	deckbreite_node = crate_deckbreite_node()
	ziegel_node = create_ziegel_node()
	schnuere_node = create_schnuere_node()
	
	add_child(deckbreite_node)
	add_child(create_label_node("X"))
	add_child(ziegel_node)
	add_child(create_label_node("X"))
	add_child(schnuere_node)
	add_child(create_label_node("="))
	add_child(gesamtbreite_node)
	update_gesamtbreite()


func crate_deckbreite_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_deckbreite_changed")
	node.initial_wert = int(self.schnuere_bereich.deckbreite)
	node.anpassung_min = -2
	node.anpassung_max = 2
	return node


func create_ziegel_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_ziegel_changed")
	node.initial_wert = 4
	node.anpassung_min = -3
	node.anpassung_max = 3
	return node


func create_schnuere_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_schnuere_changed")
	node.initial_wert = 3
	node.anpassung_min = -2
	node.anpassung_max = 13
	return node


func create_label_node(text):
	var node = Label.new()
	node.set_text(text)
	return node
	
func update_gesamtbreite():
	var bereichbreite = schnuere_bereich.get_berichbreite()
	# print("bereichbreite", bereichbreite)
	gesamtbreite_node.set_text(String(bereichbreite))


func alle_abwaehlen_ausser(input_field):
	var children = get_children()
	for child in children:
		if child.get_type() == "LineEdit" && child != input_field:
			child.deselect()


func _on_InputField_selected( input_field ):
	self.selected_input_field = null
	alle_abwaehlen_ausser(input_field)
	self.selected_input_field = input_field
	emit_signal("selected", input_field)
	

func _on_deckbreite_changed(value):
	schnuere_bereich.deckbreite = value
	update_gesamtbreite()
	emit_signal("value_changed", schnuere_bereich)


func _on_ziegel_changed(value):
	schnuere_bereich.anzahl_ziegel = value
	update_gesamtbreite()
	emit_signal("value_changed", schnuere_bereich)


func _on_schnuere_changed(value):
	schnuere_bereich.anzahl_schnuere = value
	update_gesamtbreite()
	emit_signal("value_changed", schnuere_bereich)


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