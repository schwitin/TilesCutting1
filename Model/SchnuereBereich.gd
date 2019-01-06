extends Reference


var deckbreite
var anzahl_ziegel
var anzahl_schnuere


func _init(ziegel_typ):
	deckbreite = int(ziegel_typ.deckBreite)
	anzahl_ziegel = 3
	anzahl_schnuere = 3

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func get_berichbreite():
	return deckbreite * anzahl_ziegel * anzahl_schnuere