extends Button

var bereichClass
var bereichInputScene
var ziegelTyp setget set_ziegel_typ

# model
var bereiche = {} setget bereiche_set


var bereicheContainer
var removeButton
var addButton
var slider
var ueberschrift
var selected_input_field

signal changed(bereiche_values)

func _init(bereichTyp = "L"):
	init(bereichTyp)

func init(bereichTyp = "L"):
	if bereichTyp == "S":
		bereichClass = preload("res://Model/SchnuereBereich.gd")
		bereichInputScene = preload("res://Einstellungen/SchnuereBereichInput.tscn")
		ueberschrift = "Deckbr.    Ziegel       Schnüre"
	else:
		bereichClass = preload("res://Model/LattenBereich.gd")
		bereichInputScene = preload("res://Einstellungen/LattenBereichInput.tscn")
		ueberschrift = "Deckl.       Latten"


func _ready():
	bereicheContainer = get_node("PopupPanel/Container/BereicheContainer")
	removeButton = get_node("PopupPanel/Container/AddRemoveContainer/RemoveButton")
	addButton = get_node("PopupPanel/Container/AddRemoveContainer/AddButton")
	slider = get_node("PopupPanel/VSlider")
	get_node("PopupPanel/Container/Ueberschrift").set_text(ueberschrift)
	set_ziegel_typ(get_beispiel_ziegel_typ())


func set_ziegel_typ(_ziegelTyp):
	ziegelTyp = _ziegelTyp
	bereiche_set([])

func bereiche_set(_bereiche):
	var nodes = bereicheContainer.get_children()
	for node in nodes:
		bereicheContainer.remove_child(node)
		
	bereiche.clear()
	for bereich in _bereiche:
		add_bereich(bereich)
		
	if self.bereiche.empty():
		_on_AddButton_pressed()
	
	set_text()


func _on_AddButton_pressed():
	var bereich = bereichClass.new(self.ziegelTyp)
	add_bereich(bereich)
	update_button_visibility()
	emit_signal("changed", bereiche.values())
	set_text()


func _on_RemoveButton_pressed():
	var anzahl_bereiche = bereicheContainer.get_child_count()
	var letzter_bereich = bereicheContainer.get_child(anzahl_bereiche - 1)
	bereicheContainer.remove_child(letzter_bereich)
	bereiche.erase(letzter_bereich)
	bereicheContainer.minimum_size_changed()
	update_button_visibility()
	emit_signal("changed", bereiche.values())
	set_text()


func update_button_visibility():
	addButton.set_hidden(false)
	addButton.set_hidden(bereiche.keys().size() > 4)
	removeButton.set_hidden(bereiche.keys().size() < 2)


func add_bereich(bereich):
	#print("addbereich")
	var bereichInput = bereichInputScene.instance()
	bereichInput.connect("selected", self, "_on_InputField_selected")
	bereichInput.connect("value_changed", self, "_on_bereich_value_changed")
	bereichInput.bereich = bereich
	bereiche[bereichInput] = bereich
	bereicheContainer.add_child(bereichInput)


func _on_DachdimensionInput_pressed():
	get_node("PopupPanel").popup_centered()


func _on_InputField_selected(input_field):
	self.selected_input_field = null
	for bereich in bereiche.keys():
		bereich.alle_abwaehlen_ausser(input_field)
	
	slider.set_min(input_field.anpassung_min)
	slider.set_max(input_field.anpassung_max)
	slider.set_step(input_field.anpassung_schritt)
	slider.set_value(input_field.anpassung_wert)
	
	self.selected_input_field = input_field


func _on_slider_value_changed( value ):
	if null != self.selected_input_field:
		self.selected_input_field.anpassung_wert = value


func _on_bereich_value_changed(bereich):
	# print("_on_bereich_value_changed")
	set_text()
	emit_signal("changed", bereiche.values())
	
func set_text():
	var gesamtbreite = 0
	var anzahl_bereiche = 0
	for b in bereiche.values():
		anzahl_bereiche += 1 
		gesamtbreite += b.get_berich_groesse()
		
	self.text = "" + String(gesamtbreite) + " | " + String(anzahl_bereiche)


func get_beispiel_ziegel_typ():
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
	var ziegelTypClass = load("res://Model/ZiegelTyp1.gd")
	var ziegel_typ = ziegelTypClass.new(data)
	return ziegel_typ