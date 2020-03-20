extends Node2D

export var spaw_distance: float
export var light: PackedScene

enum DIRECTIONS{UP, DOWN, LEFT, RIGHT}

func _ready():
	randomize()
	pass

func _on_Timer_timeout():
	_spawn_light()
	pass

func _spawn_light():
	$Timer.wait_time = 30
	var viewport_size = get_viewport().size
	var obj = light.instance()
	var direction = DIRECTIONS.values()[randi() % DIRECTIONS.size()]
	var spawn_pos

	if direction == DIRECTIONS.UP:
		spawn_pos = Vector2(rand_range(0, viewport_size.x), - spaw_distance)
	
	elif direction == DIRECTIONS.DOWN:
		spawn_pos = Vector2(rand_range(0, viewport_size.x), viewport_size.y + spaw_distance)	
	
	elif direction == DIRECTIONS.LEFT:
		spawn_pos = Vector2(- spaw_distance, rand_range(0, viewport_size.y))
	
	elif direction == DIRECTIONS.RIGHT:
		spawn_pos = Vector2(viewport_size.x + spaw_distance, rand_range(0, viewport_size.y))
	
	obj.global_position = spawn_pos
	add_child(obj)
	pass
