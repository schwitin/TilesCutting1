extends Node2D

var einstellungen

signal uebersicht_pressed()
signal uebersicht_verlassen()
signal aktueller_ziegel(aktuellerZiegel)

var alle_ziegel = []


func _init():
	# Wir brauchen das, damit der Scene-Editor funktioniert.
	# Einstellungen werden von der Root-Scene neu gesetzt und dieses hier verworfen
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	init(einstellungenClass.new())


func init(_einstellungen):
	einstellungen = _einstellungen


func _ready():
	var ziegelPositionen = einstellungen.get_ziegel_positionen()
	var ziegelClass = preload("res://Model/Ziegel.gd")#
	if alle_ziegel.size() == 0:
		var ziegelNr = 1
		for position in ziegelPositionen:
			print(position)
			var ziegel = ziegelClass.new(einstellungen, position)
			if ziegel.istGeschnitten:
				ziegel.nummer = ziegelNr
				ziegelNr += 1
				alle_ziegel.append(ziegel)
		set_naechster_ziegel(null)
	# einstellungen.connect("schnittlinie_changed", self, "on_schnittlinie_changed")
	scale_node()
	update()
	

func _draw():
	for z in alle_ziegel:
		z.zeichne(self, Vector2(10, 30))


func on_schnittlinie_changed():
	set_naechster_ziegel(null)

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
	get_node("Button").set_scale(Vector2(100,100))

func set_naechster_ziegel(aktuellerZiegel):
	var index = alle_ziegel.find_last(aktuellerZiegel)
	if(index < alle_ziegel.size() - 1):
		var naechsterZiegel = alle_ziegel[index + 1]
		ziegel_auswaelen(aktuellerZiegel, naechsterZiegel)


func set_vorheriger_ziegel(aktuellerZiegel):
	var index = alle_ziegel.find_last(aktuellerZiegel)
	if(index > 0):
		var naechsterZiegel = alle_ziegel[index - 1]
		ziegel_auswaelen(aktuellerZiegel, naechsterZiegel)


func ziegel_auswaelen(aktuellerZiegel, naechsterZiegel):
	if aktuellerZiegel != null:
		aktuellerZiegel.set_ausgewaelt(false)
	naechsterZiegel.set_ausgewaelt(true)
	emit_signal("aktueller_ziegel", naechsterZiegel)


func _on_Button_pressed():
	emit_signal("uebersicht_pressed")


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		print("uebersicht_verlassen")
		alle_ziegel.clear()
		emit_signal("uebersicht_verlassen")

