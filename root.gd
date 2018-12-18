extends Node

var scene_uebersicht
var scene_einzeldarstellung
var dach

var dachClass

var einstellungen




func _ready():
	dachClass = load("res://Model/Dach.gd")
	einstellungen = test_einstellungen()
	dach = dachClass.new(einstellungen)
	
	scene_uebersicht = preload("res://Uebersicht/Uebersicht.tscn").instance()
	scene_einzeldarstellung = preload("res://Einzeldarstellung/Einzeldarstellung.tscn").instance()	
	
	add_child(scene_uebersicht)
	move_child(scene_uebersicht, 0)	
	scene_uebersicht.dach = dach


	
func test_einstellungen_fehler():
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var einstellungenClass = load("res://Model/Einstellungen.gd")
	var ziegel_groesse = Vector2(30, 60)
	var ziegel_ueberlappung = Vector2(5, 10)
	var ziegel_typ = ziegelTypClass.new("Meine Ziegel1", ziegel_groesse, ziegel_ueberlappung)
	var anzahl_reihen = 5
	var abstand_vom_mast_oben = 300
	var abstand_vom_mast_unten = 100
	var einstellungen = einstellungenClass.new(abstand_vom_mast_oben, abstand_vom_mast_unten, anzahl_reihen, ziegel_typ)
	return einstellungen

func test_einstellungen():
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var einstellungenClass = load("res://Model/Einstellungen.gd")
	var ziegel_groesse = Vector2(300.0001, 600)
	var ziegel_ueberlappung = Vector2(50, 100)
	var ziegel_typ = ziegelTypClass.new("Meine Ziegel1", ziegel_groesse, ziegel_ueberlappung)
	var anzahl_reihen = 5
	var abstand_vom_mast_oben = 5000
	var abstand_vom_mast_unten = 1000
	var einstellungen = einstellungenClass.new(abstand_vom_mast_oben, abstand_vom_mast_unten, anzahl_reihen, ziegel_typ)
	return einstellungen


func _on_SceneSwitch_pressed():
	
	var old_scene = get_child(0)
	var new_scene = null
	if old_scene != null :
		remove_child(old_scene)
	
	if old_scene == scene_uebersicht:
		new_scene = scene_einzeldarstellung
	else:
		new_scene = scene_uebersicht
	
	add_child(new_scene)
	new_scene.dach = dach
	move_child(new_scene, 0)




func _on_SettingsButton_pressed():
	var dialog = get_node("SettingsDialog")
	dialog.einstellungen = einstellungen
	dialog.popup()


func _on_Ok_pressed():
	get_node("SettingsDialog").hide()


func _on_Cancel_pressed():
	get_node("SettingsDialog").hide()


func _on_SettingsDialog_einstellungen_geaendert(_einstellungen):
	einstellungen = _einstellungen
	dach = dachClass.new(einstellungen)
	var scene = get_child(0)
	scene.dach = dach
