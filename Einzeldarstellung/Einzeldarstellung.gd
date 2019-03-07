extends Node

var einstellungen
var aktuellerZiegel setget set_aktueller_ziegel

signal einzeldarstellung_pressed()
signal einzeldarstellung_verlassen()

signal naechster_ziegel(aktuellerZiegel)
signal vorheriger_ziegel(aktuellerZiegel)
signal maschine_zenter()
signal maschine_kalibrierung()
signal maschnie_position(position)


func _init():
	# Wir brauchen das, damit der Scene-Editor funktioniert.
	# Einstellungen werden von der Root-Scene neu gesetzt und dieses hier verworfen
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	init(einstellungenClass.new())


func init(_einstellungen):
	einstellungen = _einstellungen


func _ready():
	if aktuellerZiegel == null:
		emit_signal("naechster_ziegel", null)


func set_aktueller_ziegel(_aktuellerZiegel):
	aktuellerZiegel = _aktuellerZiegel
	var zeichenflaeche = get_node("Container/Zeichenflaeche")
	zeichenflaeche.set_ziegel(aktuellerZiegel)
	update_ziegel_nummer()
	update_distanz_zum_zentrum()
	update_winkel()


func update_ziegel_nummer():
	var ziegelNr = get_node("Container/UserInput/NaechsterVorheriger/Wert")
	ziegelNr.text = String(aktuellerZiegel.nummer)


func update_distanz_zum_zentrum():
	var schnittlinie = aktuellerZiegel.einstellungen.schnittlinie
	var zentrum = aktuellerZiegel.get_zentrum()
	var normale = schnittlinie.get_normale(zentrum)
	var normaleLaenge = normale.p1.distance_to(normale.p2)
	var distanzZumZentrumNode = get_node("Container/UserInput/DistanzZuMitte/Wert")
	distanzZumZentrumNode.text = String(round(normaleLaenge))


func update_winkel():
	var winkel = aktuellerZiegel.einstellungen.schnittlinie.get_winkel_zu_vertikale()
	var winkelV = abs(min(180 - abs(winkel), abs(winkel)))
	var winkelVStr = "%0.1f" % winkelV
	var winkelNode = get_node("Container/UserInput/Winkel/Wert")
	winkelNode.text = String(winkelVStr)


func _on_Einzeldarstellung_pressed():
	emit_signal("einzeldarstellung_pressed")


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST :
		#print("einzeldarstellung_verlassen")
		emit_signal("einzeldarstellung_verlassen")


func _on_Vorheriger_pressed():
	emit_signal("vorheriger_ziegel", aktuellerZiegel)


func _on_Naechster_pressed():
	emit_signal("naechster_ziegel", aktuellerZiegel)


func _on_MaschineZenter_pressed():
	emit_signal("maschine_zenter")


func _on_MaschinePosition_pressed():
	emit_signal("maschnie_position")


func _on_MaschineKalibrierung_pressed():
	emit_signal("maschine_kalibrierung")
