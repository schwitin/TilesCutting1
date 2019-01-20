extends VBoxContainer

# model
var einstellungen

var container
var lattenBereicheInput 
var schnuereBereicheInput
var schnittlinieInput

signal einstellungen_uebernehmen()

func _init():
	var einstellungenClass = preload("res://Model/Einstellungen2.gd")
	einstellungen = einstellungenClass.new()
	print("EinstellungenInput ", einstellungen)
	
	var bereicheInputScene = preload("res://Einstellungen/BereicheInput.tscn")
	lattenBereicheInput = bereicheInputScene.instance()
	lattenBereicheInput.init("L", einstellungen)
	schnuereBereicheInput = bereicheInputScene.instance()
	schnuereBereicheInput.init("S", einstellungen)
	
	var schnittlinieInput = preload("res://Einstellungen/SchnittlinieInput.tscn").instance()
	schnittlinieInput.init(einstellungen)
	
	#lattenBereicheInput.connect("changed", self, "_on_latten_bereiche_changed")
	#schnuereBereicheInput.connect("changed", self, "_on_schnuere_bereiche_changed")


func _ready():
	self.container = get_node("GridContainer")
	self.container.get_child(5).replace_by(self.schnuereBereicheInput)
	self.container.get_child(8).replace_by(self.lattenBereicheInput)
	self.container.get_child(11).replace_by(self.schnittlinieInput)
	#schnittlinieInput = get_node("GridContainer/SchnittlinieInput")
	#schnittlinieInput.set_einstellungen(einstellungen)
	
	# print("dach init")


func _on_ZiegelInput_changed( ziegelTyp ):
	print("_on_ZiegelInput_changed")
	#self.einstellungen.set_ziegel_typ(ziegelTyp)
	#self.lattenBereicheInput.set_ziegel_typ(self.einstellungen.ziegelTyp)
	#self.schnuereBereicheInput.set_ziegel_typ(self.einstellungen.ziegelTyp)


func _on_UebernehmenButton_pressed():
	#print("einstellungen_uebernehmen")
	emit_signal("einstellungen_uebernehmen")


func _on_latten_bereiche_changed(bereiche):
	print("_on_latten_bereiche_changed")
	#self.einstellungen.set_bereiche_latten(bereiche)


func _on_schnuere_bereiche_changed(bereiche):
	print("_on_schnuere_bereiche_changed")
	#self.einstellungen.set_bereiche_schnuere(bereiche)

