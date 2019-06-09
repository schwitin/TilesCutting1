extends Reference

var deckbreite
var anzahl_ziegel
var anzahl_schnuere


func _init(ziegel_typ):
	deckbreite = int(ziegel_typ.deckBreite)
	anzahl_ziegel = 3
	anzahl_schnuere = 3


func init(dictionary):
	deckbreite = dictionary.deckbreite
	anzahl_schnuere = dictionary.anzahl_schnuere
	anzahl_ziegel = dictionary.anzahl_ziegel


func get_berich_groesse():
	return deckbreite * anzahl_ziegel * anzahl_schnuere


func get_abstand():
	return deckbreite * anzahl_ziegel


func to_dictionary():
	var d = {
		deckbreite = deckbreite,
		anzahl_schnuere = anzahl_schnuere,
		anzahl_ziegel = anzahl_ziegel
	}
	return d
