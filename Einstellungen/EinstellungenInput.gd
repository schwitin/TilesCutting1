extends PanelContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var einstellungen
var container
var lattenBereicheInput 
var schnuereBereicheInput

func _init():
	var einstellungenClass = preload("res://Model/Einstellungen2.gd")
	self.einstellungen = einstellungenClass.new()

func _ready():
	self.container = get_node("GridContainer")
	self.lattenBereicheInput = get_node("GridContainer/LattenBereichInput")
	self.schnuereBereicheInput = get_node("GridContainer/SchnuereBereichInput")
	
	var bereicheInputScene = load("res://Einstellungen/BereicheInput.tscn")
	var lattenBereicheInput = bereicheInputScene.instance()
	lattenBereicheInput.init("L")
	var schnuereBereicheInput = bereicheInputScene.instance()
	schnuereBereicheInput.init("S")
	
	self.lattenBereicheInput.replace_by(lattenBereicheInput)
	self.schnuereBereicheInput.replace_by(schnuereBereicheInput)
	
	self.lattenBereicheInput = lattenBereicheInput
	self.schnuereBereicheInput = schnuereBereicheInput	
	
	update_nodes()
	


func _on_ZiegelInput_changed( ziegelTyp ):
	print("_on_ZiegelInput_changed")
	self.einstellungen.ziegelTyp = ziegelTyp
	update_nodes()

func update_nodes():
	if self.lattenBereicheInput != null:
		self.lattenBereicheInput.set_ziegel_typ(self.einstellungen.ziegelTyp)
	
	if self.schnuereBereicheInput != null:
		self.schnuereBereicheInput.set_ziegel_typ(self.einstellungen.ziegelTyp)
	 