extends Reference

var node

func _init(_node):
	node = _node


	
func zeichne_linie(line, farbe):
	print("hura")
	node.draw_line(line.p1, line.p2, farbe)
	
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points+1):
        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        node.draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func draw_circle(center, farbe):
	var radius = 10
	var angle_from = 0
	var angle_to = 360	
	node.draw_circle_arc(center, radius, angle_from, angle_to, farbe)
	
