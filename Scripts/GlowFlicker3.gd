extends Light2D


func _process(delta):
	self.energy = (sin((OS.get_ticks_usec()*0.00001))+4)/2
	self.texture_scale = (cos((OS.get_ticks_usec()*0.000015))+20)/30
	pass
