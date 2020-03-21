extends Node2D

export var speed: float
export var radius: float


var check_bounds: bool

var angle: float
var direction: Vector2
var player

signal damage

func _ready():
	randomize()
	_get_player()
	_set_angle()
	connect("damage",player,"_on_damage")
	pass

func _get_player():
	player = get_tree().get_nodes_in_group("Player")[0]
	pass
func _process(delta):
	if check_bounds:
		_check_screen_bounds()
	
	_check_distance()
	_move(delta)
	pass
	
func _set_angle():
	direction =	(player.global_position - self.global_position).normalized()
	pass
	
func _check_distance():
	var player_distance = player.global_position.distance_to(self.global_position)
	if player_distance < radius:
		$RayCast2D.set_cast_to((player.global_position - self.global_position))
		#yield(get_tree().create_timer(0.001), "timeout")
		if not $RayCast2D.is_colliding():
			emit_signal("damage", player_distance)
	pass
func _check_screen_bounds():
	var window_size = get_viewport().size
	if global_position.y > window_size.y:
		direction = direction.bounce(Vector2.DOWN)
	if global_position.y < 0:
		direction = direction.bounce(Vector2.UP)
	if global_position.x > window_size.x:
		direction = direction.bounce(Vector2.LEFT)
	if global_position.x < 0:
		direction = direction.bounce(Vector2.RIGHT)
	pass

func _move(delta):
	position += direction * speed * delta
	pass

func _on_Area2D_area_entered(area):
	var difference: Vector2 = self.global_position - area.global_position
	direction = direction.bounce(difference.normalized())
	_move(0.01)
	pass # Replace with function body.


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	yield(get_tree().create_timer(0.75), "timeout")
	check_bounds = true
	pass # Replace with function body.
