extends Reference

var deckbreite
var schnurabstand
var deckbreiteMin
var deckbreiteMax
var anzahl_ziegel
var anzahl_schnuere


func _init(ziegel_typ):
	deckbreiteMin = int(ziegel_typ.deckBreiteMin)
	deckbreiteMax = int(ziegel_typ.deckBreiteMax)
	anzahl_ziegel = 3
	anzahl_schnuere = 3
	deckbreite = int(ziegel_typ.deckBreite)
	schnurabstand = deckbreite * anzahl_ziegel 


func init(dictionary):
	deckbreite = dictionary.deckbreite
	schnurabstand = dictionary.schnurabstand
	deckbreiteMin = dictionary.deckbreiteMin
	deckbreiteMax = dictionary.deckbreiteMax
	anzahl_schnuere = dictionary.anzahl_schnuere
	anzahl_ziegel = dictionary.anzahl_ziegel


func get_berich_groesse():
	return schnurabstand * anzahl_schnuere

func get_deckbreite():
	return schnurabstand / anzahl_ziegel
	


func to_dictionary():
	var d = {
		deckbreite = deckbreite,
		schnurabstand = schnurabstand,
		deckbreiteMin = deckbreiteMin,
		deckbreiteMax = deckbreiteMax,
		anzahl_schnuere = anzahl_schnuere,
		anzahl_ziegel = anzahl_ziegel
	}
	return d
