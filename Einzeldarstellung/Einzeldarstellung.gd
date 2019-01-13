extends Node

signal einzeldarstellung_pressed()
signal einzeldarstellung_verlassen()

func _ready():
	pass

func _on_Button_pressed():
	emit_signal("einzeldarstellung_pressed")

func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST :
		print("einzeldarstellung_verlassen")
		emit_signal("einzeldarstellung_verlassen")
