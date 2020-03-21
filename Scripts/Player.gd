extends Node2D

export var radius: float = 30
export var semiCircle = PoolVector2Array()
export var health: float = 1
export var speed: float = 15000

var pre_joystickpos: Vector2  = Vector2()
var camera: Camera2D	

func _ready():
	_setBarrier()
	camera = get_tree().get_nodes_in_group("Camera")[0]
	pass

func _process(delta):
	_moveBarrier()
	_movePlayer(delta)
	_isNearBounds()
	pass
	
func _physics_process(delta):
	if (health <= 0):
		_game_over()
	elif (health < 1):
		health += 0.0004
	_setBarrier()
	pass

func _movePlayer(delta):
	var step: Vector2 = Vector2(
		Input.get_action_strength("move_right")-Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down")-Input.get_action_strength("move_up")
	)
	
	self.position = _isInBounds(self.position + step * speed * delta )
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
	
	angle = _normalizeAngle(angle)
	self.rotation = _normalizeAngle(self.rotation)
	var weight = min( (2*PI+2) / (abs(self.rotation - angle)*10+2*PI), 1 ) 
	self.rotation = lerp_angle(self.rotation,angle,weight )
	
	pre_joystickpos = joystickPos

	pass
	
func _isInBounds(newPos):
	var window_size = OS.window_size
	
	if (newPos.y > window_size.y || newPos.y < 0):
		newPos.y = self.position.y		
	if (newPos.x > window_size.x || newPos.x < 0):
		newPos.x = self.position.x
	
	return newPos
	
func _isNearBounds():
	var window_size = OS.window_size
	
	if (self.position.y > window_size.y-50 || self.position.y < 50):
		health -= 0.0025		
	elif (self.position.x > window_size.x-50 || self.position.x < 50):
		health -= 0.0025		
	
	
func _setBarrier():
	var points = _calculateCircle(radius)
	$Polygon2D.polygon = points
	$LightOccluder2D.occluder.polygon = points
	$BarrierArea/CollisionPolygon2D.polygon = points
	pass
	
	
func _calculateCircle(radius):
	var points = PoolVector2Array()
	for i in range(60):
		points.push_back(Vector2(radius*cos(deg2rad((60-2*i)*health + 180)), radius*sin(deg2rad((60-2*i)*health+180))))
	for j in range(60):
		points.push_back(Vector2((radius-5)*cos(deg2rad((-60+2*j)*health +180)), (radius-5)*sin(deg2rad((-60+2*j)*health+180))))	
	return points
	pass

func _normalizeAngle(angle):
	while(angle > 2*PI):
		angle -= 2*PI
	while(angle < 0):
		angle += 2*PI
		
	return angle
	pass

func _on_damage(distance):
	health -= 0.001*(5-distance/100)
	#_setBarrier()
	pass # Replace with function body.
	
func _on_damage_burst():
	health -= 0.1
	pass
	
func _game_over():
	print("game over")
	get_tree().quit()
	pass
