extends Button

var zeichenflaeche = null

# Model
var dach 
var einstellungen 

var classDach = preload("res://Model/Dach.gd")

var versatzLabel = null
var winkelVLabel = null
var obenUntenButton = null
var gratKehleButton = null

#var isOben = false



func _init(einstellungen = null):
	init(einstellungen)

func init(_einstellungen):
	if _einstellungen == null:
		var einstellungenClass = preload("res://Model/Einstellungen.gd")
		einstellungen = einstellungenClass.new()
	else:
		einstellungen = _einstellungen
	
	einstellungen.connect("schnittlinie_changed", self, "on_schnittlinie_changed")

func _ready():
	versatzLabel = get_node("PopupPanel/UserInput/Container/WinkelContainer/Versatz/VersatzValue")
	winkelVLabel = get_node("PopupPanel/UserInput/Container/WinkelContainer/VWinkel/WinkelValue")
	obenUntenButton = get_node("PopupPanel/UserInput/Container/SchnittpunktContainer/VBoxContainer/ObenUntenButton")
	gratKehleButton = get_node("PopupPanel/UserInput/Container/SchnittpunktContainer/VBoxContainer/GratKehleButton")
	zeichenflaeche = get_node("PopupPanel/Zeichenflaeche")
	
	init_dach()
	#print("update_dach")
	
	update_kehle_grat_label()
	update_winkel_label()
	update_oben_unten_label()
	set_user_input_position()
	
	

func on_schnittlinie_changed():
	init_dach()
	
func init_dach():
	dach = classDach.new(einstellungen)
	if zeichenflaeche != null:
		zeichenflaeche.init(dach)
		update_labels()
		set_zeichenflaeche_position()

func _on_ObenUntenButton_pressed():
	# isOben = !isOben
	zeichenflaeche.set_oben_unten(!zeichenflaeche.isOben)
	update_oben_unten_label()
	

func _on_NachLinksButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben_nach_links()
	else:
		dach.bewege_schnittlinie_unten_nach_links()
	update_labels()


func _on_NachRechtsButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben_nach_rechts()
	else:
		dach.bewege_schnittlinie_unten_nach_rechts()
	update_labels()


func _on_MinusHundertButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(-100)
	else:
		dach.bewege_schnittlinie_unten(-100)
	update_labels()



func _on_PlusHundertButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(100)
	else:
		dach.bewege_schnittlinie_unten(100)
	update_labels()



func _on_MinusZehnButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(-10)
	else:
		dach.bewege_schnittlinie_unten(-10)
	update_labels()


func _on_PlusZehnButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(10)
	else:
		dach.bewege_schnittlinie_unten(10)
	update_labels()



func _on_MinusEinsButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(-1)
	else:
		dach.bewege_schnittlinie_unten(-1)
	update_labels()

func _on_PlusEinsButton_pressed():
	if zeichenflaeche.isOben:
		dach.bewege_schnittlinie_oben(1)
	else:
		dach.bewege_schnittlinie_unten(1)
	update_labels()


func update_labels():
	var versatz
	if zeichenflaeche.isOben:
		versatz = dach.get_abstand_von_schnittlinie_zum_naechsten_schnur_oben()
	else:
		versatz = dach.get_abstand_von_schnittlinie_zum_naechsten_schnur_unten()
	
	versatzLabel.text = String(round(versatz))
	update_winkel_label()


func update_winkel_label():
	var winkel = einstellungen.schnittlinie.get_winkel_zu_vertikale()
	var winkelV = abs(min(180 - abs(winkel), abs(winkel)))
	var winkelVStr = "%0.1f" % winkelV
	winkelVLabel.text = String(winkelVStr)
	set_text(String(winkelVStr) + "°")


func update_kehle_grat_label():
	if dach.is_grat:
		gratKehleButton.text = "Grat"
	else: 
		gratKehleButton.text = "Kehle"


func update_oben_unten_label():
	if zeichenflaeche.isOben:
		obenUntenButton.text = "Oben"
	else :
		obenUntenButton.text = "Unten"


func _on_GratKehleButton_pressed():
	dach.set_grat(!dach.is_grat())
	update_kehle_grat_label()


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


func _on_SchnittlinieInput_pressed():
	get_node("PopupPanel").popup_centered()


func _notification(what):        
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
        get_node("PopupPanel").hide()


func _on_PopupPanel_popup_hide():
	einstellungen.schnittlinie = dach.get_schnittlinie()
	einstellungen.set_grat(dach.is_grat)
