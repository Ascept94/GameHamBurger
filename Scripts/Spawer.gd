extends Node2D

export var spaw_distance: float
export var light: PackedScene
export var star: PackedScene

enum DIRECTIONS{UP, DOWN, LEFT, RIGHT}

func _ready():
	randomize()
	pass

func _on_Timer_timeout():
	_spawn_light()
	pass

func _on_StarTimer_timeout():
	_spawn_star()
	pass
	
func _spawn_light():
	var WindowSize = get_viewport().size
	var obj = light.instance()
	var direction = DIRECTIONS.values()[randi() % DIRECTIONS.size()]
	var spawn_pos

	if direction == DIRECTIONS.UP:
		spawn_pos = Vector2(rand_range(0, WindowSize.x), - spaw_distance)
	
	elif direction == DIRECTIONS.DOWN:
		spawn_pos = Vector2(rand_range(0, WindowSize.x), WindowSize.y + spaw_distance)	
	
	elif direction == DIRECTIONS.LEFT:
		spawn_pos = Vector2(- spaw_distance, rand_range(0, WindowSize.y))
	
	elif direction == DIRECTIONS.RIGHT:
		spawn_pos = Vector2(WindowSize.x + spaw_distance, rand_range(0, WindowSize.y))
	
	obj.global_position = spawn_pos
	add_child(obj)
	pass
	
func _spawn_star():
	var WindowSize = get_viewport().size
	var obj = star.instance()
	var spawn_pos
	spawn_pos = Vector2(rand_range(0, WindowSize.x), rand_range(0, WindowSize.y))
	obj.global_position = spawn_pos
	print(spawn_pos)
	add_child(obj)
	pass


func _on_OffsetTimer_timeout():
	_spawn_star()
	$StarTimer.start()
	pass # Replace with function body.
