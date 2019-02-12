extends Button

var bereichClass
var bereichInputScene

# model
var bereiche = {} #setget bereiche_set

var bereichTyp
var einstellungen

var bereicheContainer
var removeButton
var addButton
var slider
var ueberschrift
var selected_input_field

signal changed(bereiche_values)

func _init(bereichTyp = "L", einstellungen = null):
	init(bereichTyp, einstellungen)

func init(_bereichTyp, _einstellungen):
	bereichTyp = _bereichTyp
	if bereichTyp == "S":
		bereichClass = preload("res://Model/SchnuereBereich.gd")
		bereichInputScene = preload("res://Einstellungen/SchnuereBereichInput.tscn")
		ueberschrift = "Deckbr.    Ziegel       Schnüre"
	else:
		bereichClass = preload("res://Model/LattenBereich.gd")
		bereichInputScene = preload("res://Einstellungen/LattenBereichInput.tscn")
		ueberschrift = "Deckl.       Latten"
	
	if _einstellungen == null:
		var einstellungenClass = preload("res://Model/Einstellungen.gd")
		einstellungen = einstellungenClass.new()
	else:
		einstellungen = _einstellungen
		#print("BereicheInput ", einstellungen)



func _ready():
	bereicheContainer = get_node("PopupPanel/Container/BereicheContainer")
	removeButton = get_node("PopupPanel/Container/AddRemoveContainer/RemoveButton")
	addButton = get_node("PopupPanel/Container/AddRemoveContainer/AddButton")
	slider = get_node("PopupPanel/VSlider")
	get_node("PopupPanel/Container/Ueberschrift").set_text(ueberschrift)
	set_text()
	

func get_bereiche():
	if bereichTyp == "S":
		return einstellungen.bereicheSchuere
	else:
		return einstellungen.bereicheLatten

func update_view():
	var nodes = bereicheContainer.get_children()
	for node in nodes:
		bereicheContainer.remove_child(node)
	
	bereiche.clear()
	
	for bereich in get_bereiche():
		add_bereich(bereich)
	
	update_button_visibility()
	set_text()
	

func _on_AddButton_pressed():
	var bereich = bereichClass.new(einstellungen.ziegelTyp)
	add_bereich(bereich)
	update_button_visibility()


func _on_RemoveButton_pressed():
	var bereichInput = bereicheContainer.get_children().back()
	bereicheContainer.remove_child(bereichInput)
	bereicheContainer.minimum_size_changed()
	#print(bereiche.has(bereichInput))
	bereiche.erase(bereichInput)
	update_button_visibility()


func update_button_visibility():
	addButton.set_hidden(false)
	addButton.set_hidden(bereiche.keys().size() > 4)
	removeButton.set_hidden(bereiche.keys().size() < 2)


func add_bereich(bereich):
	# print(bereich)
	var bereichInput = bereichInputScene.instance()
	bereichInput.connect("selected", self, "_on_InputField_selected")
	bereichInput.set_bereich(bereich)
	bereiche[bereichInput] = bereich
	bereicheContainer.add_child(bereichInput)


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

	
func set_text():
	var gesamtbreite = 0
	var anzahl_bereiche = 0
	for b in get_bereiche():
		anzahl_bereiche += 1 
		gesamtbreite += b.get_berich_groesse()
		
	self.text = "" + String(gesamtbreite) + " | " + String(anzahl_bereiche)


func _on_DachdimensionInput_pressed():
	update_view()
	get_node("PopupPanel").popup_centered()


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		get_node("PopupPanel").hide()


func _on_PopupPanel_popup_hide():
	var b = [] # bereiche.values() sind nicht sortiert
	for bereichInput in bereicheContainer.get_children():
		b.append(bereiche[bereichInput])
	
	if bereichTyp == "S":
		einstellungen.set_bereiche_schnuere(b)
	else:
		einstellungen.set_bereiche_latten(b)
			    
	set_text()

