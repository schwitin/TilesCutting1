extends Node

signal uebersicht_pressed()
signal uebersicht_verlassen()

func _ready():

	pass


func _on_Button_pressed():
	emit_signal("uebersicht_pressed")
	
func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		print("uebersicht_verlassen")
		emit_signal("uebersicht_verlassen")

