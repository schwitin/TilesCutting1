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
signal grat_kehle_changed()

var classDach = preload("res://Model/Dach.gd")


func _init():
	init_ziegel_typ()


func set_ziegel_typ(_ziegelTyp):
	ziegelTyp = _ziegelTyp
	bereicheSchuere.clear()
	bereicheSchuere.clear()
	init_bereiche_latten()
	init_bereiche_scnuere()
	emit_signal("ziegel_typ_changed")


func set_bereiche_schnuere(bereiche):
	bereicheSchuere = bereiche
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


func set_grat(_istGrat):
	if istGrat != _istGrat:
		istGrat = _istGrat
		emit_signal("grat_kehle_changed")


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
		# wir setzen die schnittlinie auf null damit diese neu
		# berechnet wird. 
		schnittlinie = null 
		var dach = classDach.new(self)
		set_schnittlinie(dach.get_schnittlinie()) 


func print_einstellungen():
	print("Anahl Schnuere-Bereiche ", bereicheSchuere.size())
	print("Anahl Latten-Bereiche ", bereicheLatten.size())