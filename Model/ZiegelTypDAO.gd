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
	var dict = {
		"Metaden":{},
		"ZiegelTypList":[
			{
				"Name": "Muster",
				"Hersteller": "Unbekannt",
				"Laenge" : "482",
				"Breite" : "292",
				"VersatzY": "16",
				"DecklaengeMin" : "410",
				"DecklaengeMax" : "430",
				"Deckbreite" : "241"
			}
		]
	}
	if result_json.error == OK:
		dict = result_json.result
		
	for typ in dict.ZiegelTypList :
		ziegelTypen.append(ziegelTypClass.new(typ))