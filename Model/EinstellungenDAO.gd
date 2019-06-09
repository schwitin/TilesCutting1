extends Reference

var EINSTELLUNGEN_DIR="user://einstellungen/"



func _init():
	var einstellungenDir = Directory.new()
	if false == einstellungenDir.dir_exists ( EINSTELLUNGEN_DIR ):
		einstellungenDir.make_dir_recursive(EINSTELLUNGEN_DIR)
		neues_dach("Beispiel")


func neues_dach(name):
	var dach = []
	var einstellungenClass = load("res://Model/Einstellungen.gd")
	dach.append(einstellungenClass.new(name, "Grat-1"))
	dach.append(einstellungenClass.new(name, "Grat-2"))
	dach.append(einstellungenClass.new(name, "Grat-3"))
	save(name, dach)


func add_schnitt(dachName, schnittName):
	var dach = read(dachName)
	var einstellungenClass = load("res://Model/Einstellungen.gd")
	dach.append(einstellungenClass.new(schnittName))
	save(dachName, dach)


func remove_schnitt(dachName, schnittName):
	var dach = read(dachName)
	var schnittToRemove = get_schnitt(dach, schnittName)
	var idxToRemove = dach.find(schnittToRemove)
	if idxToRemove > 0:
		dach.remove(idxToRemove)
		save(dachName, dach)


func rename_schnitt(dachName, schnittNameOld, schnittNameNew):
	var dach = read(dachName)
	var schnittToRename = get_schnitt(dach, schnittNameOld)
	if schnittToRename != null:
		schnittToRename.name = schnittNameNew
		save(dachName, dach)


func get_schnitt(dach, schnittName):
	for schnitt in dach:
		if schnitt.name == schnittName:
			return schnitt
	return null


func list():
	var list = []
	var einstellungenDir = Directory.new()
	if einstellungenDir.open(EINSTELLUNGEN_DIR) == OK:
		var currentDir = einstellungenDir.get_current_dir()
		einstellungenDir.list_dir_begin()
		while true:
			var fileName = einstellungenDir.get_next()
			if fileName == "":
				break
			if fileName.ends_with(".cfg"):
				var entry = fileName.substr(0, fileName.length() - 4)
				list.append(entry)
	return list


func save(name, dach):
	var dEinstellungen = []
	for e in dach:
		var d = e.to_dictionary()
		dEinstellungen.append(d)
		
	var dict = {
		dach = dEinstellungen
	}
	var json = dict.to_json()
	print(json)
	
	var file = File.new()
	var path = EINSTELLUNGEN_DIR + name + ".cfg"
	file.open(path, File.WRITE)
	file.store_line( json)
	file.close()


func read(name):
	var einstellungenClass = load("res://Model/Einstellungen.gd")
	var file = File.new()
	var path = EINSTELLUNGEN_DIR + name + ".cfg"
	file.open(path, file.READ)
	var dict = {}
	var parse_result = dict.parse_json(file.get_as_text())
	file.close()
	
	var dach = []
	if parse_result == OK:
		for dEinstellungen in dict.dach:
			var e = einstellungenClass.new("dummyDach", "dummy")
			e.init(dEinstellungen)
			dach.append(e)
	return dach;


func delete(name):
	var dir = Directory.new()
	var path = EINSTELLUNGEN_DIR + name + ".cfg"
	dir.remove(path)


func rename(oldName, newName):
	var dach = read(oldName)
	for schnitt in dach:
		schnitt.dachName = newName
	save(oldName, dach)
	
	var dir = Directory.new()
	var oldPath = EINSTELLUNGEN_DIR + oldName + ".cfg"
	var newPath = EINSTELLUNGEN_DIR + newName + ".cfg"
	dir.rename(oldPath, newPath)