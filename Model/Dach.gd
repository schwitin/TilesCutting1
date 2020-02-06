extends Reference

var einstellungen = null
var isGrat = true setget set_grat, is_grat
var schnittlinie

var classLinie = preload("res://Model/Linie.gd")

signal changed()


func _init(_einstellungen):
	einstellungen = _einstellungen
	#print("_init", einstellungen)
	init_schnittlinie()
	isGrat = einstellungen.istGrat


func set_grat(_is_grat):
	isGrat = _is_grat
	emit_signal("changed")


func is_grat():
	return isGrat


func get_sprungpunkte_oben():
	var latten = get_latten()
	var sprung_latte = latten[0]
	return get_sprungpunkte_auf_der_latte(sprung_latte)


func get_sprungpunkte_unten():
	var latten = get_latten()
	var sprung_latte = latten[latten.size()-1]
	return get_sprungpunkte_auf_der_latte(sprung_latte)


# WIP
func get_sprungpunkte_links():
	var schnuere = get_schnuere()
	var sprung_schnur = schnuere[0]
	return get_sprungpunkte_auf_dem_schnur(sprung_schnur)


# WIP
func get_sprungpunkte_rechts():
	var schnuere = get_schnuere()
	var sprung_schnur = schnuere[schnuere.size()-1]
	return get_sprungpunkte_auf_dem_schnur(sprung_schnur)


func get_sprungpunkte_auf_der_latte(sprung_latte):
	var sprungpunkte = []
	var y = sprung_latte.p1.y
	var schnuere = get_schnuere()
	for schnur in schnuere:
		var x = schnur.p1.x
		var p = Vector2(x, y)
		sprungpunkte.append(p)
		
	return sprungpunkte

# WIP
func get_sprungpunkte_auf_dem_schnur(sprung_schnur):
	var sprungpunkte = []
	var x = sprung_schnur.p1.x
	var latten = get_latten()
	for latte in latten:
		var y = latte.p1.y
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
	#var schnittlinie = get_schnittlinie()
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
	if x >= 0 && x <= bounding_box.x:
		schnittlinie.p1.x = x
		emit_signal("changed")


# WIP
func bewege_schnittlinie_links(mm):
	var bounding_box = get_bounding_box()
	var schnittlinie = get_schnittlinie()
	var y = schnittlinie.p1.y + mm
	if y >= 0 && y <= bounding_box.y:
		schnittlinie.p1.y = y
		emit_signal("changed")


# WIP
func bewege_schnittlinie_rechts(mm):
	var bounding_box = get_bounding_box()
	var schnittlinie = get_schnittlinie()
	var y = schnittlinie.p2.y + mm
	if y >= 0 && y <= bounding_box.y:
		schnittlinie.p2.y = y
		emit_signal("changed")


func bewege_schnittlinie_unten(mm):
	var bounding_box = get_bounding_box()
	var schnittlinie = get_schnittlinie()
	var x = schnittlinie.p2.x + mm
	if x >= 0 && x <= bounding_box.x:
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


# WIP
func bewege_schnittlinie_links_nach_unten() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_links()
	var sprungpunkt = get_sprungpunkt_unten(sprungpunkte, schnittlinie.p1.y)
	if sprungpunkt != null:
		schnittlinie.p1 = sprungpunkt
		emit_signal("changed")


# WIP
func bewege_schnittlinie_links_nach_oben() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_links()
	var sprungpunkt = get_sprungpunkt_oben(sprungpunkte, schnittlinie.p1.y)
	if sprungpunkt != null:
		schnittlinie.p1 = sprungpunkt
		emit_signal("changed")


# WIP
func bewege_schnittlinie_rechts_nach_unten() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_rechts()
	var sprungpunkt = get_sprungpunkt_unten(sprungpunkte, schnittlinie.p2.y)
	if sprungpunkt != null:
		schnittlinie.p2 = sprungpunkt
		emit_signal("changed")


# WIP
func bewege_schnittlinie_rechts_nach_oben() :
	var schnittlinie = get_schnittlinie()
	var sprungpunkte = get_sprungpunkte_rechts()
	var sprungpunkt = get_sprungpunkt_oben(sprungpunkte, schnittlinie.p2.y)
	if sprungpunkt != null:
		schnittlinie.p2 = sprungpunkt
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


# WIP
func get_sprungpunkt_oben(sprungpunkte, y):
	var naechster_sprungpunkt_oben = null
	for p in sprungpunkte:
		if p.y < y :
			naechster_sprungpunkt_oben = p
		else :
			break
		
	return naechster_sprungpunkt_oben


# WIP
func get_sprungpunkt_unten(sprungpunkte, y):
	var naechster_sprungpunkt_unten = null
	var size = sprungpunkte.size()
	for i in range(size):
		var p = sprungpunkte[size-i-1]
		if p.y > y :
			naechster_sprungpunkt_unten = p
		else :
			break
		
	return naechster_sprungpunkt_unten


func get_schnittlinie():
	return schnittlinie
	#return einstellungen.schnittlinie


func get_bounding_box() :
	var bereicheSchuere = einstellungen.bereicheSchuere
	var x = 0
	for bereich in bereicheSchuere :
		x = x + bereich.get_berich_groesse()
		
	var bereicheLatten = einstellungen.bereicheLatten
	var y = 0
	var letzterBereich
	for bereich in bereicheLatten :
		y = y + bereich.get_berich_groesse()
		letzterBereich = bereich
	
	# Jetzt haben wir y bei der Unterseite des untersten Ziegel.
	# Die Latte, auf der dieser Ziegel hängt, ist etwas höher:
	y = y - letzterBereich.decklaenge
	var bounding_box = Vector2(x,y)
	return bounding_box


func get_schnuere():
	var linien = []
	var bounding_box = get_bounding_box()
	linien.append(classLinie.new(Vector2(0,0), Vector2(0, bounding_box.y)))
	
	var bereicheSchuere = einstellungen.bereicheSchuere
	var x = 0
	for bereich in bereicheSchuere :
		#warning-ignore:unused_variable
		for i in range(bereich.anzahl_schnuere):
			x = x + bereich.schnurabstand
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
	
	var bereicheLatten = einstellungen.bereicheLatten
	var y = 0
	#warning-ignore:unused_variable
	for bereich in bereicheLatten :
		for i in range(bereich.anzahl_latten):
			var p1 = Vector2(0, y)
			var p2 = Vector2(bounding_box.x, y)
			var linie = classLinie.new(p1, p2)
			linien.append(linie)
			y = y + bereich.decklaenge
	
	#print("Anzahl Latten ", linien.size())
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
		# print(schnittpunkt)
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


func get_winkel_schnittlinie_unterste_latte():
	var winkel = schnittlinie.get_winkel_zu_horizontale()
	var steigung = schnittlinie.get_steigung()
	if isGrat && steigung < 0 || !isGrat && steigung > 0:
		winkel = 180 - winkel
	
	return winkel


###################################################################################
# Ermittelt alle Ziegel für das Dach, das durch Latten-, Schnürebereiche und die 
# Schnttlinie definiert ist. Es wird ein zweidimensionaler Array zurückgegeben.
# Die erste Dimension sind die Ziegelreihen (Arrays), die zweite Dimension
# sind die Ziegel dieser Reihe, wobei die Reihe nur geschnittene Ziegel enthält, 
# die von anderen geschnittenen Ziegeln nicht verdeckt sind.
###################################################################################
func get_ziegel_ohne_verdeckte():
	var alleZiegelReihen = get_ziegel()
	var alleZiegelReihenOhneVerdeckte = []
	
	for i in range(alleZiegelReihen.size()):
		var reihe = alleZiegelReihen[i]
		var reiheOhneVerdeckte = []
		
		for j in range(reihe.size()):
			var ziegel = reihe[j]
			if ist_ziegel_verdeckt(ziegel, alleZiegelReihen): continue
			reiheOhneVerdeckte.append(ziegel)
		
		if reiheOhneVerdeckte.size() > 0:
			alleZiegelReihenOhneVerdeckte.append(reiheOhneVerdeckte)
	
	return alleZiegelReihenOhneVerdeckte


###################################################################################
# Ermittelt alle Ziegel für das Dach, das durch Latten-, Schnürebereiche und die 
# Schnttlinie definiert ist. Es wird ein zweidimensionaler Array zurückgegeben.
# Die erste Dimension sind die Ziegelreihen (Arrays), die zweite Dimension
# sind die Ziegel dieser Reihe, wobei die Reihe nur geschnittene Ziegel enthält.
###################################################################################
func get_ziegel():
	if einstellungen.bereicheLatten == null || einstellungen.bereicheSchuere == null || einstellungen.schnittlinie == null:
		return []
	
	# Rstes Element ist die oberste Ziegelreihe
	var alleZiegelReihen = []
	
	# Wir starten mit der obersten Latte
	var lattenPositionY = 0
	var lattenNr = 1
	# Wir gehen über alle Bereiche und ermitteln erstmal die Decklänge für diesen Bereich
	for bereichLatten in einstellungen.bereicheLatten:
		var decklaenge = bereichLatten.decklaenge 
		# Wir gehen über alle Latten des Bereichs, ermitteln je latte die Ziegelreihe
		# und fügen diese den alleZiegelReihen hinzu. Es werden nur geschnittene Ziegel 
		# berücksichtigt.
		#warning-ignore:unused_variable
		for l in range(bereichLatten.anzahl_latten):
			# Erster Element ist der linke Ziegel in der Reihe.
			var ziegelReihe = get_ziegelreihe(lattenPositionY, lattenNr)
			if ziegelReihe.size() > 0:
				alleZiegelReihen.append(ziegelReihe)
				# Wir verschieben lattenPositionY um eine Decklänge (=Lattenabstand) nach unten.
				lattenPositionY += decklaenge
				lattenNr += 1
	
	return alleZiegelReihen


###################################################
# Erstellt die Ziegelreihe für die übergebene Latte
# Es werden nur geschnittenen Ziegel berücksichtigt
###################################################
func get_ziegelreihe(lattenPositionY, latteNr):
	# Erster Element ist der linke Ziegel in der Reihe.
	var ziegelReihe = []
	
	# Wir müssen um versatzY nach oben gehen, weil der Ziegel mit der Latte nicht 
	# bündig ist, sonder ragt um versatzY über die Latte raus.
	var ziegelPosition = Vector2(0, lattenPositionY - einstellungen.ziegelTyp.versatzY)
	
	# y = Reihe, 
	# x = Ziegel in der Reihe
	var ziegelPositionLogisch = Vector2(1, latteNr)
	
	# Wir gehen über alle Bereiche und ermitteln die Deckbreite für jeden Bereich
	for bereichSchnuere in einstellungen.bereicheSchuere:
		var deckbreite = bereichSchnuere.get_deckbreite()
		# Wir gehen über alle Schnüre im Bereich.
		#warning-ignore:unused_variable
		for schnurNr in range(bereichSchnuere.anzahl_schnuere):
			# Wir erstellen alle Ziegel für jeden Schnur und,
			# wenn der Ziegel geschnitten ist nehmen wir diesen in
			# die ziegelReihe auf. 
			#warning-ignore:unused_variable
			for ziegelNr in range(bereichSchnuere.anzahl_ziegel):
				var ziegel = createZiegel(ziegelPosition, ziegelPositionLogisch)
				if ziegel.istGeschnitten:
					ziegelReihe.append(ziegel)
					ziegelPositionLogisch.x += 1
				# Wir die verschieben die ziegelPositionX um die 
				# Deckbreite (=Ziegelbreite - Überlappung) nach rechts. 
				ziegelPosition.x += deckbreite
	
	return ziegelReihe


####################################################################
# Erstellt einen Ziegel 
# position - ist die absolute Postion in mm relativ zu der oberen linken Ecke
# logischePosition - welcher Reihe der Ziegel angehört und welche Postion er in der Reiche hat 
####################################################################
func createZiegel(position, positionLogisch):
	var ziegelClass = preload("res://Model/Ziegel.gd")
	var ziegel = ziegelClass.new(einstellungen, position)
	ziegel.reihe = positionLogisch.y
	ziegel.nummer = positionLogisch.x
	return ziegel


func ist_ziegel_verdeckt(ziegel, alleZiegelReihen):
	for i in range(alleZiegelReihen.size()):
		var reihe = alleZiegelReihen[i - 1]
		for j in range(reihe.size()):
			var z = reihe[j - 1]
			if z != ziegel && z.verdeckt(ziegel):
				return true;

func init_schnittlinie():
	#print("init_schnittlinie")
	# einstellungen.print_einstellungen()
	if einstellungen.schnittlinie == null:
		var sprungpunkteOben = get_sprungpunkte_oben()
		var sprungpunkteUnten = get_sprungpunkte_unten()
		var p1 = sprungpunkteOben[0]
		var p2 = sprungpunkteUnten[sprungpunkteUnten.size()-1]
		schnittlinie = classLinie.new(p1, p2)
	else:
		schnittlinie = einstellungen.schnittlinie
