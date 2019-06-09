extends "BereichInput.gd"

# Eingabemaske für ein Lattenbereich bestehend aus zwei ToggleButtons, die die Rolle der Eingabefelder spielen:
# - Decklänge
# - Anzahl der Latten mit dieser Decklänge

var decklaenge_node
var latten_node
var gesamtgroesse_node

# model
var bereich setget set_bereich

signal value_changed(bereich)


func _ready():
	#test()
	pass


func test():
	var lattenBereichClass = load("res://Model/LattenBereich.gd")
	set_bereich(lattenBereichClass.new(get_beispiel_ziegel_typ()))


func set_bereich(_bereich):
	bereich = _bereich
	var children = get_children()
	for child in children:
		remove_child(child)
	
	gesamtgroesse_node = create_label_node("?")
	decklaenge_node = crate_decklaenge_node()
	latten_node = create_latten_node()
	
	add_child(decklaenge_node)
	add_child(create_label_node(" x "))
	add_child(latten_node)
	add_child(create_label_node("="))
	add_child(gesamtgroesse_node)
	update_gesamtgroesse()


func crate_decklaenge_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_decklaenge_changed")
	node.wert = int(bereich.decklaenge)
	node.min_wert = int(bereich.decklaenge_min)
	node.max_wert = int(bereich.decklaenge_max)
	return node


func create_latten_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_latten_changed")
	node.wert = int(bereich.anzahl_latten)
	node.min_wert = 1
	node.max_wert = 16
	return node


func update_gesamtgroesse():
	var bereichbreite = bereich.get_berich_groesse()
	# print("bereichbreite", bereichbreite)
	gesamtgroesse_node.set_text(String(bereichbreite))


func _on_decklaenge_changed(value):
	bereich.decklaenge = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func _on_latten_changed(value):
	bereich.anzahl_latten = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)