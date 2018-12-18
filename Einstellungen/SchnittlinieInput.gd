extends Container

var zeichenflaeche = null
var dach 

var classEinstellungen = preload("res://Model/Einstellungen1.gd")
var classDach = preload("res://Model/Dach1.gd")

var versatzLinksLabel = null
var versatzRechtsLabel = null
var winkelHLabel = null
var winkelVLabel = null
var obenUntenButton = null

var isOben = false

func _ready():
	versatzLinksLabel = get_node("UserInput/Container/SchnittpunktContainer/VBoxContainer/NavigationContainer/VersatzLinksLabel")
	versatzRechtsLabel = get_node("UserInput/Container/SchnittpunktContainer/VBoxContainer/NavigationContainer/VersatzRechtsLabel")
	winkelHLabel = get_node("UserInput/Container/WinkelContainer/HWinkel/WinkelValue")
	winkelVLabel = get_node("UserInput/Container/WinkelContainer/VWinkel/WinkelValue")
	obenUntenButton = get_node("UserInput/Container/SchnittpunktContainer/VBoxContainer/ObenUntenButton")
	
	dach = classDach.new(classEinstellungen.new()) 
	zeichenflaeche = get_node("Zeichenflaeche")
	zeichenflaeche.dach = dach
	update_labels()


func _on_ObenUntenButton_pressed():
	isOben = !isOben
	if isOben:
		obenUntenButton.text = "Oben"
	else :
		obenUntenButton.text = "Unten"


func _on_NachLinksButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben_nach_links()
	else:
		dach.bewege_schnittlinie_unten_nach_links()
	update_labels()


func _on_NachRechtsButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben_nach_rechts()
	else:
		dach.bewege_schnittlinie_unten_nach_rechts()
	update_labels()


func _on_MinusHundertButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben(-100)
	else:
		dach.bewege_schnittlinie_unten(-100)
	update_labels()



func _on_PlusHundertButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben(100)
	else:
		dach.bewege_schnittlinie_unten(100)
	update_labels()



func _on_MinusZehnButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben(-10)
	else:
		dach.bewege_schnittlinie_unten(-10)
	update_labels()


func _on_PlusZehnButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben(10)
	else:
		dach.bewege_schnittlinie_unten(10)
	update_labels()



func _on_MinusEinsButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben(-1)
	else:
		dach.bewege_schnittlinie_unten(-1)
	update_labels()

func _on_PlusEinsButton_pressed():
	if isOben:
		dach.bewege_schnittlinie_oben(1)
	else:
		dach.bewege_schnittlinie_unten(1)
	update_labels()



func update_labels():
	update_versatz_zum_linken_sprungpunkt(dach.get_versatz_zum_linken_sprungpunkt_oben())
	update_versatz_zum_rechten_sprungpunkt(dach.get_versatz_zum_rechten_sprungpunkt_oben())
	update_versatz_zum_linken_sprungpunkt(dach.get_versatz_zum_linken_sprungpunkt_unten())
	update_versatz_zum_rechten_sprungpunkt(dach.get_versatz_zum_rechten_sprungpunkt_unten())
	update_winkel()


func update_versatz_zum_linken_sprungpunkt(versatz):
	versatzLinksLabel.text = String(round(versatz))


func update_versatz_zum_rechten_sprungpunkt(versatz):
	versatzRechtsLabel.text = String(round(versatz))


func update_winkel():
	var winkel = dach.einstellungen.schnittlinie.get_winkel_zu_vertikale()
	var winkelH = abs(min(180 - abs(winkel), abs(winkel)))
	var winkelV = 90.0 - winkelH
	var winkelHStr = "%0.1f" % winkelH
	var winkelVStr = "%0.1f" % winkelV
	winkelHLabel.text = String(winkelHStr)
	winkelVLabel.text = String(winkelVStr)
