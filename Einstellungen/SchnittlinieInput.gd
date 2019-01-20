extends Container

var zeichenflaeche = null
var dach 

var classEinstellungen = preload("res://Model/Einstellungen2.gd")
var classDach = preload("res://Model/Dach1.gd")

var versatzLabel = null
var winkelVLabel = null
var obenUntenButton = null
var gratKehleButton = null

var isOben = false

signal oben_unten_changed(isOben)

func _ready():
	
	versatzLabel = get_node("UserInput/Container/WinkelContainer/Versatz/VersatzValue")
	winkelVLabel = get_node("UserInput/Container/WinkelContainer/VWinkel/WinkelValue")
	obenUntenButton = get_node("UserInput/Container/SchnittpunktContainer/VBoxContainer/ObenUntenButton")
	gratKehleButton = get_node("UserInput/Container/SchnittpunktContainer/VBoxContainer/GratKehleButton")
	
	dach = classDach.new(classEinstellungen.new()) 
	zeichenflaeche = get_node("Zeichenflaeche")
	zeichenflaeche.dach = dach
	_on_GratKehleButton_pressed()
	set_user_input_position()
	emit_signal("oben_unten_changed", isOben)


func _on_ObenUntenButton_pressed():
	isOben = !isOben
	if isOben:
		obenUntenButton.text = "Oben"
	else :
		obenUntenButton.text = "Unten"
	
	update_labels()
	emit_signal("oben_unten_changed", isOben)


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
	var versatz
	if isOben:
		versatz = dach.get_abstand_von_schnittlinie_zum_naechsten_schnur_oben()
	else:
		versatz = dach.get_abstand_von_schnittlinie_zum_naechsten_schnur_unten()
	
	versatzLabel.text = String(round(versatz))
	update_winkel()


func update_winkel():
	var winkel = dach.einstellungen.schnittlinie.get_winkel_zu_vertikale()
	var winkelV = abs(min(180 - abs(winkel), abs(winkel)))
	var winkelVStr = "%0.1f" % winkelV
	winkelVLabel.text = String(winkelVStr)


func _on_GratKehleButton_pressed():
	self.dach.set_grat(!self.dach.is_grat())
	
	if self.dach.is_grat:
		self.gratKehleButton.text = "Grat"
	else: 
		self.gratKehleButton.text = "Kehle"
	
	update_labels()
	
func set_user_input_position() :
	var userInput = get_node("UserInput")
	var userInputBreite = userInput.get_size().width
	var viewportSize = self.get_viewport_rect().size
	var viewPortBreite = viewportSize.width
	userInput.set_pos(Vector2(viewPortBreite - userInputBreite, 0))
	
	var zeichenfaeche = get_node("Zeichenflaeche")

	if dach != null :
		var bounding_box = dach.get_bounding_box()
		var x = (viewportSize.x - userInputBreite) / bounding_box.x  * 0.95
		var y = viewportSize.y / bounding_box.y  * 0.95
		var k = min(x, y)
		var pos = zeichenfaeche.get_pos()
		zeichenfaeche.set_pos(Vector2(0,0))
		zeichenfaeche.set_scale(Vector2(k,k))
		zeichenfaeche.set_pos(pos)