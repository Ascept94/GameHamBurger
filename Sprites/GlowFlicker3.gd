extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _process(delta):
	self.energy = (sin((OS.get_ticks_usec()*0.00001))+4)/2
	self.texture_scale = (cos((OS.get_ticks_usec()*0.000015))+20)/30

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
