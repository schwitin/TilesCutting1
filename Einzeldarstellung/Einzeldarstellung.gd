extends Node

var einstellungen

signal einzeldarstellung_pressed()
signal einzeldarstellung_verlassen()


func _init():
	# Wir brauchen das, damit der Scene-Editor funktioniert.
	# Einstellungen werden von der Root-Scene neu gesetzt und dieses hier verworfen
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	var einstellungen = einstellungenClass.new()
	init(einstellungen)


func init(_einstellungen):
	einstellungen = _einstellungen


func _ready():
	pass

func _on_Button_pressed():
	emit_signal("einzeldarstellung_pressed")

func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST :
		print("einzeldarstellung_verlassen")
		emit_signal("einzeldarstellung_verlassen")
