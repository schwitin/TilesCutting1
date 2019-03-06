extends Node2D

var einstellungen

signal uebersicht_pressed()
signal uebersicht_verlassen()


var alle_ziegel = []


func _init():
	# Wir brauchen das, damit der Scene-Editor funktioniert.
	# Einstellungen werden von der Root-Scene neu gesetzt und dieses hier verworfen
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	init(einstellungenClass.new())


func init(_einstellungen):
	einstellungen = _einstellungen
	


func _ready():
	scale_node()
	update()
	pass

func _draw():
	var ziegelPositionen = einstellungen.get_ziegel_positionen()
	var ziegelClass = preload("res://Model/Ziegel.gd")#
	alle_ziegel.clear()
	for position in ziegelPositionen:
		print(position)
		var ziegel = ziegelClass.new(einstellungen, position)
		alle_ziegel.append(ziegel)
	
	for z in alle_ziegel:
		z.zeichne(self, Vector2(10, 30))


func scale_node() :
	var ziegelTyp = einstellungen.ziegelTyp
	var ziegelPositionen = einstellungen.get_ziegel_positionen()
	var bounding_box = ziegelPositionen.front() + Vector2(ziegelTyp.breite, ziegelTyp.laenge)
	
	var viewport_size = self.get_viewport_rect().size
	var x = viewport_size.x / bounding_box.x  * 0.95
	var y = viewport_size.y / bounding_box.y  * 0.95
	var k = min(x, y)
	var pos = self.get_pos()
	set_scale(Vector2(k,k))
	set_pos(Vector2(10,10))


func _on_Button_pressed():
	emit_signal("uebersicht_pressed")


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		print("uebersicht_verlassen")
		emit_signal("uebersicht_verlassen")







