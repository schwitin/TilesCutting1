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
	laenge = int(ziegelTyp.Laenge) 
	breite = int(ziegelTyp.Breite)
	deckLaengeMin = int(ziegelTyp.DecklaengeMin)
	deckLaengeMax = int(ziegelTyp.DecklaengeMax)
	deckBreite = int(ziegelTyp.Deckbreite)
	versatzY = int(ziegelTyp.VersatzY)