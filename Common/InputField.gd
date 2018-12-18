extends HBoxContainer


signal text_changed(new_text)

func _ready():
	pass



func _on_LineEdit_text_changed(new_text):
	emit_signal("text_changed", new_text)
