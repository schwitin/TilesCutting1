extends PopupDialog

var node_T
var node_B
var node_N
var node_W
var node_H
var node_w
var node_h
var node_S

var einstellungen setget einstellungen_set

signal einstellungen_geaendert(einstellungen)

func _ready():
	node_T = get_node("LinkerContainer/TContainer/Value")
	node_B = get_node("LinkerContainer/BContainer/Value")
	node_N = get_node("LinkerContainer/NContainer/Value")
	node_S = get_node("LinkerContainer/SchnittNeigungContainer/Button")
	
	node_W = get_node("RechterContainer/WContainer/Value")
	node_H = get_node("RechterContainer/HContainer/Value")
	node_w = get_node("RechterContainer/wContainer/Value")
	node_h = get_node("RechterContainer/hContainer/Value")
	
	
	#einstellungen_set(test_einstellungen())

func einstellungen_set(_einstellungen):
	einstellungen = _einstellungen
	node_T.value = abs(einstellungen.abstand_vom_mast_oben)
	node_B.value = abs(einstellungen.abstand_vom_mast_unten)
	node_N.value = einstellungen.anzahl_reihen
	node_W.value = einstellungen.ziegel_typ.groesse.x
	node_H.value = einstellungen.ziegel_typ.groesse.y
	node_w.value = einstellungen.ziegel_typ.ueberlappung.x
	node_h.value = einstellungen.ziegel_typ.ueberlappung.y
	
	print(einstellungen.abstand_vom_mast_oben)
	if einstellungen.abstand_vom_mast_oben < 0:
		node_S.pressed = true
		
	


	

func test_einstellungen():
	var ziegelTypClass = load("res://Model/ZiegelTyp.gd")
	var einstellungenClass = load("res://Model/Einstellungen.gd")
	var ziegel_groesse = Vector2(300, 600)
	var ziegel_ueberlappung = Vector2(50, 100)
	var ziegel_typ = ziegelTypClass.new("Meine Ziegel1", ziegel_groesse, ziegel_ueberlappung)
	var anzahl_reihen = 5
	var abstand_vom_mast_oben = 5000
	var abstand_vom_mast_unten = 1000
	var einstellungen = einstellungenClass.new(abstand_vom_mast_oben, abstand_vom_mast_unten, anzahl_reihen, ziegel_typ)
	return einstellungen


func _on_Ok_pressed():
	var k = 1
	if node_S.pressed :
		k = -1
	einstellungen.abstand_vom_mast_oben = node_T.value  * k
	einstellungen.abstand_vom_mast_unten = node_B.value * k
	einstellungen.anzahl_reihen = node_N.value
	einstellungen.ziegel_typ.groesse.x = node_W.value + 0.01
	einstellungen.ziegel_typ.groesse.y = node_H.value
	einstellungen.ziegel_typ.ueberlappung.x = node_w.value
	einstellungen.ziegel_typ.ueberlappung.y = node_h.value
	emit_signal("einstellungen_geaendert", einstellungen)
