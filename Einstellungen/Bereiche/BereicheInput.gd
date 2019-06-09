extends Button

var einstellungen

# Key  : LattenBereichInput oder SchnuereBereichInput
# Value: LattenBereich oder SchnuereBereich
var bereiche = {}

var bereichTyp
var bereichClass
var bereichInputScene

var selectedInputField

signal schnuere_oder_latten_bereiche_changed

# Gibt an, ob Bereiche geändert wurden
var isDirty = false

func _ready():
	#test()
	pass


func test():
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	var einstellungen = einstellungenClass.new("dummy")
	var bereichTyp = "S"
	init(bereichTyp, einstellungen)


# soll im _ready() aufgerufen werden
func init(_bereichTyp, _einstellungen):
	bereichTyp = _bereichTyp
	einstellungen = _einstellungen
	update_text()
	var ueberschriftNode = get_node("PopupPanel/Container/Ueberschrift")
	
	if bereichTyp == "S":
		bereichClass = preload("res://Model/SchnuereBereich.gd")
		bereichInputScene = preload("res://Einstellungen/Bereiche/SchnuereBereichInput.tscn")
		ueberschriftNode.set_text("Deckbr.    Ziegel       Schnüre")
	else:
		bereichClass = preload("res://Model/LattenBereich.gd")
		bereichInputScene = preload("res://Einstellungen/Bereiche/LattenBereichInput.tscn")
		ueberschriftNode.set_text("Deckl.       Latten")


func get_bereiche():
	if bereichTyp == "S":
		return einstellungen.bereicheSchuere
	else:
		return einstellungen.bereicheLatten


func get_bereiche_container():
	return get_node("PopupPanel/Container/BereicheContainer")


func clear_bereiche_view():
	var bereicheContainer = get_bereiche_container()
	var nodes = bereicheContainer.get_children()
	for node in nodes:
		bereicheContainer.remove_child(node)
	bereiche.clear()


func init_bereiche_view():
	for bereich in get_bereiche():
		add_bereich(bereich)
	
	get_bereiche_container().get_children().front().ersten_eingabefeld_auswaelen()	
	update_button_visibility()


func add_bereich(bereich):
	# print(bereich)
	var bereichInput = bereichInputScene.instance()
	bereichInput.connect("selected", self, "_on_InputField_selected")
	bereichInput.set_bereich(bereich)
	bereiche[bereichInput] = bereich
	get_bereiche_container().add_child(bereichInput)


func update_button_visibility():
	var removeButton = get_node("PopupPanel/Container/AddRemoveContainer/RemoveButton")
	var addButton = get_node("PopupPanel/Container/AddRemoveContainer/AddButton")
	addButton.set_hidden(bereiche.keys().size() > 4)
	removeButton.set_hidden(bereiche.keys().size() < 2)


func update_text():
	var gesamtbreite = 0
	var anzahl_bereiche = 0
	for b in get_bereiche():
		anzahl_bereiche += 1 
		gesamtbreite += b.get_berich_groesse()
		
	self.text = "" + String(gesamtbreite) + " | " + String(anzahl_bereiche)


func _on_InputField_selected(input_field):
	selectedInputField = null
	for bereich in bereiche.keys():
		bereich.alle_abwaehlen_ausser(input_field)
	
	var slider = get_node("PopupPanel/VSlider")
	slider.set_min(input_field.min_wert)
	slider.set_max(input_field.max_wert)
	slider.set_step(input_field.anpassung_schritt)
	slider.set_value(input_field.wert)
	selectedInputField = input_field


func _on_slider_value_changed( value ):
	if null != selectedInputField:
		selectedInputField.set_wert(value)
		isDirty = true


func _on_AddButton_pressed():
	var bereich = bereichClass.new(einstellungen.ziegelTyp)
	add_bereich(bereich)
	get_bereiche().append(bereich)
	update_button_visibility()
	isDirty = true


func _on_RemoveButton_pressed():
	var bereicheContainer = get_bereiche_container()
	var bereichInput = bereicheContainer.get_children().back()
	bereicheContainer.remove_child(bereichInput)
	bereicheContainer.minimum_size_changed()
	var bereich = bereiche[bereichInput]
	get_bereiche().erase(bereich)
	bereiche.erase(bereichInput)
	update_button_visibility()
	isDirty = true

func _on_DachdimensionInput_pressed():
	init_bereiche_view()
	get_node("PopupPanel").popup_centered()


func _on_PopupPanel_popup_hide():
	#update_einstellungen()
	emit_signal_if_changed()
	clear_bereiche_view()
	update_text()


func emit_signal_if_changed():
	if isDirty:
		emit_signal("schnuere_oder_latten_bereiche_changed")
		isDirty = false


func update_einstellungen():
	if isDirty:
		var b = [] # bereiche.values() sind nicht sortiert
		for bereichInput in get_bereiche_container().get_children():
			b.append(bereiche[bereichInput])
		
		if bereichTyp == "S":
			einstellungen.set_bereiche_schnuere(b)
		else:
			einstellungen.set_bereiche_latten(b)
		isDirty = false