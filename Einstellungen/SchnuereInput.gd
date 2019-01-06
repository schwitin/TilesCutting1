extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Label_selected( input_field ):
	input_field.add_color_override("font_color", Color(1,0,0))
	var max_value = input_field.max_value
	print (max_value)
	
