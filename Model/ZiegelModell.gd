extends Reference

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var rect = null setget rect_set, rect_get

var typ = null

var linieClass  = null
var ziegelModelClass = null
	
var nummer = -1

func _init(_position, _typ):
	typ = _typ
	rect = Rect2(_position, _typ.groesse)
	
	linieClass = load("res://Model/Linie.gd")
	ziegelModelClass = load("res://Model/ZiegelModell.gd")
	
func rect_get():
	return rect

func rect_set(_rect):
	rect = _rect
	
func get_link_seite():
	return linieClass.new(Vector2(rect.position.x, rect.position.y), Vector2(rect.position.x, rect.position.y + rect.size.y))
	
func get_rechte_seite():
	return linieClass.new(Vector2(rect.position.x + rect.size.x, rect.position.y), Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y))
	
func get_untere_seite():
	return linieClass.new(Vector2(rect.position.x, rect.position.y + rect.size.y), Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y))
	
func get_obere_seite():
	return linieClass.new(Vector2(rect.position.x, rect.position.y), Vector2(rect.position.x + rect.size.x, rect.position.y))
	
func get_diagonale_1():
	return linieClass.new(
		Vector2(rect.position.x, rect.position.y), 
		Vector2(rect.position.x + rect.size.x, rect.position.y + rect.size.y)
		)

func get_diagonale_2():
	return linieClass.new(
		Vector2(rect.position.x + rect.size.x, rect.position.y), 
		Vector2(rect.position.x, rect.position.y + rect.size.y)
		)

func get_zenter():
	var diagonale1 = get_diagonale_1()
	var diagonale2 = get_diagonale_2()
	var schnittpunkt = diagonale1.get_schnittpunkt(diagonale2)
	return schnittpunkt

# http://www.cyberforum.ru/cpp-beginners/thread1503781-page2.html
# Отрезок:
# A (x1,y1)
# B (x2,y2)
#
# Точка:
# C (x3,y3)
#
# a0=x2-x1
# a1=y2-y1
# x4=(a0*a1*(y3-y1)+x1*a1^2+x3*a0^2)/(a1^2+a0^2)
# y4=a1*(x4-x1)/a0+y1
func get_normale(punkt, linie):
	var a = linie.p2 - linie.p1
	var x = (a.x * a.y * (punkt.y - linie.p1.y) + linie.p1.x * pow(a.y, 2) + punkt.x * pow(a.x,2)) / (pow(a.y,2) + pow(a.x,2)+0.0001)
	var y = a.y * (x - linie.p1.x) / (a.x) + linie.p1.y 
	return linieClass.new(punkt, Vector2(x,y))


func get_schnittlinie(linie) : 
	var schnittpunkte = get_schnittpunkte(linie)
	if schnittpunkte != null :
		return linieClass.new(schnittpunkte[0], schnittpunkte[1])
	else :
		return null
	
func get_schnittpunkte(linie) : 
	var schnittpunkte = []
	var schnittpunkt = linie.get_schnittpunkt(get_link_seite())
	if schnittpunkt != null :
		schnittpunkte.append(schnittpunkt)
		
	schnittpunkt = linie.get_schnittpunkt(get_rechte_seite())
	if schnittpunkt != null :
		schnittpunkte.append(schnittpunkt)
		
	schnittpunkt = linie.get_schnittpunkt(get_obere_seite())
	if schnittpunkt != null :
		schnittpunkte.append(schnittpunkt)
		
	schnittpunkt = linie.get_schnittpunkt(get_untere_seite())
	if schnittpunkt != null :
		schnittpunkte.append(schnittpunkt)
	
	if schnittpunkte.size() == 2 && schnittpunkte[0].distance_to(schnittpunkte[1]) > 4:
		return schnittpunkte
	else :
		return null
		
func clone() :
	var clone = ziegelModelClass.new(rect.position, typ)
	clone.nummer = nummer
	return clone
	
