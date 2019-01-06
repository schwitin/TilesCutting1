extends Reference


var deckbreite
var anzahl_ziegel
var anzahl_schnuere


func _init():
	abstand = 420
	anzahl = 3

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
	
func get_beispiel_ziegel_typ():
	var data = {
			"Name": "Rubin 9V",
			"Hersteller": "BRAAS",
			"Laenge" : "472",
			"Breite" : "313",
			"VersatzY": "35",
			"DecklaengeMin" : "370",
			"DecklaengeMax" : "400",
			"Deckbreite" : "267"
		}
	var ziegelTypClass = load("res://Model/ZiegelTyp1.gd")
	var ziegel_typ = ziegelTypClass.new(data)
	return ziegel_typ