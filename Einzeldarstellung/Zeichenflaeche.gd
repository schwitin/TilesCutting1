extends Node2D

var ziegel


func _ready():
	scale_node()

func set_ziegel(_ziegel):
	ziegel = _ziegel
	scale_node()
	update()
	

# alte methode zum Zeichcnen des Zigels in der Einzeleinsicht
#func _draw():
	#if null != ziegel:
		#var bounding_box = ziegel.get_bounding_box()
		#ziegel.zeichne(self,  -bounding_box.position - bounding_box.size / 2)


# TODO konsolidieren
func scale_node() :
	if ziegel == null:
		return
	var bounding_box = ziegel.get_bounding_box()
	var schnittlinie = ziegel.einstellungen.schnittlinie
	
	var viewport_size = self.get_viewport_rect().size
	var x = viewport_size.x / bounding_box.size.x  * 0.80
	var y = viewport_size.y / bounding_box.size.y  * 0.80
	var k = min(x, y)
	#var pos = self.position
	
	position = Vector2(viewport_size.x / 3, viewport_size.y / 2)
	rotation = schnittlinie.get_winkel_zu_vertikale_rad() + PI
	scale = Vector2(k,k)
