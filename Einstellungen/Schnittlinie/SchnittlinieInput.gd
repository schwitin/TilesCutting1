extends Button

var zeichenflaeche = null

# Model
var dach 
var einstellungen 

signal schnittlinie_changed

var isDirty = false

func _ready():
	#test()
	pass


func test():
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	var einstellungen = einstellungenClass.new("dummy dach", "dummy")
	init(einstellungen)


func init(_einstellungen):
	einstellungen = _einstellungen
	update_control()


func update_control():
	zeichenflaeche = get_node("PopupPanel/Zeichenflaeche")
	var classDach = preload("res://Model/Dach.gd")
	dach = classDach.new(einstellungen)
	zeichenflaeche.init(dach)
	
	update_versatz_und_winkel_labels()
	update_kehle_grat_label()
	update_oben_unten_label()
	update_text()
	set_user_input_position()
	set_zeichenflaeche_position()


func update_versatz_und_winkel_labels():
	update_versatz_label()
	update_winkel_label()
	isDirty = true


func update_versatz_label():
	var versatz
	if zeichenflaeche.isOben:
		versatz = dach.get_abstand_von_schnittlinie_zum_naechsten_schnur_oben()
	else:
		versatz = dach.get_abstand_von_schnittlinie_zum_naechsten_schnur_unten()
	
	var versatzLabel = get_node("PopupPanel/UserInput/Container/WinkelContainer/Versatz/VersatzValue")
	versatzLabel.text = String(round(versatz))


func update_winkel_label():
	var winkel = get_winkel()
	var winkelVLabel = get_node("PopupPanel/UserInput/Container/WinkelContainer/VWinkel/WinkelValue")
	winkelVLabel.text = winkel


func update_text():
	var winkel = get_winkel()
	set_text(winkel + "°")

func get_winkel():
	var winkel = einstellungen.schnittlinie.get_winkel_zu_vertikale()
	var winkelV = abs(min(180 - abs(winkel), abs(winkel)))
	var winkelVStr = "%0.1f" % winkelV
	return winkelVStr
	
func update_kehle_grat_label():
	var gratKehleButton = get_node("PopupPanel/UserInput/Container/SchnittpunktContainer/VBoxContainer/GratKehleButton")
	if dach.is_grat:
		gratKehleButton.text = "Grat"
	else: 
		gratKehleButton.text = "Kehle"
	isDirty = true


func update_oben_unten_label():
	var obenUntenButton = get_node("PopupPanel/UserInput/Container/SchnittpunktContainer/VBoxContainer/ObenUntenButton")
	if zeichenflaeche.isOben:
		obenUntenButton.text = "Oben"
	else :
		obenUntenButton.text = "Unten"


func set_zeichenflaeche_position():
	var bounding_box = dach.get_bounding_box()
	var userInput = get_node("PopupPanel/UserInput")
	var userInputBreite = userInput.get_size().width
	var viewportSize = self.get_viewport_rect().size
	var x = (viewportSize.x - userInputBreite) / bounding_box.x  * 0.95
	var y = viewportSize.y / bounding_box.y  * 0.95
	var k = min(x, y)
	var pos = zeichenflaeche.get_pos()
	zeichenflaeche.set_pos(Vector2(0,0))
	zeichenflaeche.set_scale(Vector2(k,k))
	zeichenflaeche.set_pos(pos)


func set_user_input_position():
	var userInput = get_node("PopupPanel/UserInput")
	var userInputBreite = userInput.get_size().width
	var viewportSize = self.get_viewport_rect().size
	var viewPortBreite = viewportSize.width
	userInput.set_pos(Vector2(viewPortBreite - userInputBreite, 0))


func _on_ObenUntenButton_pressed():
	# isOben = !isOben
	zeichenflaeche.set_oben_unten(!zeichenflaeche.isOben)
	update_oben_unten_label()


func _on_NachLinksButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben_nach_links()
	else:
		dach.bewege_schnittlinie_unten_nach_links()
	update_versatz_und_winkel_labels()


func _on_NachRechtsButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben_nach_rechts()
	else:
		dach.bewege_schnittlinie_unten_nach_rechts()
	update_versatz_und_winkel_labels()


func _on_MinusHundertButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(-100)
	else:
		dach.bewege_schnittlinie_unten(-100)
	update_versatz_und_winkel_labels()


func _on_PlusHundertButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(100)
	else:
		dach.bewege_schnittlinie_unten(100)
	update_versatz_und_winkel_labels()


func _on_MinusZehnButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(-10)
	else:
		dach.bewege_schnittlinie_unten(-10)
	update_versatz_und_winkel_labels()


func _on_PlusZehnButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(10)
	else:
		dach.bewege_schnittlinie_unten(10)
	update_versatz_und_winkel_labels()


func _on_MinusEinsButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(-1)
	else:
		dach.bewege_schnittlinie_unten(-1)
	update_versatz_und_winkel_labels()

func _on_PlusEinsButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(1)
	else:
		dach.bewege_schnittlinie_unten(1)
	update_versatz_und_winkel_labels()


func _on_SchnittlinieInput_pressed():
	
	get_node("PopupPanel").popup_centered()


func _on_GratKehleButton_pressed():
	dach.set_grat(!dach.is_grat())
	update_kehle_grat_label()


func _on_PopupPanel_popup_hide():
	if isDirty:
		einstellungen.set_grat(dach.is_grat)
		einstellungen.schnittlinie = dach.get_schnittlinie()
		update_text()
		emit_signal("schnittlinie_changed")