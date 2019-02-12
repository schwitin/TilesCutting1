extends Reference

var name
var hersteller
var laenge
var breite
var deckLaengeMin
var deckLaengeMax
var deckBreite
var versatzY


func _init(ziegelTyp):
	name = ziegelTyp.Name
	hersteller = ziegelTyp.Hersteller
	laenge = ziegelTyp.Laenge 
	breite = ziegelTyp.Breite
	deckLaengeMin = ziegelTyp.DecklaengeMin
	deckLaengeMax = ziegelTyp.DecklaengeMax
	deckBreite = ziegelTyp.Deckbreite
	versatzY = ziegelTyp.VersatzY

