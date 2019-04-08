extends Button

# model
var ziegelTyp setget set_ziegel_typ

var items

signal changed(ziegelTyp)


func _ready():
	items = get_node("Items")
	items.clear()
	
	for ziegelTyp in global.ziegelTypen:
		var text = ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"
		items.add_item(text)
	
	if self.ziegelTyp == null:
		set_ziegel_typ(global.ziegelTypen[0])


func set_ziegel_typ(_ziegelTyp) :
	ziegelTyp = _ziegelTyp
	self.text = get_text(ziegelTyp)
	emit_signal("changed", ziegelTyp)


func _on_Button_pressed():
	items.popup_centered()


func get_text(ziegelTyp) : 
	return ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"


func _notification(what):        
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
        items.hide()


func _on_Items_item_pressed( ID ):
	set_ziegel_typ(global.ziegelTypen[ID])
