extends LightOccluder2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var radius: float = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	_setBarrier(_calculateCircle(radius))

func _process(delta):
	_moveBarrier()
	#draw_circle(get_parent().transform.get_origin(),5,Color.red)

func _moveBarrier():
	var mousePos = get_global_mouse_position()
	var angle = (mousePos - get_parent().rect_global_position).angle()
	get_parent().rect_rotation = rad2deg(angle)
	#print(str(mousePos) + " " +  str(angle))
	
func _setBarrier(points):
	self.occluder.polygon = points
	
	
func _calculateCircle(radius):
	var points = PoolVector2Array()
	for i in range(60):
		points.push_back(Vector2(radius*cos(deg2rad(330-2*i)), radius*sin(deg2rad(330-2*i))))
	for j in range(60):
		points.push_back(Vector2((radius-1)*cos(deg2rad(150+2*j)), (radius-1)*sin(deg2rad(150+2*j))))	
	return points
