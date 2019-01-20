extends Button

# model
var ziegelTyp setget set_ziegel_typ

var ziegelTypen
var items

signal changed(ziegelTyp)


func _init():
	ziegelTypen = get_ziegel_typen()


func _ready():
	items = get_node("Items")
	items.clear()
	
	for ziegelTyp in ziegelTypen:
		var text = ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"
		items.add_item(text)
	
	if self.ziegelTyp == null:
		set_ziegel_typ(ziegelTypen[0])
		emit_signal("changed", ziegelTyp)


func set_ziegel_typ(_ziegelTyp) :
	ziegelTyp = _ziegelTyp
	self.text = get_text(ziegelTyp)


func _on_Button_pressed():
	items.popup_centered()


func get_ziegel_typen():
	var zeigelTypen = []
	var ziegelTypClass = load("res://Model/ZiegelTyp1.gd")
	var file = File.new()
	file.open("res://Resources/ZiegelTyp.json", file.READ)
	var dict = {}
	var parse_result = dict.parse_json(file.get_as_text())
	file.close()
	
	if parse_result == OK:
		for typ in dict.ZiegelTypList :
			zeigelTypen.append(ziegelTypClass.new(typ))
	
	return zeigelTypen


func get_text(ziegelTyp) : 
	return ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"


func _notification(what):        
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
        items.hide()


func _on_Items_item_pressed( ID ):
	set_ziegel_typ(ziegelTypen[ID])
	emit_signal("changed", ziegelTyp)
