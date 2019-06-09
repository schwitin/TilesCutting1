extends Node2D

var einstellungen
var alleZiegelReihen

signal uebersicht_pressed()
signal uebersicht_verlassen()
signal aktueller_ziegel(aktuellerZiegel)

var classDach = preload("res://Model/Dach.gd")


func _init():
	# Unkommentieren, wenn dieses Szene einzeln zum Testen gestertet wird
	# test()
	pass


func init(_einstellungen):
	einstellungen = _einstellungen
	update_ziegel()

func test():
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	init(einstellungenClass.new("dummy"))


func update_ziegel():
	var dach = classDach.new(einstellungen)
	alleZiegelReihen = dach.get_ziegel()
	update()


func _ready():
	scale_node()
	update()

# Zeichnet alle Ziegel von unten nach oben und von rechts nach links
func _draw():
	if alleZiegelReihen != null:
		for i in range(alleZiegelReihen.size()):
			var reihe = alleZiegelReihen[alleZiegelReihen.size() - i - 1]
			for j in range(reihe.size()):
				var ziegel = reihe[reihe.size() - j - 1]
				ziegel.zeichne(self)


func on_schnittlinie_changed():
	set_naechster_ziegel(null)


func scale_node() :
	if alleZiegelReihen != null:
		var ersterZiegel = alleZiegelReihen[0][0]
		var letzteReihe = alleZiegelReihen[alleZiegelReihen.size() - 1]
		var letzerZiegel = letzteReihe[letzteReihe.size() - 1]
		var ziegelTyp = ersterZiegel.einstellungen.ziegelTyp
		
		var bounding_box = Vector2(letzerZiegel.position.x + ziegelTyp.deckBreite, letzerZiegel.position.y + ziegelTyp.versatzY + ziegelTyp.deckLaengeMax)
		
		var viewport_size = self.get_viewport_rect().size
		var x = viewport_size.x / bounding_box.x  * 0.95
		var y = viewport_size.y / bounding_box.y  * 0.95
		var k = min(x, y)
		var pos = self.get_pos()
		set_scale(Vector2(k,k))
		set_pos(Vector2(10, ziegelTyp.versatzY + 10))
		get_node("Button").set_scale(Vector2(100,100))


func set_naechste_reihe(aktuellerZiegel):
	if (aktuellerZiegel == null):
		ziegel_auswaelen(null, alleZiegelReihen[0][0])
		return

	var aktuelleReihe = alleZiegelReihen[aktuellerZiegel.reihe - 1] # reihe fängt mit 1 an
	if aktuellerZiegel.reihe < alleZiegelReihen.size(): # riehe fängt mir 1 an 
		var naechsteReihe = alleZiegelReihen[aktuellerZiegel.reihe]
		var naechsterZiegel = naechsteReihe[0]
		ziegel_auswaelen(aktuellerZiegel, naechsterZiegel)


func set_vorherige_reihe(aktuellerZiegel):
	if (aktuellerZiegel == null):
		ziegel_auswaelen(null, alleZiegelReihen[0][0])
		return
	
	if aktuellerZiegel.reihe > 1:
		var vorherigeReihe = alleZiegelReihen[aktuellerZiegel.reihe - 2]
		var naechsterZiegel = vorherigeReihe[0]
		ziegel_auswaelen(aktuellerZiegel, naechsterZiegel)


func set_naechste_nummer(aktuellerZiegel):
	if (aktuellerZiegel == null):
		ziegel_auswaelen(null, alleZiegelReihen[0][0])
		return
	
	var aktuelleReihe = alleZiegelReihen[aktuellerZiegel.reihe - 1] # reihe fängt mit 1 an
	var aktuelleNummerInDerReihe = aktuellerZiegel.nummer # fängt mit 1 an
	var hatNachtenZiegel = aktuelleNummerInDerReihe < aktuelleReihe.size()
	if hatNachtenZiegel:
		var naechsterZiegel = aktuelleReihe[aktuelleNummerInDerReihe]
		ziegel_auswaelen(aktuellerZiegel, naechsterZiegel)


func set_vorherige_nummer(aktuellerZiegel):
	if (aktuellerZiegel == null):
		ziegel_auswaelen(null, alleZiegelReihen[0][0])
		return
	
	var aktuelleReihe = alleZiegelReihen[aktuellerZiegel.reihe - 1]
	var aktuelleNummerInDerReihe = aktuellerZiegel.nummer # fängt mit 1 an
	var hatVorherigenZiegel = aktuelleNummerInDerReihe > 1
	if hatVorherigenZiegel:
		var vorherigerZiegel = aktuelleReihe[aktuelleNummerInDerReihe-2]
		ziegel_auswaelen(aktuellerZiegel, vorherigerZiegel)


func ziegel_auswaelen(aktuellerZiegel, naechsterZiegel):
	if aktuellerZiegel != null:
		aktuellerZiegel.set_ausgewaelt(false)
	naechsterZiegel.set_ausgewaelt(true)
	#update()
	emit_signal("aktueller_ziegel", naechsterZiegel)


func _on_Button_pressed():
	emit_signal("uebersicht_pressed")


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		print("uebersicht_verlassen")
		#alleZiegelReihen = null
		emit_signal("uebersicht_verlassen")

