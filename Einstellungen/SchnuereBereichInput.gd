extends "BereichInput.gd"

var deckbreite_node
var ziegel_node
var schnuere_node
var gesamtgroesse_node

# model
var bereich setget bereich_set

signal value_changed(bereich)

func _ready():
	if null == bereich:
		var schnuereBereichClass = load("res://Model/SchnuereBereich.gd")
		self.bereich = schnuereBereichClass.new(get_beispiel_ziegel_typ())


func bereich_set(_bereich):
	bereich = _bereich
	var children = get_children()
	for child in children:
		remove_child(child)
		
	gesamtgroesse_node = create_label_node("?")
	deckbreite_node = crate_deckbreite_node()
	ziegel_node = create_ziegel_node()
	schnuere_node = create_schnuere_node()
	
	add_child(deckbreite_node)
	add_child(create_label_node(" x "))
	add_child(ziegel_node)
	add_child(create_label_node(" x "))
	add_child(schnuere_node)
	add_child(create_label_node("="))
	add_child(gesamtgroesse_node)
	update_gesamtgroesse()


func crate_deckbreite_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_deckbreite_changed")
	node.initial_wert = int(self.bereich.deckbreite)
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


func update_gesamtgroesse():
	var bereichbreite = bereich.get_berich_groesse()
	# print("bereichbreite", bereichbreite)
	gesamtgroesse_node.set_text(String(bereichbreite))


func _on_deckbreite_changed(value):
	bereich.deckbreite = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func _on_ziegel_changed(value):
	bereich.anzahl_ziegel = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func _on_schnuere_changed(value):
	bereich.anzahl_schnuere = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)
