extends Resource

var ziegelTyp = null setget set_ziegel_typ
var bereicheSchuere = [] setget set_bereiche_schnuere
var bereicheLatten = [] setget set_bereiche_latten
var schnittlinie = null setget set_schnittlinie
var istGrat = true setget set_grat

signal ziegel_typ_changed()
signal schnuere_changed()
signal latten_changed()
signal schnittlinie_changed()

var classDach = preload("res://Model/Dach.gd")


func _init():
	init_ziegel_typ()


func set_ziegel_typ(_ziegelTyp):
	ziegelTyp = _ziegelTyp
	schnittlinie = null
	bereicheLatten.clear()
	bereicheSchuere.clear()
	init_bereiche_latten()
	init_bereiche_scnuere()
	emit_signal("ziegel_typ_changed")


func set_bereiche_schnuere(bereiche):
	bereicheSchuere = bereiche
	schnittlinie = null
	init_schnittlinie()
	emit_signal("schnuere_changed")


func set_bereiche_latten(bereiche):
	#print("set_bereiche_latten", self)
	bereicheLatten = bereiche
	schnittlinie = null
	init_schnittlinie()
	emit_signal("latten_changed")


func set_schnittlinie(_schnittlinie):
	#print("set_schnittlinie")
	schnittlinie = _schnittlinie
	emit_signal("schnittlinie_changed")
	


func get_ziegel():
	if bereicheLatten == null || bereicheSchuere == null :
		return []
	
	
	var alleZiegelReihen = []
	var letztePosition = Vector2(0, -ziegelTyp.versatzY)
	
	for bereichLatten in bereicheLatten:
		var decklaenge = bereichLatten.decklaenge 
		for latteNr in range(bereichLatten.anzahl_latten):
			var ziegelReihe = get_ziegelreihe(letztePosition, latteNr)
			alleZiegelReihen.append(ziegelReihe)
			letztePosition.y += decklaenge
	
	return alleZiegelReihen

func get_ziegelreihe(letztePosition, latteNr):
	var ziegelReihe=[]
	var ziegelNummerInDerReihe = 1
	letztePosition.x = 0
	for bereichSchnuere in bereicheSchuere:
		var deckbreite = bereichSchnuere.deckbreite
		for schnurNr in range(bereichSchnuere.anzahl_schnuere):
			for ziegelNr in range(bereichSchnuere.anzahl_ziegel):
				var ziegel = createZiegel(letztePosition, latteNr+1, ziegelNummerInDerReihe)
				if ziegel.istGeschnitten:
					ziegelNummerInDerReihe += 1
					ziegelReihe.append(ziegel)
				letztePosition.x += deckbreite
	return ziegelReihe

func createZiegel(position, reihe, nummer):
	var ziegelClass = preload("res://Model/Ziegel.gd")
	var ziegel = ziegelClass.new(self, position)
	ziegel.reihe = reihe
	ziegel.nummer = nummer
	return ziegel

# Gibt positionen der linken oberen aller Ziegels relativ zu der Schnittline 
func get_ziegel_positionen():
	var ziegelPositionen = []
	var versatzY = ziegelTyp.versatzY
	var letztePosition = Vector2(0, 0)

	var bereicheLattenInverted = Array(bereicheLatten)
	bereicheLattenInverted.invert()
	var bereicheSchnuereInverted = Array(bereicheSchuere)
	bereicheSchnuereInverted.invert()
	
	if bereicheLattenInverted == null || bereicheSchnuereInverted == null :
		return []
	
	for bereichLatten in bereicheLattenInverted:
		var decklaenge = bereichLatten.decklaenge 
		for latteNr in range(bereichLatten.anzahl_latten):
			var y = letztePosition.y - decklaenge
			letztePosition.x = 0
			for bereichSchnuere in bereicheSchnuereInverted:
				var deckbreite = bereichSchnuere.deckbreite
				for schnurNr in range(bereichSchnuere.anzahl_schnuere):
					for ziegelNr in range(bereichSchnuere.anzahl_ziegel):
						var x = letztePosition.x - deckbreite
						letztePosition = Vector2(x,y)
						ziegelPositionen.append(letztePosition)
	
	var ziegelPositionenTranslated = []
	for position in ziegelPositionen:
		var newPostition = position + -letztePosition
		newPostition.y = newPostition.y - versatzY
		ziegelPositionenTranslated.append(newPostition)
	
	return ziegelPositionenTranslated




func set_grat(_istGrat):
	istGrat = _istGrat


############### STANDARDEINSTELLUNGEN  #####################
func init_ziegel_typ():
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
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var ziegel_typ = ziegelTypClass.new(data)
	self.set_ziegel_typ(ziegel_typ)

func init_bereiche_latten():
	var bereichClass = load("res://Model/LattenBereich.gd")
	var bereich = bereichClass.new(self.ziegelTyp)
	var bereiche = []
	bereiche.append(bereich)
	self.set_bereiche_latten(bereiche)
	

func init_bereiche_scnuere():
	var bereichClass = load("res://Model/SchnuereBereich.gd")
	var bereich = bereichClass.new(self.ziegelTyp)
	var bereiche = []
	bereiche.append(bereich)
	self.set_bereiche_schnuere(bereiche)


func init_schnittlinie():
	if bereicheLatten.size() > 0 && bereicheSchuere.size() > 0:
		var dach = classDach.new(self)
		set_schnittlinie(dach.get_schnittlinie()) 


func print_einstellungen():
	print("Anahl Schnuere-Bereiche ", bereicheSchuere.size())
	print("Anahl Latten-Bereiche ", bereicheLatten.size())