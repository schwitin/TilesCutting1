extends Reference

var einstellungen = null
var is_grat = true setget set_grat, is_grat

var classZiegelTyp = preload("res://Model/ZiegelTyp1.gd")
var classLinie = preload("res://Model/Linie.gd")

signal changed()

 
var aktueller_ziegel_index = 0

func _init(_einstellungen):
	einstellungen = _einstellungen
	print("_init", einstellungen)
	init_schnittlinie()
	einstellungen.connect("schnuere_changed", self, "init_schnittlinie");
	einstellungen.connect("latten_changed", self, "init_schnittlinie");


func set_grat(_is_grat):
	is_grat = _is_grat
	emit_signal("changed")
	
func is_grat():
	return is_grat

func get_sprungpunkte_oben():
	var latten = get_latten()
	var sprung_latte = latten[latten.size()-1]
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


func get_linie_von_schnittlinie_zum_naechsten_schnur_oben():
	var schnittlinie = get_schnittlinie()
	var schnittlinie_ende = schnittlinie.p1
	var sprungpunkte = get_sprungpunkte_oben()
	var linie = get_linie_von_schnittlinie_zum_naechsten_schnur(schnittlinie_ende, sprungpunkte)
	return linie


func get_linie_von_schnittlinie_zum_naechsten_schnur_unten():
	var schnittlinie = get_schnittlinie()
	var schnittlinie_ende = schnittlinie.p2
	var sprungpunkte = get_sprungpunkte_unten()
	var linie = get_linie_von_schnittlinie_zum_naechsten_schnur(schnittlinie_ende, sprungpunkte)
	return linie


func get_abstand_von_schnittlinie_zum_naechsten_schnur_oben():
	var linie = get_linie_von_schnittlinie_zum_naechsten_schnur_oben()
	var distance = linie.p1.distance_to(linie.p2)
	return distance

func get_abstand_von_schnittlinie_zum_naechsten_schnur_unten():
	var linie = get_linie_von_schnittlinie_zum_naechsten_schnur_unten()
	var distance = linie.p1.distance_to(linie.p2)
	return distance


func get_linie_von_schnittlinie_zum_naechsten_schnur(schnittlinie_ende, sprungpunkte):
	var schnittlinie = get_schnittlinie()
	var sprungpunkt = get_naechsten_sichtbaren_sprungpunkt(sprungpunkte, schnittlinie_ende)
	var linie = null
	if sprungpunkt != null:
		linie = classLinie.new(schnittlinie_ende, sprungpunkt)
	else :
		linie =  classLinie.new(Vector2(0,0), Vector2(0,0))
		
	return linie


func get_naechsten_sichtbaren_sprungpunkt(sprungpunkte, schnittlinie_ende):
	var schnittlinie = get_schnittlinie()
	var steigung = schnittlinie.get_steigung()
	var sprungpunkt = null
	
	if self.is_grat() :
		if steigung > 0:
			sprungpunkt = get_sprungpunkt_links(sprungpunkte, schnittlinie_ende.x)
		elif steigung < 0:
			sprungpunkt = get_sprungpunkt_rechts(sprungpunkte, schnittlinie_ende.x)
		
	else:
		if steigung < 0:
			sprungpunkt = get_sprungpunkt_links(sprungpunkte, schnittlinie_ende.x)
		elif steigung > 0:
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


func get_bounding_box() :
	var bereicheSchuere = einstellungen.bereicheSchuere
	var x = 0
	for bereich in bereicheSchuere :
		x = x + bereich.get_berich_groesse()
		
	var bereicheLatten = einstellungen.bereicheLatten
	var y = 0
	for bereich in bereicheLatten :
		y = y + bereich.get_berich_groesse()
	
	var bounding_box = Vector2(x,y)
	return bounding_box


func get_schnuere():
	var linien = []
	var bounding_box = get_bounding_box()
	linien.append(classLinie.new(Vector2(0,0), Vector2(0, bounding_box.y)))
	
	var bereicheSchuere = einstellungen.bereicheSchuere
	var x = 0
	for bereich in bereicheSchuere :
		for i in range(bereich.anzahl_schnuere):
			x = x + bereich.get_abstand()
			var p1 = Vector2(x, 0)
			var p2 = Vector2(x, bounding_box.y)
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
			
	return linien


func get_schnuere_kehle():
	var linien = []
	var schnuere = get_schnuere()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-2,-2), Vector2(p_max.x+4, p_max.y+4))
	var schnittline = get_schnittlinie().get_laengere_linie()
	var steigung = schnittline.get_steigung()
	
	for schnur in schnuere:
		var schnittpunkt = schnittline.get_schnittpunkt(schnur.get_laengere_linie())
		# print(schnittpunkt)
		if schnittpunkt != null && bounding_box.has_point(schnittpunkt):
			var p1 = schnur.p1
			var p2 = schnittpunkt
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
		elif steigung > 0 && schnur.p1.x > schnittline.get_min_x() || steigung < 0 && schnur.p1.x <= schnittline.get_max_x() :
			linien.append(schnur)
	
	return linien


func get_schnuere_grat():
	#print("schnuere grat")
	var linien = []
	var schnuere = get_schnuere()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-2,-2), Vector2(p_max.x+4, p_max.y+4))
	var schnittline = get_schnittlinie().get_laengere_linie()
	var steigung = schnittline.get_steigung()
	
	# print("bounding_box ", bounding_box)
	# print("has_point_0_0", bounding_box.has_point(Vector2(-1,-1)))
	# print("has_point_max_max", bounding_box.has_point(Vector2(p_max.x,p_max.y)))
	
	for schnur in schnuere:
		var schnittpunkt = schnittline.get_schnittpunkt(schnur.get_laengere_linie())
		# print("schnittpunkt ", schnittpunkt)
		if schnittpunkt != null && bounding_box.has_point(schnittpunkt):
			var p1 = schnittpunkt
			var p2 = schnur.p2
			var linie = classLinie.new(p1, p2)
			# print("linie", p1, p2)
			linien.append(linie)
		elif steigung > 0 && schnur.p1.x < schnittline.get_min_x() || steigung < 0 && schnur.p1.x >= schnittline.get_max_x() :
			linien.append(schnur)
			
	return linien


func get_latten():
	var linien = []
	var bounding_box = get_bounding_box()
	linien.append(classLinie.new(Vector2(0, bounding_box.y), Vector2(bounding_box.x, bounding_box.y)))
	
	var bereicheLatten = einstellungen.bereicheLatten
	var y = bounding_box.y
	for bereich in bereicheLatten :
		for i in range(bereich.anzahl_latten):
			y = y - bereich.decklaenge
			var p1 = Vector2(0, y)
			var p2 = Vector2(bounding_box.x, y)
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
	
	print("Anzahl Latten ", linien.size())
	return linien


func get_latten_kehle():
	var linien = []
	var latten = get_latten()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-2,-2), Vector2(p_max.x+4, p_max.y+4))
	var schnittline = get_schnittlinie().get_laengere_linie()
	var steigung = schnittline.get_steigung()
	
	for latte in latten:
		var schnittpunkt = schnittline.get_schnittpunkt(latte.get_laengere_linie())
		# print(schnittpunkt)
		if steigung != 0 && schnittpunkt != null && bounding_box.has_point(schnittpunkt):
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
		
	return linien


func get_latten_grat():
	var linien = []
	var latten = get_latten()
	var p_max = get_bounding_box()
	var bounding_box = Rect2(Vector2(-2,-2), Vector2(p_max.x+4, p_max.y+4))
	var schnittline = get_schnittlinie().get_laengere_linie(1.5)
	var steigung = schnittline.get_steigung()
	
	if steigung == 0:
		return linien
	
	for latte in latten:
		var schnittpunkt = schnittline.get_schnittpunkt(latte.get_laengere_linie())
		#print(schnittpunkt)
		if schnittpunkt != null && bounding_box.has_point(schnittpunkt):
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
	
func get_abstand_linie_oben():
	pass


func init_schnittlinie():
	print("init_schnittlinie")
	einstellungen.print_einstellungen()
	var sprungpunkteOben = get_sprungpunkte_oben()
	var sprungpunkteUnten = get_sprungpunkte_unten()
	var p1 = sprungpunkteOben[0]
	var p2 = sprungpunkteUnten[sprungpunkteUnten.size()-1]
	# print(p1, p2)
	einstellungen.schnittlinie = classLinie.new(p1, p2)
	emit_signal("changed")
