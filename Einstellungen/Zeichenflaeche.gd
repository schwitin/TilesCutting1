extends Node2D

var classEinstellungen = preload("res://Model/Einstellungen1.gd")
var classDach = preload("res://Model/Dach1.gd")
var dach = null setget dach_set

func _init():
	self.dach = classDach.new(classEinstellungen.new()) 

func _ready():
	scale_node()
	pass
	

func dach_set(_dach) : 
	dach = _dach
	dach.connect("changed", self, "update")
	##scale_node()
	
	
func _draw():
	#draw_rect(Rect2( Vector2(0,0), Vector2(1000,1000)), Color("ffffff"))
	draw_schnuere()
	draw_latten()
	draw_schnittlinie()
	

func draw_schnittlinie():
	var schnittline = dach.get_schnittlinie_bis_bounding_box()
	# print (schnittline.get_steigung())
	zeichne_linie(schnittline)
	
func draw_schnuere() :
	var linien = dach.get_schnuere_grat()
	#var linien = dach.get_schnuere()
	for linie in linien:
		zeichne_linie(linie)

func draw_latten() :
	var linien = dach.get_latten_grat()
	#var linien = dach.get_latten()
	for linie in linien:
		zeichne_linie(linie)

func zeichne_linie(line, farbe=Color("ffff00"), dicke=1.0):
	draw_line(line.p1, line.p2, farbe, dicke)
	
func scale_node() :
	if dach != null :
		var viewport_size = self.get_viewport_rect().size
		# var viewport_size = get_viewport().get_visible_rect().size
		var bounding_box = dach.get_bounding_box()
		var x = viewport_size.x / bounding_box.x  * 0.9
		var y = viewport_size.y / bounding_box.y  * 0.9
		var k = min(x, y)
		var pos = self.get_pos()
		self.set_pos(Vector2(0,0))
		set_scale(Vector2(k,k))
		self.set_pos(pos)