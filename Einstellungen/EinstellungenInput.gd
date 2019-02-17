extends VBoxContainer

# model
var einstellungen

var container
var lattenBereicheInput 
var schnuereBereicheInput
var schnittlinieInput

signal einstellungen_uebernehmen(einstellungen)

func _init():
	# Wir brauchen das, damit der Scene-Editor funktioniert.
	# Einstellungen werden von der Root-Scene neu gesetzt und dieses hier verworfen
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	var einstellungen = einstellungenClass.new()
	init(einstellungen)


func init(_einstellungen):
	einstellungen = _einstellungen
	var bereicheInputScene = preload("res://Einstellungen/BereicheInput.tscn")
	lattenBereicheInput = bereicheInputScene.instance()
	lattenBereicheInput.init("L", einstellungen)
	schnuereBereicheInput = bereicheInputScene.instance()
	schnuereBereicheInput.init("S", einstellungen)
	
	schnittlinieInput = preload("res://Einstellungen/SchnittlinieInput.tscn").instance()
	schnittlinieInput.init(einstellungen)


func _ready():
	container = get_node("GridContainer")
	container.get_child(5).replace_by(schnuereBereicheInput)
	container.get_child(8).replace_by(lattenBereicheInput)
	container.get_child(11).replace_by(schnittlinieInput)


func _on_UebernehmenButton_pressed():
	#print("einstellungen_uebernehmen")
	emit_signal("einstellungen_uebernehmen", einstellungen)

