extends VBoxContainer

# model
var einstellungen


signal einstellungen_visualisieren
signal einstellungen_cahnged
signal einstellungen_verlassen

func _init():
	#test()
	pass

func init(_einstellungen):
	einstellungen = _einstellungen


func test():
	var einstellungenClass = preload("res://Model/Einstellungen.gd")
	init(einstellungenClass.new("dummy"))


func _ready():
	if einstellungen != null:
		var _ueberschrift = get_node("Ueberschrift")
		var _ziegelTypInput = get_node("GridContainer/ZiegelTypInput")
		var _schnuereBereicheInput = get_node("GridContainer/SchnuereBereichInput")
		var _lattenBereicheInput = get_node("GridContainer/LattenBereichInput")
		var _schnittlinieInput = get_node("GridContainer/SchnittlinieInput")
		_ueberschrift.set_text(einstellungen.dachName + " " + einstellungen.name)
		_ziegelTypInput.set_ziegel_typ(einstellungen.ziegelTyp)
		_schnuereBereicheInput.init("S", einstellungen)
		_lattenBereicheInput.init("L", einstellungen)
		_schnittlinieInput.init(einstellungen)
	
	#global.connect("connected", self, "_on_connected")
	#global.connect("disconnected", self, "_on_disconnected")


func _on_VisualisierenButton_pressed():
	#print("einstellungen_uebernehmen")
	emit_signal("einstellungen_visualisieren")


func _on_ZiegelInput_changed( ziegelTyp ):
	einstellungen.set_ziegel_typ(ziegelTyp)
	var schnuereBereichInputNode = get_node("GridContainer/SchnuereBereichInput")
	var lattenBereichInputNode = get_node("GridContainer/SchnuereBereichInput")
	var schnittlinieInputNode = get_node("GridContainer/SchnittlinieInput")
	schnuereBereichInputNode.update_text()
	lattenBereichInputNode.update_text()
	schnittlinieInputNode.update_text()
	emit_signal("einstellungen_cahnged")


func _on_schnuere_oder_latten_bereiche_changed():
	einstellungen.init_schnittlinie()
	var schnittlinieInputNode = get_node("GridContainer/SchnittlinieInput")
	schnittlinieInputNode.update_control()
	emit_signal("einstellungen_cahnged")


func _on_SchnittlinieInput_schnittlinie_changed():
	emit_signal("einstellungen_cahnged")



func _on_VerbindenButton_pressed():
	var a = global
	if global.bluetooth:
		global.bluetooth.getPairedDevices(true)
	else:
		print("Module not initialized!")


func _on_disconnected():
	get_node("GridContainer/ConnectButton").set_text("Maschine verbinden")


func _on_connected():
	get_node("ConnectButton").text = "Verbindung beenden"


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST : 
		var schnuerePopup = get_node("GridContainer/SchnuereBereichInput/PopupPanel")
		if schnuerePopup.is_visible():
			schnuerePopup.hide()
			return
		
		var lattenPopup = get_node("GridContainer/LattenBereichInput/PopupPanel")
		if lattenPopup.is_visible():
			lattenPopup.hide()
			return
		
		var schnittliniePopup = get_node("GridContainer/SchnittlinieInput/PopupPanel")
		if schnittliniePopup.is_visible():
			schnittliniePopup.hide()
			return
		
		var ziegelTypPopup = get_node("GridContainer/ZiegelTypInput/Items")
		if ziegelTypPopup.is_visible():
			ziegelTypPopup.hide()
			return
		
		emit_signal("einstellungen_verlassen")