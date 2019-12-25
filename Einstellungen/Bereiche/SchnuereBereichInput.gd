extends "BereichInput.gd"

var schnurabstand_node
var ziegel_node
var schnuere_node
var gesamtgroesse_node

# model
var bereich setget set_bereich

signal value_changed(bereich)


func _ready():
	#test()
	pass


func test():
	var schnuereBereichClass = load("res://Model/SchnuereBereich.gd")
	self.bereich = schnuereBereichClass.new(get_beispiel_ziegel_typ())


func set_bereich(_bereich):
	bereich = _bereich
	var children = get_children()
	for child in children:
		remove_child(child)
		
	gesamtgroesse_node = create_label_node("?")
	schnurabstand_node = crate_schnurabstand_node()
	ziegel_node = create_ziegel_node()
	schnuere_node = create_schnuere_node()
	
	add_child(schnurabstand_node)
	add_child(create_label_node("                "))
	add_child(schnuere_node)
	add_child(create_label_node("                 "))
	add_child(ziegel_node)
	update_gesamtgroesse()


func crate_schnurabstand_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_schnurabstand_changed")
	node.wert = bereich.schnurabstand
	node.min_wert = bereich.deckbreiteMin * bereich.anzahl_ziegel
	node.max_wert = bereich.deckbreiteMax * bereich.anzahl_ziegel
	return node


func create_ziegel_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_ziegel_changed")
	node.wert = bereich.anzahl_ziegel
	node.min_wert = 2
	node.max_wert = 10
	return node


func create_schnuere_node():
	var node = inputFieldScene.instance()
	node.connect("selected", self, "_on_InputField_selected")
	node.connect("value_changed", self, "_on_schnuere_changed")
	node.wert = bereich.anzahl_schnuere
	node.min_wert = 1
	node.max_wert = 10
	return node


func update_gesamtgroesse():
	var bereichbreite = bereich.get_berich_groesse()
	# print("bereichbreite", bereichbreite)
	gesamtgroesse_node.set_text(String(bereichbreite))


func _on_schnurabstand_changed(value):
	bereich.schnurabstand = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func _on_ziegel_changed(value):
	bereich.anzahl_ziegel = value
	bereich.schnurabstand = bereich.deckbreite * bereich.anzahl_ziegel
	schnurabstand_node.wert = bereich.schnurabstand
	schnurabstand_node.min_wert = bereich.deckbreiteMin * bereich.anzahl_ziegel
	schnurabstand_node.max_wert = bereich.deckbreiteMax * bereich.anzahl_ziegel
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)


func _on_schnuere_changed(value):
	bereich.anzahl_schnuere = value
	update_gesamtgroesse()
	emit_signal("value_changed", bereich)
