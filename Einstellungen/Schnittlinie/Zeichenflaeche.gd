extends Node2D

var dach
var isOben = false setget set_oben_unten


func init(_dach) :
	dach = _dach
	dach.connect("changed", self, "update")


func set_oben_unten(_isOben):
	isOben = _isOben
	update()


func _draw():
	if dach != null:
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
	
	draw_linie(abstand, Color("#FFFFFF"), 5.0)


func draw_schnittlinie():
	var schnittline = dach.get_schnittlinie()
	draw_linie(schnittline)


func draw_schnuere() :
	var linien
	if dach.isGrat:
		linien = dach.get_schnuere_grat()
	else:
		linien = dach.get_schnuere_kehle()
	
	for linie in linien:
		draw_linie(linie)


func draw_latten():
	var linien
	if dach.isGrat:
		linien = dach.get_latten_grat()
	else:
		linien = dach.get_latten_kehle()
	
	for linie in linien:
		draw_linie(linie)


func draw_linie(line, farbe=Color("ffff00"), dicke=3.5):
	draw_line(line.p1, line.p2, farbe, dicke)