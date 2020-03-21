extends Control

export (Array, Texture) var splashes
export (float) var splash_wait_time = 1.0


var current_splash = 0
var start_color = Color(1.0, 1.0, 1.0, 1.0)
var end_color = Color(1.0, 1.0, 1.0, 0.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	_show_splash()
	pass # Replace with function body.

func _show_splash():
	$ColorRect/CenterContainer/TextureRect.texture = splashes[current_splash]
	$ColorRect/Tween.interpolate_property($ColorRect/CenterContainer/TextureRect, "modulate", end_color, start_color, 0.4)
	$ColorRect/Tween.start()
	yield($ColorRect/Tween,"tween_completed")
	yield(get_tree().create_timer(splash_wait_time), "timeout")
	$ColorRect/Tween.interpolate_property($ColorRect/CenterContainer/TextureRect, "modulate", start_color, end_color, 0.4)
	$ColorRect/Tween.start()
	yield($ColorRect/Tween,"tween_completed")
	if current_splash < splashes.size() - 1:
		current_splash += 1;
		_show_splash()
	else:
		get_tree().change_scene("res://Scenes/main.tscn")
		return
	pass
