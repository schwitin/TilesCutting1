extends Reference

var decklaenge_min
var decklaenge_max
var decklaenge
var anzahl_latten


func _init(ziegel_typ):
	decklaenge_min = int(ziegel_typ.deckLaengeMin)
	decklaenge_max = int(ziegel_typ.deckLaengeMax)
	decklaenge = decklaenge_min + (decklaenge_max - decklaenge_min) / 2
	anzahl_latten = 3


func get_berich_groesse():
	return decklaenge * anzahl_latten