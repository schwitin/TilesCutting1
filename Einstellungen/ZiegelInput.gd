extends Button

var ziegelTypen
var items

signal changed(ziegelTyp)

func set_ziegel_typ(ziegelTyp) :
	if ziegelTyp != null :
		self.text = get_text(ziegelTyp)


func _ready():
	items = get_node("Items")
	items.clear()
	ziegelTypen = get_ziegel_typen()
	var idx = 0
	for ziegelTyp in ziegelTypen:
		var text = ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"
		items.add_item(text)
	
	if self.text == "?":
		_on_Items_index_pressed(0)


func _on_Items_index_pressed(index):
	var ziegelTyp = ziegelTypen[index]
	self.text = get_text(ziegelTyp)
	emit_signal("changed", ziegelTyp)
	


func _on_Button_pressed():
	items.popup_centered()
	

func get_ziegel_typen():
	var zeigelTypen = []
	var ziegelTypClass = load("res://Model/ZiegelTyp1.gd")
	var file = File.new()
	file.open("res://Resources/ZiegelTyp.json", file.READ)
	var parsed = JSON.parse(file.get_as_text())
	file.close()
	
	if typeof(parsed.result) == TYPE_DICTIONARY:
		var dict = parsed.result
		for typ in dict.ZiegelTypList :
			zeigelTypen.append(ziegelTypClass.new(typ))
	
	return zeigelTypen

func get_text(ziegelTyp) : 
	return ziegelTyp.name + " (" + ziegelTyp.hersteller + ")"
	
func _notification(what):        
    if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST : 
        items.hide()
