extends Node

var scene_uebersicht
var scene_einzeldarstellung
var scene_einstellungen


func _ready():
	scene_uebersicht = preload("res://Uebersicht/Uebersicht.tscn").instance()
	scene_einzeldarstellung = preload("res://Einzeldarstellung/Einzeldarstellung.tscn").instance()
	scene_einstellungen = preload("res://Einstellungen/EinstellungenInput.tscn").instance()
	
	scene_einzeldarstellung.connect("einzeldarstellung_pressed", self, "_on_einzeldarstellung_pressed")
	scene_einzeldarstellung.connect("einzeldarstellung_verlassen", self, "_on_einzeldarstellung_verlassen")
	scene_uebersicht.connect("uebersicht_pressed", self, "_on_uebersicht_pressed")
	scene_uebersicht.connect("uebersicht_verlassen", self, "_on_uebersicht_verlassen")
	scene_einstellungen.connect("einstellungen_uebernehmen", self, "_on_einstellungen_uebernehmen")
	
	add_child(scene_einstellungen)


func _on_einzeldarstellung_pressed():
	remove_child(scene_einstellungen)
	add_child(scene_uebersicht)


func _on_uebersicht_pressed():
	remove_child(scene_uebersicht)
	add_child(scene_einzeldarstellung)


func _on_einstellungen_uebernehmen():
	remove_child(scene_einstellungen)
	add_child(scene_uebersicht)


func _on_uebersicht_verlassen():
	print("to scene_einstellungen")
	call_deferred("remove_child", scene_uebersicht)
	call_deferred("add_child", scene_einstellungen)


func _on_einzeldarstellung_verlassen():
	print("to scene_uebersicht")
	call_deferred("remove_child", scene_einzeldarstellung)
	call_deferred("add_child", scene_uebersicht)
