extends Node

var aktuellerZiegel setget set_aktueller_ziegel

signal einzeldarstellung_pressed()
signal einzeldarstellung_verlassen()

signal naechste_reihe(aktuellerZiegel)
signal vorherige_reihe(aktuellerZiegel)
signal naechste_nummer(aktuellerZiegel)
signal vorherige_nummer(aktuellerZiegel)


func _ready():
	# Unkommentieren, wenn dieses Szene einzeln zum Testen gestertet wird
	# test()
	if aktuellerZiegel == null:
		emit_signal("naechste_reihe", null)
	
#	global.connect("data_received", self, "_on_data_received")

func test():
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	var einstellungen = einstellungenClass.new("dummy")
	var ziegelClass = preload("res://Model/Ziegel.gd")	
	var ziegel = ziegelClass.new(einstellungen, Vector2(0,0))
	ziegel.nummer = 1
	ziegel.reihe = 1
	ziegel.istGeschnitten = true
	set_aktueller_ziegel(ziegel)


func set_aktueller_ziegel(_aktuellerZiegel):
	aktuellerZiegel = _aktuellerZiegel
	var zeichenflaeche = get_node("Container/Zeichenflaeche")
	zeichenflaeche.set_ziegel(aktuellerZiegel)
	update_ziegel_nummer()
	update_ziegel_reihe()
	update_distanz_zum_zentrum()
	update_winkel()


func update_ziegel_nummer():
	var node = get_node("Container/UserInput/NaechsteVorherigeNummer/Wert")
	node.text = String(aktuellerZiegel.nummer)


func update_ziegel_reihe():
	var node = get_node("Container/UserInput/NaechsteVorherigeReihe/Wert")
	node.text = String(aktuellerZiegel.reihe)

func update_distanz_zum_zentrum():
	var distanz = aktuellerZiegel.get_distanz_von_schnittlinie_zum_zentrum()
	var distanzZumZentrumNode = get_node("Container/UserInput/DistanzZuMitte/Wert")
	distanzZumZentrumNode.text = String(round(distanz))


func update_winkel():
	var winkelV = aktuellerZiegel.get_winkel_zu_vertikale()
	var winkelVStr = "%0.1f" % winkelV
	var winkelNode = get_node("Container/UserInput/Winkel/Wert")
	winkelNode.text = String(winkelVStr)


func _on_Einzeldarstellung_pressed():
	emit_signal("einzeldarstellung_pressed")


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST :
		#print("einzeldarstellung_verlassen")
		emit_signal("einzeldarstellung_verlassen")


func _on_VorherigeReihe_pressed():
	emit_signal("vorherige_reihe", aktuellerZiegel)


func _on_NaechsteReihe_pressed():
	emit_signal("naechste_reihe", aktuellerZiegel)


func _on_NaechsteNummer_pressed():
	emit_signal("naechste_nummer", aktuellerZiegel)


func _on_VorherigeNummer_pressed():
	emit_signal("vorherige_nummer", aktuellerZiegel)



#func _on_data_received(data_received):
#	if "vorheriger" in data_received:
#		emit_signal("naechster_ziegel", aktuellerZiegel)
#	else:
#		emit_signal("vorheriger_ziegel", aktuellerZiegel)

