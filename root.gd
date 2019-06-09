extends Node

var scene_uebersicht
var scene_einzeldarstellung
var scene_einstellungen
var scene_explorer

var selectedSchnitt

var einstellungenDao

func _init():
	var einstellungenDaoClass = load("res://Model/EinstellungenDAO.gd")
	einstellungenDao = einstellungenDaoClass.new()

func _ready():
	scene_explorer = preload("res://Explorer/Explorer.tscn").instance()
	scene_explorer.connect("schnitt_bearbeiten", self, "_on_schnitt_bearbeiten")
	
	scene_einstellungen = preload("res://Einstellungen/EinstellungenInput.tscn").instance()
	scene_uebersicht = preload("res://Uebersicht/Uebersicht.tscn").instance()
	scene_einzeldarstellung = preload("res://Einzeldarstellung/Einzeldarstellung.tscn").instance()
	
	scene_einstellungen.connect("einstellungen_visualisieren", self, "_on_einstellungen_visualisieren")
	scene_einstellungen.connect("einstellungen_cahnged", self, "_on_einstellungen_cahnged")
	scene_einstellungen.connect("einstellungen_verlassen", self, "_on_einstellungen_verlassen")
	
	scene_uebersicht.connect("uebersicht_pressed", self, "_on_uebersicht_pressed")
	scene_uebersicht.connect("uebersicht_verlassen", self, "_on_uebersicht_verlassen")	
	scene_uebersicht.connect("aktueller_ziegel", scene_einzeldarstellung, "set_aktueller_ziegel")
	
	scene_einzeldarstellung.connect("einzeldarstellung_pressed", self, "_on_einzeldarstellung_pressed")
	scene_einzeldarstellung.connect("einzeldarstellung_verlassen", self, "_on_einzeldarstellung_verlassen")
	scene_einzeldarstellung.connect("naechste_nummer", scene_uebersicht, "set_naechste_nummer")
	scene_einzeldarstellung.connect("vorherige_nummer", scene_uebersicht, "set_vorherige_nummer")
	scene_einzeldarstellung.connect("naechste_reihe", scene_uebersicht, "set_naechste_reihe")
	scene_einzeldarstellung.connect("vorherige_reihe", scene_uebersicht, "set_vorherige_reihe")
	
	add_child(scene_explorer)


func _on_schnitt_bearbeiten(schnitt):
	selectedSchnitt = schnitt
	scene_einstellungen.init(schnitt)
	scene_uebersicht.init(schnitt)
	remove_child(scene_explorer)
	add_child(scene_einstellungen)


func _on_einzeldarstellung_pressed():
	remove_child(scene_einzeldarstellung)
	add_child(scene_uebersicht)


func _on_uebersicht_pressed():
	remove_child(scene_uebersicht)
	add_child(scene_einzeldarstellung)

func _on_einstellungen_cahnged():
	scene_explorer.save()
	scene_uebersicht.update_ziegel()

func _on_einstellungen_visualisieren():
	remove_child(scene_einstellungen)
	add_child(scene_uebersicht)


func _on_uebersicht_verlassen():
	call_deferred("remove_child", scene_uebersicht)
	call_deferred("add_child", scene_einstellungen)


func _on_einzeldarstellung_verlassen():
	call_deferred("remove_child", scene_einzeldarstellung)
	call_deferred("add_child", scene_uebersicht)

func _on_einstellungen_verlassen():
	call_deferred("remove_child", scene_einstellungen)
	call_deferred("add_child", scene_explorer)
