extends LineEdit


var min_value = 0
var max_value = 10
var step = 2
var value

signal selected(input_field)

func _init(_min_value = 0, _max_value=10, _step=2):
	self.min_value = _min_value
	self.max_value = _max_value
	self.step = _step


func _ready():
	pass
	


func set_text(text):
	var value = int(text)
	if value >= min_value || value <= max_value:
		.set_text(string(value))


func _on_InputField_focus_enter():
	print("bla")
	emit_signal("selected", self)


