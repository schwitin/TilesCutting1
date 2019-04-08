extends Reference

var ziegelTypen = []

func _init():
	load_ziegel_typen()


func load_ziegel_typen():
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var file = File.new()
	file.open("res://Resources/ZiegelTyp.json", file.READ)
	var dict = {}
	var parse_result = dict.parse_json(file.get_as_text())
	file.close()
	
	if parse_result == OK:
		for typ in dict.ZiegelTypList :
			ziegelTypen.append(ziegelTypClass.new(typ))