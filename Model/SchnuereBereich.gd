extends Reference


var deckbreite
var anzahl_ziegel
var anzahl_schnuere


func _init(ziegel_typ):
	deckbreite = int(ziegel_typ.deckBreite)
	anzahl_ziegel = 3
	anzahl_schnuere = 3

func _ready():
	pass
	
func get_berich_groesse():
	return deckbreite * anzahl_ziegel * anzahl_schnuere