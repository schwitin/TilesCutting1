extends Reference

var ziegelTypen = []

func _init():
	load_ziegel_typen()

func get_ziegel_typ(name):
	var ziegelTyp = null
	for z in ziegelTypen:
		if z.name == name:
			ziegelTyp = z
			break
	return ziegelTyp
	
func load_ziegel_typen():
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var file = File.new()
	file.open("res://Resources/ZiegelTyp.json", file.READ)
	var result_json = JSON.parse(file.get_as_text())
	file.close()
	if result_json.error == OK:
		var dict = result_json.result
		for typ in dict.ZiegelTypList :
			ziegelTypen.append(ziegelTypClass.new(typ))