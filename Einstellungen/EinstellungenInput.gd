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
	#print("EinstellungenInput ", einstellungen)
	
	var bereicheInputScene = preload("res://Einstellungen/BereicheInput.tscn")
	lattenBereicheInput = bereicheInputScene.instance()
	lattenBereicheInput.init("L", einstellungen)
	schnuereBereicheInput = bereicheInputScene.instance()
	schnuereBereicheInput.init("S", einstellungen)
	
	schnittlinieInput = preload("res://Einstellungen/SchnittlinieInput.tscn").instance()
	schnittlinieInput.init(einstellungen)
	

func _ready():
	self.container = get_node("GridContainer")
	self.container.get_child(5).replace_by(self.schnuereBereicheInput)
	self.container.get_child(8).replace_by(self.lattenBereicheInput)
	self.container.get_child(11).replace_by(self.schnittlinieInput)


func _on_UebernehmenButton_pressed():
	#print("einstellungen_uebernehmen")
	emit_signal("einstellungen_uebernehmen")

