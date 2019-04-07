extends Node2D

var classEinstellungen = preload("res://Model/Einstellungen.gd")
var classDach = preload("res://Model/Dach.gd")
var dach
var isOben = false setget set_oben_unten

func _init():
	var dach = classDach.new(classEinstellungen.new()) 
	init(dach)


func init(_dach) : 
	#print("====================")
	if dach != null:
		dach.disconnect("changed", self, "update")
	
	dach = _dach
	dach.connect("changed", self, "update")
	

func set_oben_unten(_isOben):
	isOben = _isOben
	update()

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
	
