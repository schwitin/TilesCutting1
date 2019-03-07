extends Button


var min_wert 
var max_wert
var wert setget set_wert
var anpassung_schritt

signal selected(input_field)
signal value_changed(new_value)

func _init(_wert=1000, _min_wert = -10, _max_wert=10, _anpassung_schritt=1):
	min_wert = _min_wert
	max_wert = _max_wert
	anpassung_schritt = _anpassung_schritt
	set_wert(_wert)


func set_wert(_wert):
	wert = _wert
	set_text(String(wert))
	emit_signal("value_changed", wert)


func get_wert():
	return wert


func deselect():
	add_color_override("font_color", Color(1,1,1))
	add_color_override("font_color_hover", Color(1,1,1))

func select():
	add_color_override("font_color", Color(1,1,0))
	add_color_override("font_color_hover", Color(1,1,0))
	#update()
	emit_signal("selected", self)

func _on_InputField_pressed():
	select()
	

