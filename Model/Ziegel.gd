extends Reference

var reihe
var nummer
var position		# linke obere Ecke
var einstellungen

var istAusgewaelt  = false setget set_ausgewaelt
var istGeschnitten = false


var linieClass = preload("res://Model/Linie.gd")


func _init(_einstellungen, _position):
	einstellungen = _einstellungen
	position = _position
	get_ziegel_polygon_points() # inizialisierung istGeschnitten

# Gibt ecken eines ganzen Ziegels als ein Array zurück
# Erster Element ist die linke obere Ecke
# Zweiter Element ist die rechte obere Ecke
# Dritter Element ist die rechte untere Ecke
# Vierter Element ist die linke untere Ecke
func get_eckpunkte():
	var ecken = []
	var laenge = einstellungen.ziegelTyp.laenge
	var breite = einstellungen.ziegelTyp.breite

	var p1 = position
	var p2 = Vector2(position.x + breite, position.y)
	var p3 = Vector2(position.x + breite, position.y + laenge)
	var p4 = Vector2(position.x, position.y + laenge)
	ecken.append(p1)
	ecken.append(p2)
	ecken.append(p3)
	ecken.append(p4)
	
	return ecken


func get_linien():
	var linien = []
	var ecken = get_eckpunkte()
	linien.append(create_linie(ecken[0], ecken[1]))
	linien.append(create_linie(ecken[1], ecken[2]))
	linien.append(create_linie(ecken[2], ecken[3]))
	linien.append(create_linie(ecken[3], ecken[0]))
	
	return linien


func get_zentrum():
	var ecken = get_eckpunkte()
	var diagonale1 = create_linie(ecken[0], ecken[2])
	var diagonale2 = create_linie(ecken[1], ecken[3])
	var zentrum = diagonale1.get_schnittpunkt(diagonale2)
	return zentrum


func get_distanz_von_schnittlinie_zum_zentrum():
	var schnittlinie = einstellungen.schnittlinie
	var zentrum = get_zentrum()
	var normale = schnittlinie.get_normale(zentrum)
	var vorzeichen = (normale.p2.x - normale.p1.x + 1 ) / abs(normale.p2.x - normale.p1.x + 1)
	var distanz = normale.p1.distance_to(normale.p2) * vorzeichen
	return distanz


func get_winkel_zu_vertikale():
	var winkel = einstellungen.schnittlinie.get_winkel_zu_vertikale()
	# var winkelV = abs(min(180 - abs(winkel), abs(winkel)))
	var winkelV = abs(winkel)
	return winkelV


func create_linie(p1, p2):
	return linieClass.new(p1, p2)


func update_ziegel_zeichnung(node):
	if istGeschnitten:
		var points = get_ziegel_polygon_points()
		var translated_points = []
		var laenge = einstellungen.ziegelTyp.laenge
		var breite = einstellungen.ziegelTyp.breite
		
		var offset = Vector2(breite / 2, laenge / 2)
		for point in points:
			# point ist die globale Ziegelposition auf dem Dach (linke obere Ecke)
			# Für die Zeichnung brauchen wir die Mitte des Ziegel in dem Ursprung
			# des Koordinatensystems, damit wird die Zeichnung einfach rotieren, skalieren 
			# und verschieben können.
			translated_points.append( point - position - offset)
		
		node.set_polygon(translated_points)
		node.texture_offset = offset


func zeichne(node, translate=Vector2(0,0)):
	var points = get_ziegel_polygon_points()
	if istGeschnitten:
		var translated_points = []
		for point in points:
			translated_points.append( point + translate)
	
		var colors = []
		if istAusgewaelt:
			colors.append(Color("000000"))
		else:
			colors.append(Color("353535"))
			
		node.draw_polygon(translated_points, colors)
		var circleRadius = 5 / get_scale_avg(node)
		node.draw_circle(get_zentrum() + translate, circleRadius, Color("FFFF00"))
		
		var lastPoint = translated_points[translated_points.size() - 1]
		for point in translated_points:
			var linie = linieClass.new(lastPoint, point);
			lastPoint = point
			zeichne_linie(linie, node)



func zeichne_linie(linie, node, translate=Vector2(0,0), color = Color("FFFFFF"), width=3.0):
	var scaleAvg = get_scale_avg(node)
	var ajustedWidth = width / scaleAvg
	node.draw_line(linie.p1 + translate, linie.p2 + translate, color, ajustedWidth)


func get_bounding_box():
	var bounding_box = Rect2(position, Vector2(einstellungen.ziegelTyp.breite, einstellungen.ziegelTyp.laenge))
	return bounding_box


func set_ausgewaelt(_istAusgewaelt):
	istAusgewaelt = _istAusgewaelt


func get_ziegel_polygon_points():
	var polygon_punkte
	var schnittlinie = einstellungen.schnittlinie.get_laengere_linie(2)
	
	var ecken = get_eckpunkte()
	# Erster und letzter Element ist die gleiche Ecke
	ecken.append(position)
	var ecken_und_schnittpunkte = []
	
	# Beim richtigen Schnitt quer durch den Ziegel erhalten wir exakt 2 Schnittpunkte  
	# Wird nur die Ecke an einem Punkt geschreift, so erhalten wir 1 Schnittpunkt
	# Verfehlt die Schnittlinie den Ziegel so ist dieser Array leer
	var schnittpunkte = []
	
	# Wir gehen alle Ecken im Urzeigersinn durch und kopieren die Ecken nach ecken_und_schnittpunkte
	# Außerdem suchen wir nach Schnittpunkten zwischen zwei Ecken und 
	# platzieren diese ebenfalls in ecken_und_schnittpunkte
	var ecke1 = ecken.front()
	for ecke2 in ecken:
		if ecke1 == ecke2:
			continue
			
		ecken_und_schnittpunkte.append(ecke1)
		
		# Wenn Schnittpunkt zwischen ecke1 und ecke2 existiert dann diesen auch hinzufügen
		# Der Schnittpunkt wird dann zwischen ecke1 und ecke2 hinzugefügt
		var linie = create_linie(ecke1, ecke2)#.get_laengere_linie()
		var schnittpunkt = linie.get_schnittpunkt(schnittlinie)
		if null != schnittpunkt:
			ecken_und_schnittpunkte.append(schnittpunkt)
			schnittpunkte.append(schnittpunkt)
		
		ecke1 = ecke2
	
	# Falls die Schnittlinie den Ziegel in 2 Punkten schneidet, dann brauchen wir den 
	# Polygon, dessen Start- und Entpunkt unsere Schnittpunkte sind. 
	if schnittpunkte.size() == 2:
		var startpunkt = get_startpunkt(schnittpunkte)
		istGeschnitten = true
		
		# Wir verschieben die Punkte von vorne des Arrays nach
		# hinten solange, bis wir den richtigien Schnittpunkt 
		# am Anfang des Arrays haben.
		var punkt = ecken_und_schnittpunkte.front()
		ecken_und_schnittpunkte.pop_front()
		while startpunkt != punkt:
			ecken_und_schnittpunkte.push_back(punkt)
			punkt = ecken_und_schnittpunkte.front()
			ecken_und_schnittpunkte.pop_front()
		ecken_und_schnittpunkte.push_front(punkt)
		
		# Wir entfernen hinten unnötige Punkte so,
		# dass wir hinten auch ein Schnittpunkt haben
		punkt = null
		while !schnittpunkte.has(punkt):
			punkt = ecken_und_schnittpunkte.back()
			ecken_und_schnittpunkte.pop_back()
		ecken_und_schnittpunkte.push_back(punkt)
		
		polygon_punkte = ecken_und_schnittpunkte
	else:
		# Falls es keine oder nur ein Schnittpunkt gab,
		# So besteht unser Polygon nur aus Eckpunkten
		ecken.pop_back() # Letzter und erster Punkt waren ja gleich
		polygon_punkte = ecken
	
	return polygon_punkte


# Wählt den Startpunkt eines Ziegelpoygons aus den zwei existierenden Schnittpunkten aus
# Handelt es sich um ein Grat, so wird der Punkt mit dem größeren y ausgewhält 
# Handelt es sih um die Kehle, so wird der PUnkt mit dem kleineren y ausgwählt
# Dies bewirkt, dass wir den oberen oder den unteren Teil des Ziegels als Ziegelpolygon erhalten. 
func get_startpunkt(schnittpunkte):
	var schnittpunkt_mit_groesserem_x
	var schnittpunkt_mit_kleinerem_x
	
	if schnittpunkte[0].x  <  schnittpunkte[1].x:
		schnittpunkt_mit_groesserem_x = schnittpunkte[1]
		schnittpunkt_mit_kleinerem_x = schnittpunkte[0]
	else:
		schnittpunkt_mit_groesserem_x = schnittpunkte[0]
		schnittpunkt_mit_kleinerem_x = schnittpunkte[1]
	
	if einstellungen.istGrat:
		return schnittpunkt_mit_groesserem_x
	else:
		return schnittpunkt_mit_kleinerem_x


func get_scale_avg(node):
	return (node.scale.x + node.scale.y) / 2


func println():
	print("Position : ", position)
	var bounding_box = get_bounding_box()
	print("Bounding box: " , bounding_box.end)


func to_maschine_string(separator = ""):
	var reiheStr = "%02d" % reihe
	var nummerStr = "%02d" % nummer
	var distanzStr = "%03+d" % get_distanz_von_schnittlinie_zum_zentrum()
	var windelV = get_winkel_zu_vertikale()
	var winkelStr = "%04d" % (windelV * 10)
	var vorschubFlexStr = "VVV"
	return reiheStr +  separator + nummerStr +  separator + distanzStr +  separator + winkelStr +  separator + vorschubFlexStr