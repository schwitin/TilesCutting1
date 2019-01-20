extends Node2D

var classEinstellungen = preload("res://Model/Einstellungen2.gd")
var classDach = preload("res://Model/Dach1.gd")
var dach = null setget dach_set
var isOben = false

func _init():
	self.dach = classDach.new(classEinstellungen.new()) 

func _ready():
	#scale_node()
	pass
	

func dach_set(_dach) : 
	print("====================")
	dach = _dach
	dach.connect("changed", self, "update")
	##scale_node()
	
	
func _draw():
	#draw_rect(Rect2( Vector2(0,0), Vector2(1000,1000)), Color("ffffff"))
	draw_schnuere()
	draw_latten()
	draw_schnittlinie()
	draw_abstand()
	
	

func draw_abstand():
	var abstand
	if self.isOben:
		abstand = dach.get_linie_von_schnittlinie_zum_naechsten_schnur_oben()
	else:
		abstand = dach.get_linie_von_schnittlinie_zum_naechsten_schnur_unten()
	
	zeichne_linie(abstand, Color("#FFFFFF"), 5.0)
	
	

func draw_schnittlinie():
	var schnittline = dach.get_schnittlinie()
	# print (schnittline.get_steigung())
	zeichne_linie(schnittline)
	
func draw_schnuere() :
	var linien
	if dach.is_grat:
		linien = dach.get_schnuere_grat()
	else:
		linien = dach.get_schnuere_kehle()
	
	#var linien = dach.get_schnuere()
	for linie in linien:
		zeichne_linie(linie)

func draw_latten() :
	
	var linien
	if dach.is_grat:
		linien = dach.get_latten_grat()
	else:
		linien = dach.get_latten_kehle()
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
		var x = viewport_size.x / bounding_box.x  * 0.99
		var y = viewport_size.y / bounding_box.y  * 0.94
		var k = min(x, y)
		var pos = self.get_pos()
		self.set_pos(Vector2(0,0))
		set_scale(Vector2(k,k))
		self.set_pos(pos)

func _on_SchnittlinieInput_oben_unten_changed( isOben ):
	self.isOben = isOben
	update()
