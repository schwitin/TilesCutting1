extends Reference

var position
var einstellungen

var istAusgewaelt  = false setget set_ausgewaelt
var istGeschnitten = true


var linieClass = preload("res://Model/Linie.gd")


func _init(_einstellungen, _position):
	einstellungen = _einstellungen
	position = _position


func get_linien():
	var linien = []
	var laenge = einstellungen.ziegelTyp.laenge
	var breite = einstellungen.ziegelTyp.breite

	var p1 = position
	var p2 = Vector2(position.x + breite, position.y)
	var p3 = Vector2(position.x + breite, position.y + laenge)
	var p4 = Vector2(position.x, position.y + laenge)
	
	linien.append(create_linie(p1, p2))
	linien.append(create_linie(p2, p3))
	linien.append(create_linie(p3, p4))
	linien.append(create_linie(p4, p1))
	
	return linien


func create_linie(p1, p2):
	return linieClass.new(p1, p2)


func zeichne(node, translate=Vector2(0,0)):
	var points = get_ziegel_polygon_points()
	if istGeschnitten:
		var translated_points = []
		for point in points:
			translated_points.append( point + translate)
	
		var colors = []
		colors.append(Color("FFFFFF"))
		#node.draw_polygon(translated_points, colors)
		
		var linien = get_linien()
		for linie in linien:
			zeichne_linie(linie, node, translate)
		
		zeichne_linie(einstellungen.schnittlinie, node, translate)


func zeichne_linie(linie, node, translate):
	var width = 1.0
	if istAusgewaelt:
		width = 2.0
	
	# print(linie.p1, linie.p2)
	node.draw_line(linie.p1 + translate, linie.p2 + translate, Color("FFFFFF"), width)


func get_bounding_box():
	var bounding_box = Rect2(position, Vector2(einstellungen.ziegelTyp.breite, einstellungen.ziegelTyp.laenge))
	return bounding_box
	
func set_ausgewaelt(_istAusgewaelt):
	istAusgewaelt = _istAusgewaelt


func get_ziegel_polygon_points():
	var polygon_punkte
	var schnittlinie = einstellungen.schnittlinie.get_laengere_linie()
	
	var ecken = get_eckpunkte()		# Erster und letzter Element ist die gleiche Ecke
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
		var linie = create_linie(ecke1, ecke2).get_laengere_linie()
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


func get_eckpunkte():
	var ecken = []
	ecken.append(position)
	ecken.append(Vector2(position.x + einstellungen.ziegelTyp.breite, position.y))
	ecken.append(Vector2(position.x + einstellungen.ziegelTyp.breite, position.y + einstellungen.ziegelTyp.laenge))
	ecken.append(Vector2(position.x, position.y + einstellungen.ziegelTyp.laenge))
	ecken.append(position)
	return ecken


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


func println():
	print("Position : ", position)
	var bounding_box = get_bounding_box()
	print("Bounding box: " , bounding_box.end)