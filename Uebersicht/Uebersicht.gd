extends Node2D

var einstellungen

signal uebersicht_pressed()
signal uebersicht_verlassen()

var ziegel


func _init():
	# Wir brauchen das, damit der Scene-Editor funktioniert.
	# Einstellungen werden von der Root-Scene neu gesetzt und dieses hier verworfen
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	var einstellungen = einstellungenClass.new()
	init(einstellungen)


func init(_einstellungen):
	einstellungen = _einstellungen
	var ziegelTyp = einstellungen.ziegelTyp
	var ziegelClass = preload("res://Model/Ziegel.gd")
	var position = Vector2(100, 100)
	ziegel = ziegelClass.new(einstellungen, position)
	ziegel.set_ausgewaelt(true)
	ziegel.println()



func _ready():
	var bounding_box = ziegel.get_bounding_box()	
	scale_node(bounding_box)

func _draw():
	var bounding_box = ziegel.get_bounding_box()
	ziegel.zeichne(self,  -bounding_box.pos - bounding_box.size / 2)
	
	
func _on_Button_pressed():
	emit_signal("uebersicht_pressed")
	
# TODO konsolidieren
func scale_node(bounding_box) :
	var bounding_box = ziegel.get_bounding_box()
	var schnittlinie = einstellungen.schnittlinie
	
	var viewport_size = self.get_viewport_rect().size
	var x = viewport_size.x / bounding_box.end.x  * 0.90
	var y = viewport_size.y / bounding_box.end.y  * 0.90
	var k = min(x, y)
	var pos = self.get_pos()
	
	set_pos(Vector2(viewport_size.x / 3, viewport_size.y / 2))
	set_rot(-schnittlinie.get_winkel_zu_vertikale_rad() + PI)
	set_scale(Vector2(k,k))


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		print("uebersicht_verlassen")
		emit_signal("uebersicht_verlassen")