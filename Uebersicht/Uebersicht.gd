extends ColorFrame

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
	var position = Vector2(1300, 50)
	ziegel = ziegelClass.new(einstellungen, position)
	ziegel.set_ausgewaelt(true)
	ziegel.println()



func _ready():
	var bounding_box = ziegel.get_bounding_box()	
	scale_node(bounding_box)

func _draw():
	ziegel.zeichne(self)
	
	
func _on_Button_pressed():
	emit_signal("uebersicht_pressed")
	
# TODO konsolidieren
func scale_node(bounding_box) :
	var viewport_size = self.get_viewport_rect().size
	var x = viewport_size.x / bounding_box.end.x  * 0.95
	var y = viewport_size.y / bounding_box.end.y  * 0.95
	var k = min(x, y)
	var pos = self.get_pos()
	self.set_pos(Vector2(0,0))
	set_scale(Vector2(k,k))
	self.set_pos(pos)


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		print("uebersicht_verlassen")
		emit_signal("uebersicht_verlassen")