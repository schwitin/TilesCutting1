extends HBoxContainer

# Basisklasse für eine Eingabemaske bestehend aus mehreren ToggleButtons in der Reihe 
# Die Buttons spielen die Rolle der Eingabefelder. Die Button-Labels enthalten die Werte.
# Ist ein Button gedrückt, so wird die Beschriftung hervorgehoben.
# Die initialisierung einzelner Buttons und deren Beschriftung geschiet in den Unterklassen.


var inputFieldScene = preload("res://Einstellungen/InputField.tscn")
var selected_input_field

signal selected(input_field)


func create_label_node(text):
	var node = Label.new()
	node.set_text(text)
	return node

func ersten_eingabefeld_auswaelen():
	get_children().front().select()

func alle_abwaehlen_ausser(input_field):
	if selected_input_field != null && input_field != selected_input_field:
		selected_input_field.deselect()


func _on_InputField_selected( input_field ):
	if selected_input_field != null:
		selected_input_field.deselect()
		
	selected_input_field = input_field
	emit_signal("selected", selected_input_field)
	
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
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var ziegel_typ = ziegelTypClass.new(data)
	return ziegel_typ