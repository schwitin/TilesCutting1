extends "BereichInput.gd"

var decklaenge_node
var latten_node
var gesamtgroesse_node

# model
var bereich setget bereich_set

signal value_changed(bereich)


func _ready():
	if null == self.bereich:
		var lattenBereichClass = load("res://Model/LattenBereich.gd")
		self.bereich = lattenBereichClass.new(get_beispiel_ziegel_typ())


func bereich_set(_bereich):
	bereich = _bereich
	var children = get_children()
	for child in children:
		remove_child(child)
		
	self.gesamtgroesse_node = create_label_node("?")
	self.decklaenge_node = crate_decklaenge_node()
	self.latten_node = create_latten_node()
	
	add_child(self.decklaenge_node)
	add_child(create_label_node(" x "))
	add_child(self.latten_node)
	add_child(create_label_node("="))
	add_child(self.gesamtgroesse_node)
	update_gesamtgroesse()


func crate_decklaenge_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_decklaenge_changed")
	node.initial_wert = int(self.bereich.decklaenge)
	node.anpassung_min = int(self.bereich.decklaenge_min)
	node.anpassung_max = int(self.bereich.decklaenge_max)
	return node

func create_latten_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_latten_changed")
	node.initial_wert = 3
	node.anpassung_min = -2
	node.anpassung_max = 13
	return node


func _on_decklaenge_changed(value):
	bereich.decklaenge = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func _on_latten_changed(value):
	bereich.anzahl_latten = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func update_gesamtgroesse():
	var bereichbreite = bereich.get_berich_groesse()
	# print("bereichbreite", bereichbreite)
	gesamtgroesse_node.set_text(String(bereichbreite))
