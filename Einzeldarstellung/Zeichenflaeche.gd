extends Node2D

var ziegel


func _ready():
	pass

func set_ziegel(_ziegel):
	ziegel = _ziegel
	scale_node()
	update()


func _draw():
	if null != ziegel:
		var bounding_box = ziegel.get_bounding_box()
		ziegel.zeichne(self,  -bounding_box.pos - bounding_box.size / 2)


# TODO konsolidieren
func scale_node() :
	var bounding_box = ziegel.get_bounding_box()
	var schnittlinie = ziegel.einstellungen.schnittlinie
	
	var viewport_size = self.get_viewport_rect().size
	var x = viewport_size.x / bounding_box.size.x  * 0.80
	var y = viewport_size.y / bounding_box.size.y  * 0.80
	var k = min(x, y)
	var pos = self.get_pos()
	
	set_pos(Vector2(viewport_size.x / 3, viewport_size.y / 2))
	set_rot(-schnittlinie.get_winkel_zu_vertikale_rad() + PI)
	set_scale(Vector2(k,k))
