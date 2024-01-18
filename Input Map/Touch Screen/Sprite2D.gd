extends Sprite2D


func _input(event):
	if Input.is_action_just_pressed("rotate") :
		self.rotation = PI/2
		print(rotate)	
