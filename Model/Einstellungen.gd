extends Resource

var name = null
var dachName = null
var ziegelTyp = null setget set_ziegel_typ
var bereicheSchuere = [] setget set_bereiche_schnuere
var bereicheLatten = [] setget set_bereiche_latten
var schnittlinie = null setget set_schnittlinie
var istGrat = true setget set_grat

var zeigelTypenDAO


func _init(_dachName, _name):
	var classZiegelTypDAO = preload("res://Model/ZiegelTypDAO.gd")
	zeigelTypenDAO = classZiegelTypDAO.new()
	init_ziegel_typ()
	dachName = _dachName
	name = _name
	

func init(einstellungenDictionary):
	load_ziegel_typ(einstellungenDictionary)
	load_bereiche_latten(einstellungenDictionary)
	load_bereiche_schnuere(einstellungenDictionary)
	load_schnittlinie(einstellungenDictionary)
	set_grat(einstellungenDictionary.istGrat)
	name = einstellungenDictionary.name
	dachName = einstellungenDictionary.dachName


func set_ziegel_typ(_ziegelTyp):
	ziegelTyp = _ziegelTyp
	bereicheSchuere.clear()
	bereicheSchuere.clear()
	init_bereiche_latten()
	init_bereiche_scnuere()
	init_schnittlinie()


func set_bereiche_schnuere(bereiche):
	bereicheSchuere = bereiche


func set_bereiche_latten(bereiche):
	bereicheLatten = bereiche


func set_schnittlinie(_schnittlinie):
	schnittlinie = _schnittlinie


func set_grat(_istGrat):
	if istGrat != _istGrat:
		istGrat = _istGrat


############### STANDARDEINSTELLUNGEN  #####################
func init_ziegel_typ():
	set_ziegel_typ(zeigelTypenDAO.ziegelTypen[0])

func load_ziegel_typ(einstellungenDictionary):
	var d = einstellungenDictionary
	var ziegelTypName = d.ziegelTyp
	var _ziegelTyp = zeigelTypenDAO.get_ziegel_typ(ziegelTypName)
	ziegelTyp = _ziegelTyp


func init_bereiche_latten():
	var bereichClass = load("res://Model/LattenBereich.gd")
	var bereich = bereichClass.new(ziegelTyp)
	var bereiche = []
	bereiche.append(bereich)
	set_bereiche_latten(bereiche)
	

func load_bereiche_latten(einstellungenDictionary):
	var d = einstellungenDictionary
	var bereichClass = load("res://Model/LattenBereich.gd")
	var bereiche = []
	for lBereich in d.bereicheLatten:
		var bereich = bereichClass.new(ziegelTyp)
		bereich.init(lBereich)
		bereiche.append(bereich)
	set_bereiche_latten(bereiche)


func init_bereiche_scnuere():
	var bereichClass = load("res://Model/SchnuereBereich.gd")
	var bereich = bereichClass.new(ziegelTyp)
	var bereiche = []
	bereiche.append(bereich)
	set_bereiche_schnuere(bereiche)


func load_bereiche_schnuere(einstellungenDictionary):
	var d = einstellungenDictionary
	var bereichClass = load("res://Model/SchnuereBereich.gd")
	var bereiche = []
	for sBereich in d.bereicheSchuere:
		var bereich = bereichClass.new(ziegelTyp)
		bereich.init(sBereich)
		bereiche.append(bereich)
	set_bereiche_schnuere(bereiche)


func init_schnittlinie():
	if bereicheLatten.size() > 0 && bereicheSchuere.size() > 0:
		# wir setzen die schnittlinie auf null damit diese neu
		# berechnet wird. 
		schnittlinie = null 
		var classDach = preload("res://Model/Dach.gd")
		var dach = classDach.new(self)
		set_schnittlinie(dach.get_schnittlinie()) 


func load_schnittlinie(einstellungenDictionary):
	var d = einstellungenDictionary
	var classLinie = load("res://Model/Linie.gd")
	var linie = classLinie.new(Vector2(0,0), Vector2(0,0))
	linie.init(d.schnittlinie)
	set_schnittlinie(linie)


func print_einstellungen():
	print("Anahl Schnuere-Bereiche ", bereicheSchuere.size())
	print("Anahl Latten-Bereiche ", bereicheLatten.size())


func to_dictionary():
	var lBereiche = []
	for bereichLatten in bereicheLatten:
		lBereiche.append(bereichLatten.to_dictionary())
	
	var sBereiche = []
	for bereichSchnuere in bereicheSchuere:
		sBereiche.append(bereichSchnuere.to_dictionary())

	var d = {
		name = name,
		dachName = dachName,
		ziegelTyp = ziegelTyp.name,
		istGrat = istGrat,
		bereicheLatten = lBereiche,
		bereicheSchuere = sBereiche,
		schnittlinie = schnittlinie.to_dictionary(),
	}
	return d