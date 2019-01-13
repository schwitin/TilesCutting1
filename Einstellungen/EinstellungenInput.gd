extends VBoxContainer

# model
var einstellungen

var container
var lattenBereicheInput 
var schnuereBereicheInput

signal einstellungen_uebernehmen()

func _init():
	var einstellungenClass = preload("res://Model/Einstellungen2.gd")
	self.einstellungen = einstellungenClass.new()
	
	var bereicheInputScene = preload("res://Einstellungen/BereicheInput.tscn")
	lattenBereicheInput = bereicheInputScene.instance()
	lattenBereicheInput.init("L")
	schnuereBereicheInput = bereicheInputScene.instance()
	schnuereBereicheInput.init("S")

func _ready():
	self.container = get_node("GridContainer")
	self.container.get_child(5).replace_by(schnuereBereicheInput)
	self.container.get_child(8).replace_by(lattenBereicheInput)

	
	#update_nodes()




func _on_ZiegelInput_changed( ziegelTyp ):
	print("_on_ZiegelInput_changed")
	self.einstellungen.ziegelTyp = ziegelTyp
	self.lattenBereicheInput.set_ziegel_typ(self.einstellungen.ziegelTyp)
	self.schnuereBereicheInput.set_ziegel_typ(self.einstellungen.ziegelTyp)


func _on_UebernehmenButton_pressed():
	print("einstellungen_uebernehmen")
	emit_signal("einstellungen_uebernehmen")
