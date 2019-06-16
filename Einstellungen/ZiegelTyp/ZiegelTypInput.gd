extends Button

# model
var ziegelTyp setget set_ziegel_typ
var items
var ziegelTypenDAO

signal changed(ziegelTyp)

func _init():
	var classZiegelTypDAO = preload("res://Model/ZiegelTypDAO.gd")
	ziegelTypenDAO = classZiegelTypDAO.new()


func _ready():
	items = get_node("Items")
	items.clear()
	
	for ziegelTyp in ziegelTypenDAO.ziegelTypen:
		var text = ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"
		items.add_item(text)
	
	if self.ziegelTyp == null:
		set_ziegel_typ(ziegelTypenDAO.ziegelTypen[0])


func set_ziegel_typ(_ziegelTyp) :
	ziegelTyp = _ziegelTyp
	self.text = get_beschriftung(ziegelTyp)
	


func get_beschriftung(ziegelTyp) : 
	return ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"


func _on_Button_pressed():
	items.popup_centered()


func _on_Items_item_pressed( ID ):
	var selectedZiegelTyp = ziegelTypenDAO.ziegelTypen[ID]
	if selectedZiegelTyp != ziegelTyp:
		set_ziegel_typ(selectedZiegelTyp)
		emit_signal("changed", ziegelTyp)
