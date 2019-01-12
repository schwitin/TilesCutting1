extends HBoxContainer

var inputFieldScene = preload("res://Einstellungen/InputField.tscn")
var selected_input_field
signal selected(input_field)

#enum BereichTyp {
#	LATTEN,
#	SCHNUERE
#};


func create_label_node(text):
	var node = Label.new()
	node.set_text(text)
	return node


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
