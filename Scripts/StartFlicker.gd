extends Node2D


var glowRadius = 10
var player
var player_distance
var reached = false

signal damage_burst

func _ready():
	_get_player()
	connect("damage_burst",player,"_on_damage_burst")
	pass # Replace with function body.


# warning-ignore:unused_argument
func _process(delta):
	_explode()
	player_distance =  player.global_position.distance_to(self.global_position)
	if (glowRadius > player_distance && not reached):
		_check_collision()
	pass

func _explode():
	if ($Star.texture_scale < 1.5):
		$Star.texture_scale += 0.035
		$Star.rotation += 0.15
	elif($Star.energy >= 0):
		$Star.texture_scale += 1
		$Star.energy -= 0.3
		$Star.rotation += 0.1
		$Star/Glow.texture_scale += 0.3
		$Star/Glow.energy -= 0.1
		glowRadius += 15
	elif ($Star/Glow.energy >= 0):
		$Star/Glow.texture_scale += 0.3
		$Star/Glow.energy -= 0.1
		glowRadius += 35
	else:
		queue_free()
	pass
	
func _check_collision():
	reached = true
	$RayCast2D.set_cast_to(player.global_position - self.global_position)
	yield(get_tree().create_timer(0.017), "timeout")
	if not $RayCast2D.is_colliding():
		emit_signal("damage_burst")
	pass
		
func _get_player():
	player = get_tree().get_nodes_in_group("Player")[0]
	pass
