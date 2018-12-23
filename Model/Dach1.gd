extends Reference

var einstellungen = null
var is_grat = true setget set_grat, is_grat

var classAbstand = preload("res://Model/Abstand.gd")
var classZiegelTyp = preload("res://Model/ZiegelTyp1.gd")
var classLinie = preload("res://Model/Linie.gd")

signal changed()

 
var aktueller_ziegel_index = 0

func _init(einstellungen):
	self.einstellungen = einstellungen
	
	if self.einstellungen.abstaendeX.size() == 0:
		init_abstaendeX()
	if self.einstellungen.abstaendeY.size() == 0:
		init_abstaendeY()
	if self.einstellungen.ziegelTyp == null:
		init_ziegeltyp()
	if self.einstellungen.schnittlinie == null:
		init_schnittlinie()

func set_grat(_is_grat):
	is_grat = _is_grat
	emit_signal("changed")
	
func is_grat():
	return is_grat

func get_sprungpunkte_oben():
	var latten = get_latten()
	var sprung_latte = latten[latten.size()-2]
	return get_sprungpunkte(sprung_latte)


func get_sprungpunkte_unten():
	var latten = get_latten()
	var sprung_latte = latten[0]
	return get_sprungpunkte(sprung_latte)


func get_sprungpunkte(sprung_latte):
	var sprungpunkte = []
	var y = sprung_latte.p1.y
	var schnuere = get_schnuere()
	for schnur in schnuere:
		var x = schnur.p1.x
		var p = Vector2(x, y)
		sprungpunkte.append(p)
		
	return sprungpunkte


func get_versatz_zum_naechsten_schnur_oben():
	var distance = 0
	var schnittlinie = get_schnittlinie()
	var schnittlinie_ende = schnittlinie.p1
	var sprungpunkte = get_sprungpunkte_oben()
	var sprungpunkt = get_naechsten_sichtbaren_sprungpunkt(sprungpunkte, schnittlinie_ende)
		
		
	# print (self.is_grat(), " ", " ", sprungpunkt)
	if sprungpunkt != null:
		distance = sprungpunkt.distance_to(schnittlinie_ende)
	return distance
	
func get_versatz_zum_naechsten_schnur_unten():
	var distance = 0
	var schnittlinie = get_schnittlinie()
	var schnittlinie_ende = schnittlinie.p2
	var sprungpunkte = get_sprungpunkte_unten()
	var sprungpunkt = get_naechsten_sichtbaren_sprungpunkt(sprungpunkte, schnittlinie_ende)
		
		
	# print (self.is_grat(), " ", " ", sprungpunkt)
	if sprungpunkt != null:
		distance = sprungpunkt.distance_to(schnittlinie_ende)
	return distance
	
	
func get_naechsten_sichtbaren_sprungpunkt(sprungpunkte, schnittlinie_ende):
	var schnittlinie = get_schnittlinie()
	var steigung = schnittlinie.get_steigung()
	var sprungpunkt = null
	
	if self.is_grat() :
		if steigung > 0:
			sprungpunkt = get_sprungpunkt_links(sprungpunkte, schnittlinie_ende.x)
		else:
			sprungpunkt = get_sprungpunkt_rechts(sprungpunkte, schnittlinie_ende.x)
		
	else:
		if steigung < 0:
			sprungpunkt = get_sprungpunkt_links(sprungpunkte, schnittlinie_ende.x)
		else:
			sprungpunkt = get_sprungpunkt_rechts(sprungpunkte, schnittlinie_ende.x)
	
	return sprungpunkt


func bewege_schnittlinie_oben(mm):
	var bounding_box = get_bounding_box()
	var schnittlinie = get_schnittlinie()
	var x = schnittlinie.p1.x + mm
	if x > 0 && x < bounding_box.x:
		schnittlinie.p1.x = x
		emit_signal("changed")


func bewege_schnittlinie_unten(mm):
	var bounding_box = get_bounding_box()
	var schnittlinie = get_schnittlinie()
	var x = schnittlinie.p2.x + mm
	if x > 0 && x < bounding_box.x:
		schnittlinie.p2.x = x
		emit_signal("changed")


func bewege_schnittlinie_oben_nach_links() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_oben()
	var sprungpunkt = get_sprungpunkt_links(sprungpunkte, schnittlinie.p1.x)
	if sprungpunkt != null:
		schnittlinie.p1 = sprungpunkt
		emit_signal("changed")


func bewege_schnittlinie_oben_nach_rechts() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_oben()
	var sprungpunkt = get_sprungpunkt_rechts(sprungpunkte, schnittlinie.p1.x)
	if sprungpunkt != null:
		schnittlinie.p1 = sprungpunkt
		emit_signal("changed")


func bewege_schnittlinie_unten_nach_links() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_unten()
	var sprungpunkt = get_sprungpunkt_links(sprungpunkte, schnittlinie.p2.x)
	if sprungpunkt != null:
		schnittlinie.p2 = sprungpunkt
		emit_signal("changed")


func bewege_schnittlinie_unten_nach_rechts() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_unten()
	var sprungpunkt = get_sprungpunkt_rechts(sprungpunkte, schnittlinie.p2.x)
	if sprungpunkt != null:
		schnittlinie.p2.x = sprungpunkt.x
		emit_signal("changed")


func get_sprungpunkt_links(sprungpunkte, x):
	var naechster_sprungpunkt_links = null
	for p in sprungpunkte:
		if p.x < x :
			naechster_sprungpunkt_links = p
		else :
			break
		
	return naechster_sprungpunkt_links


func get_sprungpunkt_rechts(sprungpunkte, x):
	var naechster_sprungpunkt_rechts = null
	var size = sprungpunkte.size()
	for i in range(size):
		var p = sprungpunkte[size-i-1]
		if p.x > x :
			naechster_sprungpunkt_rechts = p
		else :
			break
		
	return naechster_sprungpunkt_rechts


func get_schnittlinie():
	return einstellungen.schnittlinie
	
func get_schnittlinie_bis_bounding_box():
	var verlaengerung = 1.0001
	var schnittline = get_schnittlinie().get_laengere_linie(2)
	var schnuere = get_schnuere()
	var latten = get_latten()
	
	var erste_latte = latten[0].get_laengere_linie(verlaengerung)
	var letzte_latte = latten[latten.size() - 1].get_laengere_linie(verlaengerung)
	var erster_schnur = schnuere[0].get_laengere_linie(verlaengerung)
	var letzter_schnur = schnuere[schnuere.size() - 1].get_laengere_linie(verlaengerung)
	var bounding_box = [erster_schnur, letzte_latte, letzter_schnur, erste_latte ]
	
	var schnittpunkte = []
	for linie in bounding_box:
		var p = schnittline.get_schnittpunkt(linie)
		if p != null:
			schnittpunkte.append(p)
	
	if schnittpunkte.size() >= 2:
		return classLinie.new(schnittpunkte[0], schnittpunkte[1]).get_laengere_linie(verlaengerung)
	else: # sollte nie der fall sein
		return schnittline



func get_bounding_box() :
	var abstaendeX = einstellungen.abstaendeX
	var x = 0
	for abstand in abstaendeX :		
		x = x + (abstand.abstand * abstand.anzahl)
		
	var abstaendeY = einstellungen.abstaendeY
	var y = 0
	for abstand in abstaendeY :
		y = y + (abstand.abstand * abstand.anzahl)
	
	var bounding_box = Vector2(x,y)
	return bounding_box


func get_schnuere():
	var linien = []
	var bounding_box = get_bounding_box()
	linien.append(classLinie.new(Vector2(0,0), Vector2(0, bounding_box.y)))
	
	var abstaendeX = einstellungen.abstaendeX
	var x = 0
	for abstand in abstaendeX :
		for i in range(abstand.anzahl):
			x = x + abstand.abstand
			var p1 = Vector2(x, 0)
			var p2 = Vector2(x, bounding_box.y)
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
			
	return linien


func get_schnuere_kehle():
	var linien = []
	var schnuere = get_schnuere()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-1,-1), Vector2(p_max.x+10, p_max.y+10))
	var schnittline = get_schnittlinie_bis_bounding_box()
	var steigung = schnittline.get_steigung()
	
	for schnur in schnuere:
		var schnittpunkt = schnittline.get_schnittpunkt(schnur.get_laengere_linie(1.2))		
		# print(schnittpunkt)
		if schnittpunkt != null && bounding_box.has_point(schnittpunkt):
			var p1 = schnur.p1
			var p2 = schnittpunkt
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
		elif steigung >= 0 && schnur.p1.x > schnittline.get_min_x() || steigung < 0 && schnur.p1.x <= schnittline.get_max_x() :
			linien.append(schnur)
	
	return linien


func get_schnuere_grat():
	var linien = []
	var schnuere = get_schnuere()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-1,-1), Vector2(p_max.x+2, p_max.y+2))
	var schnittline = get_schnittlinie_bis_bounding_box()
	var steigung = schnittline.get_steigung()
	
	for schnur in schnuere:
		var schnittpunkt = schnittline.get_schnittpunkt(schnur.get_laengere_linie(1.2))
		# print(schnittpunkt)
		if schnittpunkt != null && bounding_box.has_point(schnittpunkt):
			var p1 = schnittpunkt
			var p2 = schnur.p2
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
		elif steigung > 0 && schnur.p1.x < schnittline.get_min_x() || steigung < 0 && schnur.p1.x >= schnittline.get_max_x() :
			linien.append(schnur)
	
	return linien


func get_latten():
	var linien = []
	var bounding_box = get_bounding_box()
	linien.append(classLinie.new(Vector2(0, bounding_box.y), Vector2(bounding_box.x, bounding_box.y)))
	
	var abstaendeY = einstellungen.abstaendeY
	var y = bounding_box.y
	for abstand in abstaendeY :
		for i in range(abstand.anzahl):
			y = y - abstand.abstand
			var p1 = Vector2(0, y)
			var p2 = Vector2(bounding_box.x, y)
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
			
	return linien


func get_latten_kehle():
	var linien = []
	var latten = get_latten()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-1,-1), Vector2(p_max.x+10, p_max.y+10))
	var schnittline = get_schnittlinie().get_laengere_linie(1.5)
	var steigung = schnittline.get_steigung()
	
	for latte in latten:
		var schnittpunkt = schnittline.get_schnittpunkt(latte.get_laengere_linie(1.2))
		# print(schnittpunkt)
		if schnittpunkt != null && bounding_box.has_point(schnittpunkt):
			var p1 
			var p2
			if steigung >= 0 :
				p1 = schnittpunkt
				p2 = latte.p2
			else:
				p1 = latte.p1
				p2 = schnittpunkt
			
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
		else:
			linien.append(latte)
		
	return linien


func get_latten_grat():
	var linien = []
	var latten = get_latten()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-1,-1), Vector2(p_max.x+2, p_max.y+2))
	var schnittline = get_schnittlinie().get_laengere_linie(1.5)
	var steigung = schnittline.get_steigung()
	
	for latte in latten:
		var schnittpunkt = schnittline.get_schnittpunkt(latte.get_laengere_linie(1.2))
		#print(schnittpunkt)
		if steigung != 0 && schnittpunkt != null && bounding_box.has_point(schnittpunkt):
			var p1 
			var p2
			if steigung >= 0 :
				p1 = latte.p1
				p2 = schnittpunkt
			else:
				p1 = schnittpunkt
				p2 = latte.p2
			
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
		
	return linien

############### STANDARDEINSTELLUNGEN  #####################

func init_abstaendeX():
	var abstand = classAbstand.new()
	abstand.abstand = 964
	abstand.anzahl = 5
	einstellungen.abstaendeX.append(abstand)


func init_abstaendeY():
	var abstand = classAbstand.new()
	abstand.abstand = 426
	abstand.anzahl = 9
	einstellungen.abstaendeY.append(abstand)


func init_ziegeltyp() :
	var dict = {
			"Name": "Beispiel Ziegel",
			"Hersteller": "BRAAS",
			"Laenge" : "482",
			"Breite" : "292",
			"VersatzY": "20",
			"DecklaengeMin" : "414",
			"DecklaengeMax" : "414",
			"Deckbreite" : "241"
		}
	einstellungen.ziegelTyp = classZiegelTyp.new(dict)


func init_schnittlinie():
	var sprungpunkteOben = get_sprungpunkte_oben()
	var sprungpunkteUnten = get_sprungpunkte_unten()
	var p1 = sprungpunkteOben[0]
	var p2 = sprungpunkteUnten[sprungpunkteUnten.size()-1]
	einstellungen.schnittlinie = classLinie.new(p1, p2)
