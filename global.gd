extends Node

var bluetooth

signal connected
signal disconnected
signal data_received


func _ready():
	if(Globals.has_singleton("GodotBluetooth")):
		bluetooth = Globals.get_singleton("GodotBluetooth")
		bluetooth.init(get_instance_ID(), false)


#GodotBluetooth Callbacks
func _on_connected(device_name, device_adress):
	emit_signal("connected")
	pass

func _on_disconnected():
	emit_signal("disconnected")
	pass

func _on_data_received(data_received):
	emit_signal("data_received", data_received)
	pass