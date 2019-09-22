extends Control

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

func _exit_tree():
	#warning-ignore:return_value_discarded
	global.disconnect("connected", self, "_on_connected")
	#warning-ignore:return_value_discarded
	global.disconnect("disconnected", self, "_on_disconnected")


func _enter_tree():
	if einstellungen != null:
		var _ueberschrift = get_node("VBoxContainer/Ueberschrift")
		var _ziegelTypInput = get_node("VBoxContainer/GridContainer/ZiegelTypInput")
		var _schnuereBereicheInput = get_node("VBoxContainer/GridContainer/SchnuereBereichInput")
		var _lattenBereicheInput = get_node("VBoxContainer/GridContainer/LattenBereichInput")
		var _schnittlinieInput = get_node("VBoxContainer/GridContainer/SchnittlinieInput")
		_ueberschrift.set_text(einstellungen.dachName + " " + einstellungen.name)
		_ziegelTypInput.set_ziegel_typ(einstellungen.ziegelTyp)
		_schnuereBereicheInput.init("S", einstellungen)
		_lattenBereicheInput.init("L", einstellungen)
		_schnittlinieInput.init(einstellungen)
	
	#warning-ignore:return_value_discarded
	global.connect("connected", self, "_on_connected")
	#warning-ignore:return_value_discarded
	global.connect("disconnected", self, "_on_disconnected")

#warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_released("go_back"):
		go_back()


func _on_VisualisierenButton_pressed():
	#print("einstellungen_uebernehmen")
	emit_signal("einstellungen_visualisieren")


func _on_ZiegelTypInput_changed(ziegelTyp):
	einstellungen.set_ziegel_typ(ziegelTyp)
	var schnuereBereichInputNode = get_node("VBoxContainer/GridContainer/SchnuereBereichInput")
	var lattenBereichInputNode = get_node("VBoxContainer/GridContainer/SchnuereBereichInput")
	var schnittlinieInputNode = get_node("VBoxContainer/GridContainer/SchnittlinieInput")
	schnuereBereichInputNode.update_text()
	lattenBereichInputNode.update_text()
	schnittlinieInputNode.update_text()
	emit_signal("einstellungen_cahnged")


func _on_schnuere_oder_latten_bereiche_changed():
	einstellungen.init_schnittlinie()
	var schnittlinieInputNode = get_node("VBoxContainer/GridContainer/SchnittlinieInput")
	schnittlinieInputNode.update_control()
	emit_signal("einstellungen_cahnged")


func _on_SchnittlinieInput_schnittlinie_changed():
	emit_signal("einstellungen_cahnged")



func _on_VerbindenButton_pressed():
	if global.bluetooth:
		global.bluetooth.getPairedDevices(true)
	else:
		get_node("VBoxContainer/VBoxContainer/VerbindenButton").set_disabled(true)
		print("Module not initialized!")


func _on_disconnected():
	get_node("VBoxContainer/VBoxContainer/VerbindenButton").set_text("Maschine verbinden")
	get_node("VBoxContainer/VBoxContainer/SendenButton").set_disabled(true)


func _on_connected():
	get_node("VBoxContainer/VBoxContainer/VerbindenButton").set_text("Verbindung beenden")
	get_node("VBoxContainer/VBoxContainer/SendenButton").set_disabled(false)


func _notification(what):        
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST :
		go_back()


func go_back():
	var schnuerePopup = get_node("VBoxContainer/GridContainer/SchnuereBereichInput/PopupPanel")
	if schnuerePopup.is_visible():
		schnuerePopup.hide()
		return
	
	var lattenPopup = get_node("VBoxContainer/GridContainer/LattenBereichInput/PopupPanel")
	if lattenPopup.is_visible():
		lattenPopup.hide()
		return
	
	var schnittliniePopup = get_node("VBoxContainer/GridContainer/SchnittlinieInput/PopupPanel")
	if schnittliniePopup.is_visible():
		schnittliniePopup.hide()
		return
	
	var ziegelTypPopup = get_node("VBoxContainer/GridContainer/ZiegelTypInput/Items")
	if ziegelTypPopup.is_visible():
		ziegelTypPopup.hide()
		return
	
	emit_signal("einstellungen_verlassen")


func _on_SendenButton_pressed():
	if global.bluetooth:
		get_node("WaitDialog").popup_centered()
		get_node("VBoxContainer/Timer").start()
		var data = einstellungen.to_maschine_string()
		global.bluetooth.sendData("{#" + data + "}")
	else:
		get_node("VBoxContainer/VBoxContainer/SendenButton").set_disabled(true)
		print("Module not initialized!")
		

func _on_Timer_timeout():
	get_node("WaitDialog").hide()

