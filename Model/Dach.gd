extends Reference

var ziegel_typ = null

var anzahl_reihen = null 

var abstand_vom_mast_oben = null
var abstand_vom_mast_unten = null

var linieClass
var ziegelModellClass

# 
var aktueller_ziegel_index = 0

func _init(einstellungen):
	ziegel_typ =einstellungen.ziegel_typ
	anzahl_reihen = einstellungen.anzahl_reihen
	abstand_vom_mast_oben = einstellungen.abstand_vom_mast_oben
	abstand_vom_mast_unten = einstellungen.abstand_vom_mast_unten
	aktueller_ziegel_index = 0
	
	
	linieClass = load("res://Model/Linie.gd")	
	ziegelModellClass = load("res://Model/ZiegelModell.gd")


func get_ziegel_list():
	var ziegel_list = []
	var anzahl_spalten = get_anzahl_spalten()
	var bounding_box = get_bounding_box()
	var i = 0
	for y in range(0, anzahl_reihen):
		var pos_y = bounding_box.y - y * (ziegel_typ.groesse.y - ziegel_typ.ueberlappung.y) - ziegel_typ.groesse.y
		for x in range(0, anzahl_spalten):
			var pos_x = bounding_box.x - x * (ziegel_typ.groesse.x - ziegel_typ.ueberlappung.x) - ziegel_typ.groesse.x + ziegel_typ.ueberlappung.x
			var ziegel_position = Vector2(pos_x, pos_y)
			var ziegel = ziegelModellClass.new(ziegel_position, ziegel_typ)
			ziegel_list.append(ziegel)
			if ziegel.get_schnittlinie(get_schnittlinie()) != null:
				ziegel.nummer = i
				i = i + 1
	
	return ziegel_list


func get_schnittlinie():
	var obere_linie = get_obere_linie()
	var untere_linie = get_untere_linie()
	var p_oben = obere_linie.p2
	var p_unten = untere_linie.p2	
	var p11 = Vector2(p_oben.x - 3, p_oben.y -3)
	var p22 = Vector2(p_unten.x + 3, p_unten.y + 3)
	var linie = linieClass.new(p_oben, p_unten)
	return linie.get_laengere_linie(1.5)


func get_obere_linie() :
	var mast_linie = get_mast_linie()
	var p_mast_oben = mast_linie.p1
	var p = Vector2(p_mast_oben.x + abstand_vom_mast_oben, p_mast_oben.y)
	var linie = linieClass.new(p_mast_oben, p)
	return linie


func get_untere_linie() : 
	var mast_linie = get_mast_linie()
	var p_mast_unten = mast_linie.p2
	var p = Vector2(p_mast_unten.x + abstand_vom_mast_unten, p_mast_unten.y)
	var linie = linieClass.new(p_mast_unten, p)
	return linie


func get_mast_linie() :
	var bounding_box = get_bounding_box()
	var p_oben 
	var p_unten
	if abstand_vom_mast_oben < 0 :
		p_oben = Vector2(bounding_box.x, 0)
		p_unten = Vector2(bounding_box.x, bounding_box.y)
	else :
		p_oben = Vector2(0, 0)
		p_unten = Vector2(0, bounding_box.y)
		
	var mast_linie = linieClass.new(p_oben, p_unten)
	return mast_linie


func get_bounding_box() :
	var anzahl_spalten = get_anzahl_spalten()
	var x = anzahl_spalten * (ziegel_typ.groesse.x - ziegel_typ.ueberlappung.x)
	var y = anzahl_reihen  * (ziegel_typ.groesse.y - ziegel_typ.ueberlappung.y)
	var bounding_box = Vector2(x,y)
	return bounding_box


func get_anzahl_spalten() :
	var breite = abs(abstand_vom_mast_oben)
	# print (breite)
	var anzahl_spalten = int( breite / (ziegel_typ.groesse.x - ziegel_typ.ueberlappung.x) ) + 1
	# print ("anzahl spalten ", anzahl_spalten)
	return anzahl_spalten
	
	
func get_ziegel_mit_schnittpunkten_old():
	var i = 0
	var ziegel_mit_schnittpunkten = []
	for ziegel in get_ziegel_list():
		if ziegel.get_schnittlinie(get_schnittlinie()) != null:
			ziegel.nummer = i
			i = i + 1
			ziegel_mit_schnittpunkten.append(ziegel)
			if(i > 46) :
				print(i, "->" ,ziegel.rect.position)
	
	return ziegel_mit_schnittpunkten
	
func get_ziegel_mit_schnittpunkten():
	var ziegel_mit_schnittpunkten = []
	for ziegel in get_ziegel_list():
		if ziegel.nummer >= 0:
			ziegel_mit_schnittpunkten.append(ziegel)
	
	return ziegel_mit_schnittpunkten
	





