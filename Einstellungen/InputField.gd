extends LineEdit


var anpassung_min 
var anpassung_max
var anpassung_schritt
var initial_wert setget initial_wert_set
var anpassung_wert=0 setget anpassung_wert_set

signal selected(input_field)
signal value_changed(new_value)

func _init(initial_wert=1000, anpassung_min = -10, anpassung_max=10, anpassung_schritt=1):
	self.anpassung_min = anpassung_min
	self.anpassung_max = anpassung_max
	self.anpassung_schritt = anpassung_schritt
	self.initial_wert = initial_wert
	update_value()


func _ready():
	pass

func initial_wert_set(_initial_wert):
	initial_wert = _initial_wert
	update_value()

func anpassung_wert_set(_anpassung_wert):
	anpassung_wert = _anpassung_wert
	update_value()

func update_value():
	var neuer_wert = get_wert()
	# print("neeur_wert ", neuer_wert)
	.set_text(String(neuer_wert))
	emit_signal("value_changed", neuer_wert)

func get_wert():
	return initial_wert + anpassung_wert


func deselect():
	add_color_override("font_color", Color(1,1,1))


func _on_InputField_focus_enter():
	add_color_override("font_color", Color(1,1,0))
	emit_signal("selected", self)
