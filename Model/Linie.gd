extends Reference

var p1 setget p1_set, p1_get
var p2 setget p2_set, p2_get

var linieClass = load("res://Model/Linie.gd")


func _init(_p1, _p2):
	p1 = _p1
	p2 = _p2


func init(dictionary):
	p1.x = dictionary.p1x
	p1.y = dictionary.p1y
	p2.x = dictionary.p2x
	p2.y = dictionary.p2y


func p1_set(_p1):
	p1 = _p1
	
func p1_get():
	return p1

func p2_set(_p2):
	p2 = _p2
	
func p2_get():
	return p2
	
func get_laenge() :
	return p1.distance_to(p2)


func get_min_x():
	return min(p1.x, p2.x)


func get_max_x():
	return max(p2.x, p2.x)


func get_steigung():
	var dx = p1.x - p2.x
	var dy = p1.y - p2.y
	var steigung = dx / dy
	return steigung


func get_laengere_linie(koeffizient=null) : 
	if koeffizient == null:
		# koeffizient entspricht der verlaengerung um 2mm
		var distance = p1.distance_to(p2)
		koeffizient = 1 + 1 / distance
	
	# erstes Ende 
	var null_vector_p1 = p1 * -1
	var p2_null = p2 + null_vector_p1
	var p2_lang = p2_null * koeffizient
	var p2_neu = p2_lang + p1
	
	# zweites Ende vergößern
	var null_vector_p2 = p2 * -1	
	var p1_null = p1 + null_vector_p2
	var p1_lang = p1_null * koeffizient
	var p1_neu = p1_lang + p2
	
	return linieClass.new(p1_neu, p2_neu)


# векторное произведение
func vector_mult(ax, ay, bx, by) : 
	return ax*by-bx*ay;

# проверка пересечения         
func areCrossing(p1, p2, p3, p4) :                                                              
	var v1 = vector_mult(p4.x - p3.x, p4.y - p3.y, p1.x - p3.x, p1.y - p3.y)
	var v2 = vector_mult(p4.x - p3.x, p4.y - p3.y, p2.x - p3.x, p2.y - p3.y)
	var v3 = vector_mult(p2.x - p1.x, p2.y - p1.y, p3.x - p1.x, p3.y - p1.y)
	var v4 = vector_mult(p2.x - p1.x, p2.y - p1.y, p4.x - p1.x, p4.y - p1.y)
	
	return   v1 * v2 < 0 && v3 * v4 < 0


# коэффициенты уравнения прямой вида: ax+by+C=0
func berechne_parameter_der_geradengleichung(p1, p2):                                                                    
	var a = p2.y - p1.y                                            
	var b = p1.x - p2.x
	var c = -p1.x * (p2.y-p1.y) + p1.y * (p2.x - p1.x)
	return Vector3(a, b, c)


# поиск точки пересечения
func berechne_schnittpunkt(a1, b1, c1, a2, b2, c2):
	var d = a1 * b2 - b1 * a2
	var dx = -c1 * b2 + b1 * c2
	var dy = -a1 * c2 + c1 * a2
	var x = dx / d
	var y = dy / d
	var schnittpunkt = Vector2(x, y)
	# print("hura", schnittpunkt)
	return schnittpunkt


func get_schnittpunkt(linie) :
	var p1 = linie.p1
	var p2 = linie.p2
	var p3 = self.p1
	var p4 = self.p2
	
	if areCrossing(p1, p2, p3, p4):            
		var gleichung = berechne_parameter_der_geradengleichung(p1, p2)
		var a1 = gleichung.x 
		var b1 = gleichung.y 
		var c1 = gleichung.z

		gleichung = berechne_parameter_der_geradengleichung(p3, p4)
		var a2 = gleichung.x 
		var b2 = gleichung.y 
		var c2 = gleichung.z
                
		return berechne_schnittpunkt(a1, b1, c1, a2, b2, c2)
		        
	else :
		return null

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
func get_normale(punkt):
	var a = p2 - p1
	var x = (a.x * a.y * (punkt.y - p1.y) + p1.x * pow(a.y, 2) + punkt.x * pow(a.x,2)) / (pow(a.y,2) + pow(a.x,2)+0.0001)
	var y = a.y * (x - p1.x) / (a.x) + p1.y 
	return linieClass.new(punkt, Vector2(x,y))


func get_winkel_zu_vertikale_rad() :
	var rad = p1.angle_to_point(p2)
	return rad

func get_winkel_zu_vertikale() :
	var rad = p1.angle_to_point(p2)
	var degree = rad * 180 / PI
	return degree


func get_winkel_zu_horizontale() :
	return 90.0 - get_winkel_zu_vertikale()
	


func clone():
	var clone = linieClass.new(p1, p2)
	return clone


func to_dictionary():
	var d = {
		p1x = p1.x,
		p1y = p1.y,
		
		p2x = p2.x,
		p2y = p2.y,
	}
	return d