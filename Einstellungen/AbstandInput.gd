extends Container

var abstand setget abstand_set
signal changed()


func _ready():
	pass

func updateAbstand() :
	abstand.abstand = get_node("Abstand").get_value()
	abstand.anzahl = get_node("Anzahl").get_value()
	emit_signal("changed")


func abstand_set(_abstand) :
	abstand = _abstand
	get_node("Abstand").set_value(abstand.abstand)
	get_node("Anzahl").set_value(abstand.anzahl)


func _on_Anzahl_focus_exited():
	updateAbstand() 


func _on_Abstand_focus_exited():
	updateAbstand() 


func _on_Anzahl_value_changed(value):
	updateAbstand()


func _on_Abstand_value_changed(value):
	updateAbstand()
