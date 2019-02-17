extends Button


var anpassung_min 
var anpassung_max
var anpassung_schritt
var initial_wert setget set_initial_wert
var anpassung_wert=0 setget set_anpassung_wert

signal selected(input_field)
signal value_changed(new_value)

func _init(initial_wert=1000, anpassung_min = -10, anpassung_max=10, anpassung_schritt=1):
	anpassung_min = anpassung_min
	anpassung_max = anpassung_max
	anpassung_schritt = anpassung_schritt
	initial_wert = set_initial_wert(initial_wert)
	update_value()


func _ready():
	pass

func set_initial_wert(_initial_wert):
	initial_wert = _initial_wert
	update_value()

func set_anpassung_wert(_anpassung_wert):
	anpassung_wert = _anpassung_wert
	update_value()

func update_value():
	var neuer_wert = get_wert()
	# print("neeur_wert ", neuer_wert)
	set_text(String(neuer_wert))
	emit_signal("value_changed", neuer_wert)

func get_wert():
	return initial_wert + anpassung_wert


func deselect():
	add_color_override("font_color", Color(1,1,1))
	add_color_override("font_color_hover", Color(1,1,1))


func _on_InputField_pressed():
	add_color_override("font_color", Color(1,1,0))
	add_color_override("font_color_hover", Color(1,1,0))
	update()
	emit_signal("selected", self)

