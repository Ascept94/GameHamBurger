extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var radius: float = 30
export var semiCircle = PoolVector2Array()
export var health: float = 1
export var speed: float = 15000

var pre_joystickpos: Vector2  = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	_setBarrier()
	pass

func _process(delta):
	_moveBarrier()
	pass
	
func _physics_process(delta):
	_movePlayer(delta)
	pass

func _movePlayer(delta):
	var step: Vector2 = Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	)
	move_and_slide(step*delta*speed)
	pass

func _moveBarrier():
	var mousePos = get_global_mouse_position()
	var joystickPos = Vector2(
		Input.get_action_strength("move_barrier_left")-Input.get_action_strength("move_barrier_right"),
		Input.get_action_strength("move_barrier_up")-Input.get_action_strength("move_barrier_down")
	)
	
	var angle = 0
	if Input.get_connected_joypads():
		angle = joystickPos.angle() if (joystickPos.length() >= 0.4)	else self.rotation 
	else:
		angle = self.global_position.angle_to_point(mousePos)
		
	var weight = min( (2*PI+2) / (abs(self.rotation - angle)*10+2*PI), 1 ) 
	self.rotation = lerp_angle(self.rotation,angle,weight )
	
	pre_joystickpos = joystickPos

	pass
	
func _setBarrier():
	var points = _calculateCircle(radius)
	$Polygon2D.polygon = points
	$LightOccluder2D.occluder.polygon = points
	$CollisionPolygon2D.polygon = points
	pass
	
	
func _calculateCircle(radius):
	var points = PoolVector2Array()
	for i in range(60):
		points.push_back(Vector2(radius*cos(deg2rad((60-2*i)*health + 180)), radius*sin(deg2rad((60-2*i)*health+180))))
	for j in range(60):
		points.push_back(Vector2((radius-5)*cos(deg2rad((-60+2*j)*health +180)), (radius-5)*sin(deg2rad((-60+2*j)*health+180))))	
	return points
	pass
